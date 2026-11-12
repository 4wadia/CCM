// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'dart:math';

import '../../core/errors/app_failure.dart';
import '../../domain/entities/bank.dart';
import '../../domain/entities/email_account.dart';
import '../../domain/entities/import_job.dart';
import '../../domain/entities/statement.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/credit_card_repository.dart';
import '../../domain/repositories/email_account_repository.dart';
import '../../domain/repositories/import_job_repository.dart';
import '../../domain/repositories/statement_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/services/card_matcher.dart';
import '../../domain/services/ids.dart';
import '../../domain/services/import_service.dart';
import '../storage/encrypted_file_store.dart';
import 'password_strategy.dart';
import 'pdf_text_extractor.dart';
import 'statement_parser.dart';

class StatementImportResult {
  const StatementImportResult({
    required this.statement,
    required this.imported,
    required this.skipped,
    required this.requiresReview,
    this.duplicate = false,
  });

  final Statement statement;
  final int imported;
  final int skipped;
  final int requiresReview;
  final bool duplicate;
}

class StatementParserRegistry {
  const StatementParserRegistry({
    this.parsers = const <StatementParser>[GenericStatementParser()],
  });

  final List<StatementParser> parsers;

  StatementParser select(String text, {String? bankHint}) {
    for (final parser in parsers) {
      if (parser.canParse(text, bankHint: bankHint)) return parser;
    }
    return const GenericStatementParser();
  }
}

/// Local statement pipeline: validate, encrypt, resolve password with declarative
/// rules, extract, parse, match card, import, reconcile, and review.
class StatementImportService {
  StatementImportService({
    required EncryptedFileStore files,
    required PdfTextExtractor extractor,
    required StatementRepository statements,
    required ImportService importer,
    required ReviewRepository reviews,
    required ImportJobRepository jobs,
    required TransactionRepository transactions,
    required CreditCardRepository cards,
    required BankRepository banks,
    required BankRuleRepository bankRules,
    this.parsers = const StatementParserRegistry(),
    this.maxBytes = 25 * 1024 * 1024,
  }) : _files = files,
       _extractor = extractor,
       _statements = statements,
       _importer = importer,
       _reviews = reviews,
       _jobs = jobs,
       _transactions = transactions,
       _cards = cards,
       _banks = banks,
       _bankRules = bankRules;

  final EncryptedFileStore _files;
  final PdfTextExtractor _extractor;
  final StatementRepository _statements;
  final ImportService _importer;
  final ReviewRepository _reviews;
  final ImportJobRepository _jobs;
  final TransactionRepository _transactions;
  final CreditCardRepository _cards;
  final BankRepository _banks;
  final BankRuleRepository _bankRules;
  final StatementParserRegistry parsers;
  final int maxBytes;

