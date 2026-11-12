import 'dart:convert';
import 'dart:io';

import 'package:credit_card_manager/core/errors/app_failure.dart';
import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/repositories/bank_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/category_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/credit_card_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/email_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/import_repositories_impl.dart';
import 'package:credit_card_manager/data/repositories/statement_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/transaction_repository_impl.dart';
import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/domain/entities/statement.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/domain/services/import_service.dart';
import 'package:credit_card_manager/integrations/pdf/password_strategy.dart';
import 'package:credit_card_manager/integrations/pdf/pdf_text_extractor.dart';
import 'package:credit_card_manager/integrations/pdf/statement_import_service.dart';
import 'package:credit_card_manager/integrations/storage/encrypted_file_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../fakes/in_memory_file_key_provider.dart';
import '../fakes/in_memory_key_provider.dart';

class _FakePdfTextExtractor implements PdfTextExtractor {
  _FakePdfTextExtractor({
    required this.text,
    this.requiredPassword,
    this.failure,
  });

  final String text;
  final String? requiredPassword;
  final Object? failure;
  final List<String?> passwords = <String?>[];

  @override
  Future<String> extract({required List<int> bytes, String? password}) async {
    passwords.add(password);
    if (failure != null) throw failure!;
    if (requiredPassword != null && password != requiredPassword) {
      throw const PdfPasswordException();
    }
    return text;
  }
}

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late EncryptedFileStore files;
  late BankRepositoryImpl banks;
  late CreditCardRepositoryImpl cards;
  late TransactionRepositoryImpl transactions;
  late StatementRepositoryImpl statements;
  late ReviewRepositoryImpl reviews;
  late ImportJobRepositoryImpl jobs;
  late BankRuleRepositoryImpl bankRules;
  late ImportService importer;

  final now = DateTime.utc(2026, 11, 5);
  final pdfBytes = utf8.encode('%PDF-1.4\nsynthetic statement bytes\n');

  Bank bank(String id, String name) => Bank(
    id: id,
    displayName: name,
    countryCode: 'IN',
    region: 'India',
    createdAt: now,
    updatedAt: now,
  );

  CreditCard card({
    String id = 'card_1',
    String bankId = 'bank_1',
    String lastFour = '4242',
  }) {
    return CreditCard(
      id: id,
      bankId: bankId,
      displayName: id,
      network: CardNetwork.visa,
      lastFour: lastFour,
      creditLimitMinor: 1000000,
      currencyCode: 'INR',
      status: CardStatus.active,
      createdAt: now,
      updatedAt: now,
    );
  }

  StatementImportService service(PdfTextExtractor extractor) {
    return StatementImportService(
      files: files,
      extractor: extractor,
      statements: statements,
      importer: importer,
      reviews: reviews,
      jobs: jobs,
      transactions: transactions,
      cards: cards,
      banks: banks,
      bankRules: bankRules,
    );
  }

  const reconciledStatement = '''
HDFC Bank Credit Card Statement
Statement Date: 05/11/2026
Payment Due Date: 25/11/2026
Statement Period: 06/10/2026 to 05/11/2026
Card ending 4242
Currency: INR
Previous Balance 10,000.00
Total Amount Due 13,500.50
Minimum Amount Due 1,350.05
05/10/2026 Coffee House 1,250.50
07/10/2026 Amazon Purchase 2,000.00
10/10/2026 Refund 500.00 Cr
12/10/2026 Annual Fee 750.00 DR
''';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_statement_import');
    database = await openEncryptedDatabase(
      file: File(p.join(tempDir.path, 'ccm.sqlite')),
      keyProvider: InMemoryKeyProvider(),
      background: false,
    );
    files = EncryptedFileStore(
      keyProvider: InMemoryFileKeyProvider(),
      directoryProvider: () async => tempDir,
    );
    banks = BankRepositoryImpl(database);
    cards = CreditCardRepositoryImpl(database);
    transactions = TransactionRepositoryImpl(database);
    statements = StatementRepositoryImpl(database);
    reviews = ReviewRepositoryImpl(database);
    jobs = ImportJobRepositoryImpl(database);
    bankRules = BankRuleRepositoryImpl(database);
    importer = ImportService(
      transactions: transactions,
      jobs: jobs,
      reviews: reviews,
      cards: cards,
      banks: banks,
      categories: CategoryRepositoryImpl(database),
    );

    await banks.upsert(bank('bank_1', 'Alpha Bank'));
    await cards.upsert(card());
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  test('imports, matches, reconciles, and records statement rows', () async {
    final extractor = _FakePdfTextExtractor(text: reconciledStatement);
    final result = await service(extractor).importBytes(
      bytes: pdfBytes,
      fileName: 'october-statement.pdf',
      bankHint: 'Alpha Bank',
    );

    expect(result.duplicate, isFalse);
    expect(result.imported, 4);
    expect(result.requiresReview, 0);
    expect(result.statement.cardId, 'card_1');
    expect(result.statement.bankId, 'bank_1');
    expect(result.statement.totalDueMinor, 1350050);
    expect(result.statement.minimumDueMinor, 135005);
    expect(result.statement.previousBalanceMinor, 1000000);
    expect(result.statement.currencyCode, 'INR');
    expect(
      result.statement.processingStatus,
      StatementProcessingStatus.reconciled,
    );
    expect(result.statement.parserId, 'generic-statement');
    expect(extractor.passwords, [null]);

    final stored = await statements.getById(result.statement.id);
    expect(stored!.processingStatus, StatementProcessingStatus.reconciled);
    expect(await statements.findByHash(stored.fileHash), isNotNull);

    final extracted = await statements.transactionsFor(result.statement.id);
    expect(extracted, hasLength(4));
    expect(
      extracted.map((row) => row.matchStatus),
      everyElement(StatementMatchStatus.matched),
    );
    expect(extracted.first.amountMinor, 125050);
    expect(extracted[2].amountMinor, -50000);
    expect(extracted[2].transactionType, TransactionType.refund);

    final ledger = await transactions.search();
    expect(ledger, hasLength(4));
    expect(ledger.every((tx) => tx.cardId == 'card_1'), isTrue);
    expect(
      ledger
          .where((tx) => tx.transactionType == TransactionType.refund)
          .single
          .amountMinor,
      -50000,
    );

    final recentJobs = await jobs.recent();
    expect(recentJobs.first.status.name, 'completed');
    expect(recentJobs.first.recordsImported, 4);
    expect(await reviews.countOpen(), 0);
    expect(await files.listNames(), hasLength(1));
  });

  test('retries extraction with a rule-derived password', () async {
    await bankRules.save(
      BankRule(
        id: 'bank_rule_1',
        bankId: 'bank_1',
        ruleType: 'name_prefix_and_birth_date',
        configurationVersion: '1',
        configuration:
            '{"strategy":"name_prefix_and_birth_date","parameters":'
            '{"nameCharacters":4,"dateFormat":"ddMM"}}',
        status: 'active',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final extractor = _FakePdfTextExtractor(
      text: reconciledStatement,
      requiredPassword: 'alic0703',
    );

    final result = await service(extractor).importBytes(
      bytes: pdfBytes,
      fileName: 'statement.pdf',
      bankHint: 'Alpha Bank',
      passwordInputs: StatementPasswordInputs(
        name: 'Alice Smith',
        dateOfBirth: DateTime(1985, 3, 7),
      ),
    );

    expect(result.imported, 4);
    expect(extractor.passwords, [null, 'alic0703']);
    expect(
      result.statement.processingStatus,
      StatementProcessingStatus.reconciled,
    );
  });

  test('returns the existing statement for a duplicate file hash', () async {
    final first = await service(
      _FakePdfTextExtractor(text: reconciledStatement),
    ).importBytes(bytes: pdfBytes, fileName: 'statement.pdf');

    final second = await service(_FakePdfTextExtractor(text: 'ignored'))
        .importBytes(bytes: pdfBytes, fileName: 'statement.pdf');

    expect(second.duplicate, isTrue);
    expect(second.statement.id, first.statement.id);
    expect(second.imported, 0);
    expect(second.skipped, 0);
    expect(second.requiresReview, 0);
    expect(await statements.getAll(), hasLength(1));
    expect(await files.listNames(), hasLength(1));
  });

  test(
    'keeps a password-protected file for review when no rule works',
    () async {
      final extractor = _FakePdfTextExtractor(
        text: '',
        failure: const PdfPasswordException(),
      );

      final result = await service(extractor).importBytes(
        bytes: pdfBytes,
        fileName: 'locked.pdf',
        bankHint: 'Alpha Bank',
        cardLastFour: '4242',
      );

      expect(result.imported, 0);
      expect(result.requiresReview, 1);
      expect(result.statement.cardId, 'card_1');
      expect(result.statement.bankId, 'bank_1');
      expect(
        result.statement.processingStatus,
        StatementProcessingStatus.needsReview,
      );
      expect(result.statement.encryptedFilePath, isNotEmpty);
      expect(
        await files.readEncrypted(result.statement.encryptedFilePath),
        pdfBytes,
      );

      final review = (await reviews.listOpen()).single;
      expect(review.reasonCode, 'statement_password');
      expect(review.entityType, 'statement');
      expect(review.entityId, result.statement.id);
      expect(await transactions.count(const TransactionFilter()), 0);
    },
  );

  test('keeps an unreadable file for review when extraction fails', () async {
    final extractor = _FakePdfTextExtractor(
      text: '',
      failure: PdfExtractionException(cause: StateError('synthetic failure')),
    );

    final result = await service(extractor)
        .importBytes(bytes: pdfBytes, fileName: 'broken.pdf');

    expect(result.requiresReview, 1);
    expect(
      result.statement.processingStatus,
      StatementProcessingStatus.needsReview,
    );
    final review = (await reviews.listOpen()).single;
    expect(review.reasonCode, 'statement_extraction');
    expect(await transactions.count(const TransactionFilter()), 0);
  });

  test(
    'flags a statement whose lines do not reconcile with the total',
    () async {
      const mismatched = '''
Statement Date: 05/11/2026
Payment Due Date: 25/11/2026
Statement Period: 06/10/2026 to 05/11/2026
Card ending 4242
Currency: INR
Previous Balance 1,000.00
Total Amount Due 9,999.00
Minimum Amount Due 100.00
05/10/2026 Coffee House 1,250.50
''';

      final result = await service(_FakePdfTextExtractor(text: mismatched))
          .importBytes(bytes: pdfBytes, fileName: 'statement.pdf');

      expect(result.imported, 1);
      expect(result.requiresReview, 1);
      expect(
        result.statement.processingStatus,
        StatementProcessingStatus.needsReview,
      );
      final review = (await reviews.listOpen()).single;
      expect(review.reasonCode, 'statement_total_mismatch');
      expect(review.details, contains('expectedMinor'));
      expect(
        await statements.transactionsFor(result.statement.id),
        hasLength(1),
      );
    },
  );

  test('flags an unmatched card on the statement', () async {
    await cards.archive('card_1');
    await banks.upsert(bank('bank_2', 'Beta Bank'));
    await cards.upsert(card(id: 'card_2', bankId: 'bank_2', lastFour: '1111'));

    final result = await service(
      _FakePdfTextExtractor(text: reconciledStatement),
    ).importBytes(bytes: pdfBytes, fileName: 'statement.pdf');

    expect(result.statement.cardId, isNull);
    expect(result.statement.bankId, isNull);
    expect(
      result.statement.processingStatus,
      StatementProcessingStatus.needsReview,
    );
    final reasons = (await reviews.listOpen()).map((row) => row.reasonCode);
    expect(reasons, contains('statement_card_unmatched'));
  });

  test('rejects empty, oversized, and non-PDF input', () async {
    final extractor = _FakePdfTextExtractor(text: reconciledStatement);
    final subject = service(extractor);

    await expectLater(
      subject.importBytes(bytes: const [], fileName: 'empty.pdf'),
      throwsA(
        isA<AppFailure>().having((error) => error.code, 'code', 'CCM-PDF-001'),
      ),
    );
    await expectLater(
      subject.importBytes(bytes: [1, 2, 3, 4], fileName: 'not.pdf'),
      throwsA(
        isA<AppFailure>().having((error) => error.code, 'code', 'CCM-PDF-002'),
      ),
    );
    await expectLater(
      subject.importBytes(
        bytes: List<int>.filled(subject.maxBytes + 1, 0),
        fileName: 'huge.pdf',
      ),
      throwsA(
        isA<AppFailure>().having((error) => error.code, 'code', 'CCM-PDF-001'),
      ),
    );

    expect(await files.listNames(), isEmpty);
    expect(await statements.getAll(), isEmpty);
  });
}