  Future<StatementImportResult> importBytes({
    required List<int> bytes,
    required String fileName,
    String? bankHint,
    String? cardLastFour,
    StatementPasswordInputs passwordInputs = const StatementPasswordInputs(),
    TransactionSourceType sourceType = TransactionSourceType.pdfStatement,
  }) async {
    if (bytes.isEmpty || bytes.length > maxBytes) {
      throw const AppFailure(
        code: 'CCM-PDF-001',
        message: 'The statement file is empty or too large.',
      );
    }
    if (!_looksLikePdf(bytes)) {
      throw const AppFailure(
        code: 'CCM-PDF-002',
        message: 'Only PDF statements can be imported.',
      );
    }
    final hash = sha256Hex(bytes);
    final duplicate = await _statements.findByHash(hash);
    if (duplicate != null) {
      return StatementImportResult(
        statement: duplicate,
        imported: 0,
        skipped: 0,
        requiresReview:
            duplicate.processingStatus == StatementProcessingStatus.needsReview
            ? 1
            : 0,
        duplicate: true,
      );
    }

    final now = DateTime.now().toUtc();
    final encryptedName = await _files.writeEncrypted(
      bytes: bytes,
      suggestedName: fileName,
    );
    final cards = await _cards.getAll(includeArchived: false);
    final banks = await _banks.getAll();
    final bank = _identifyBank(bankHint, banks);
    final rules = bank == null
        ? const <BankRule>[]
        : await _bankRules.forBank(bank.id);
    final candidates = PasswordStrategyEngine.candidates(
      rules: rules,
      inputs: passwordInputs,
    );
    final fallbackDate = DateTime(now.year, now.month, now.day);
    final cardFallback = cards.where((card) => card.lastFour == cardLastFour);

    String? text;
    Object? extractionError;
    final passwordAttempts = <String?>[null, ...candidates];
    for (final password in passwordAttempts) {
      try {
        text = await _extractor.extract(bytes: bytes, password: password);
        break;
      } on PdfPasswordException {
        extractionError = const PdfPasswordException();
      } on PdfExtractionException catch (error) {
        extractionError = error;
        break;
      }
    }

    if (text == null || text.trim().isEmpty) {
      final statement = await _saveFallbackStatement(
        hash: hash,
        encryptedName: encryptedName,
        bytes: bytes,
        fallbackDate: fallbackDate,
        bankId: bank?.id,
        cardId: cardFallback.length == 1 ? cardFallback.single.id : null,
        currencyCode: cardFallback.length == 1
            ? cardFallback.single.currencyCode
            : 'INR',
        status: StatementProcessingStatus.needsReview,
        sourceType: sourceType,
        reason: extractionError is PdfPasswordException
            ? 'statement_password'
            : 'statement_extraction',
        message: extractionError is PdfPasswordException
            ? 'The statement is password-protected and no approved password '
                  'rule produced a readable file. Add the password in review.'
            : 'The statement text could not be extracted. The encrypted file '
                  'was kept for review.',
      );
      return StatementImportResult(
        statement: statement,
        imported: 0,
        skipped: 0,
        requiresReview: 1,
      );
    }

    final parser = parsers.select(
      text,
      bankHint: bank?.displayName ?? bankHint,
    );
    final parsed = parser.parse(
      text: text,
      fallbackDate: fallbackDate,
      defaultCurrency: cardFallback.length == 1
          ? cardFallback.single.currencyCode
          : 'INR',
      cardLastFour: cardLastFour,
      bankHint: bank?.displayName ?? bankHint,
    );
    final match = CardMatcher.match(
      lastFour: parsed.cardLastFour,
      bankHint: parsed.bankHint,
      cards: cards,
      banks: banks,
    );
    final cardId =
        match.card?.id ??
        (cardFallback.length == 1 ? cardFallback.single.id : null);
    final currency = match.card?.currencyCode ?? parsed.currencyCode;

    final statement = Statement(
      id: Ids.next('statement'),
      cardId: cardId,
      bankId: match.card?.bankId ?? bank?.id,
      statementPeriodStart: parsed.periodStart,
      statementPeriodEnd: parsed.periodEnd,
      statementDate: parsed.statementDate,
      paymentDueDate: parsed.paymentDueDate,
      previousBalanceMinor: parsed.previousBalanceMinor,
      totalDueMinor: parsed.totalDueMinor,
      minimumDueMinor: parsed.minimumDueMinor,
      currencyCode: currency,
      encryptedFilePath: encryptedName,
      fileHash: hash,
      fileSizeBytes: bytes.length,
      processingStatus: StatementProcessingStatus.processing,
      parserId: parser.id,
      parserVersion: parser.version,
      createdAt: now,
      updatedAt: now,
    );
    await _statements.save(statement);

    var reviewCount = 0;
    if (!match.matched) {
      reviewCount++;
      await _reviews.add(
        ReviewItem(
          id: Ids.next('review'),
          entityType: 'statement',
          entityId: statement.id,
          sourceType: sourceType.name,
          sourceReference: 'statement:${statement.id}',
          reasonCode: match.ambiguous
              ? 'statement_card_ambiguous'
              : 'statement_card_unmatched',
          userMessage: match.ambiguous
              ? 'More than one card could match this statement. Choose the card.'
              : 'No card could be matched to this statement. Choose the card.',
          details: jsonEncode(<String, Object?>{
            'statementId': statement.id,
            'cardLastFour': parsed.cardLastFour,
            'bankHint': parsed.bankHint,
          }),
          status: ReviewStatus.open,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }

    final records = <ParsedTransaction>[];
    for (var index = 0; index < parsed.transactions.length; index++) {
      final record = parsed.transactions[index];
      records.add(
        ParsedTransaction(
          description: record.description,
          amountMinor: record.amountMinor,
          currencyCode: currency,
          transactionDate: record.transactionDate,
          transactionType: record.transactionType,
          confidence: record.confidence,
          merchant: record.merchant,
          cardLastFour: match.card?.lastFour ?? parsed.cardLastFour,
          bankHint: match.card == null ? parsed.bankHint : null,
          sourceReference: 'statement:${statement.id}:$index',
          parserId: parser.id,
          parserVersion: parser.version,
          status: record.status,
        ),
      );
    }

    final result = await _importer.importParsed(
      sourceType: sourceType,
      records: records,
      sourceReferencePrefix: 'statement:${statement.id}',
      parserId: parser.id,
      parserVersion: parser.version,
    );

    for (var index = 0; index < records.length; index++) {
      final record = records[index];
      final source = await _transactions.findSource(
        sourceType: sourceType,
        sourceReference: record.sourceReference,
      );
      await _statements.saveStatementTransaction(
        StatementTransaction(
          id: Ids.next('stmt_tx'),
          statementId: statement.id,
          transactionId: source?.transactionId,
          description: record.description,
          merchantNormalized: record.merchant,
          amountMinor: record.signedAmountMinor,
          currencyCode: record.currencyCode,
          transactionDate: record.transactionDate,
          transactionType: record.transactionType,
          matchStatus: source?.matchStatus == SourceMatchStatus.ambiguous
              ? StatementMatchStatus.ambiguous
              : source?.transactionId == null
              ? StatementMatchStatus.unmatched
              : StatementMatchStatus.matched,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }

    final sum = records.fold<int>(
      0,
      (total, record) => total + record.signedAmountMinor,
    );
    final expected = parsed.previousBalanceMinor + sum;
    final tolerance = max(100, parsed.totalDueMinor ~/ 100);
    final reconciled =
        parsed.totalDueMinor == 0 ||
        records.isEmpty ||
        (expected - parsed.totalDueMinor).abs() <= tolerance;

    if (!reconciled) {
      reviewCount++;
      await _reviews.add(
        ReviewItem(
          id: Ids.next('review'),
          entityType: 'statement',
          entityId: statement.id,
          sourceType: sourceType.name,
          sourceReference: 'statement:${statement.id}',
          reasonCode: 'statement_total_mismatch',
          userMessage:
              'The statement transactions do not reconcile with the total due. '
              'Review the lines before relying on this statement.',
          details: jsonEncode(<String, Object?>{
            'expectedMinor': expected,
            'totalDueMinor': parsed.totalDueMinor,
            'transactionCount': records.length,
          }),
          status: ReviewStatus.open,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }

    final finalStatus = result.requiresReview > 0 || reviewCount > 0
        ? StatementProcessingStatus.needsReview
        : StatementProcessingStatus.reconciled;
    final saved = statement.copyWith(
      processingStatus: finalStatus,
      updatedAt: DateTime.now().toUtc(),
    );
    await _statements.save(saved);
    final combinedReview = result.requiresReview + reviewCount;
    await _jobs.save(
      result.job.copyWith(
        status: combinedReview > 0
            ? ImportJobStatus.completedWithReview
            : ImportJobStatus.completed,
        completedAt: DateTime.now().toUtc(),
        progress: 100,
        recordsRequiringReview: combinedReview,
      ),
    );

    return StatementImportResult(
      statement: saved,
      imported: result.imported,
      skipped: result.skipped,
      requiresReview: result.requiresReview + reviewCount,
    );
  }

  bool _looksLikePdf(List<int> bytes) {
    if (bytes.length < 5) return false;
    // Allow an optional UTF-8 BOM or leading whitespace.
    var index = 0;
    while (index < bytes.length && bytes[index] <= 0x20) {
      index++;
    }
    const marker = <int>[0x25, 0x50, 0x44, 0x46, 0x2D];
    if (index + marker.length > bytes.length) return false;
    for (var i = 0; i < marker.length; i++) {
      if (bytes[index + i] != marker[i]) return false;
    }
    return true;
  }

  Bank? _identifyBank(String? hint, List<Bank> banks) {
    final lower = hint?.toLowerCase().trim() ?? '';
    if (lower.isEmpty) return null;
    for (final bank in banks) {
      if (bank.displayName.toLowerCase().contains(lower) ||
          lower.contains(bank.displayName.toLowerCase())) {
        return bank;
      }
    }
    return null;
  }

  Future<Statement> _saveFallbackStatement({
    required String hash,
    required String encryptedName,
    required List<int> bytes,
    required DateTime fallbackDate,
    required String? bankId,
    required String? cardId,
    required String currencyCode,
    required StatementProcessingStatus status,
    required TransactionSourceType sourceType,
    required String reason,
    required String message,
  }) async {
    final statement = Statement(
      id: Ids.next('statement'),
      cardId: cardId,
      bankId: bankId,
      statementPeriodStart: fallbackDate.subtract(const Duration(days: 30)),
      statementPeriodEnd: fallbackDate,
      statementDate: fallbackDate,
      currencyCode: currencyCode,
      encryptedFilePath: encryptedName,
      fileHash: hash,
      fileSizeBytes: bytes.length,
      processingStatus: status,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    await _statements.save(statement);
    await _reviews.add(
      ReviewItem(
        id: Ids.next('review'),
        entityType: 'statement',
        entityId: statement.id,
        sourceType: sourceType.name,
        sourceReference: 'statement:${statement.id}',
        reasonCode: reason,
        userMessage: message,
        details: jsonEncode(<String, Object?>{'statementId': statement.id}),
        status: ReviewStatus.open,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    return statement;
  }
}

extension on ImportJob {
  ImportJob copyWith({
    ImportJobStatus? status,
    DateTime? completedAt,
    int? progress,
    int? recordsFound,
    int? recordsImported,
    int? recordsSkipped,
    int? recordsRequiringReview,
    String? errorCode,
  }) {
    return ImportJob(
      id: id,
      sourceType: sourceType,
      status: status ?? this.status,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      progress: progress ?? this.progress,
      recordsFound: recordsFound ?? this.recordsFound,
      recordsImported: recordsImported ?? this.recordsImported,
      recordsSkipped: recordsSkipped ?? this.recordsSkipped,
      recordsRequiringReview:
          recordsRequiringReview ?? this.recordsRequiringReview,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
