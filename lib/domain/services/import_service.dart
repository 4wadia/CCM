// ignore_for_file: prefer_initializing_formals
import 'dart:convert';

import '../entities/bank.dart';
import '../entities/credit_card.dart';
import '../entities/import_job.dart';
import '../entities/transaction.dart';
import '../entities/transaction_category.dart';
import '../repositories/bank_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/credit_card_repository.dart';
import '../repositories/import_job_repository.dart';
import '../repositories/transaction_repository.dart';
import 'card_matcher.dart';
import 'category_classifier.dart';
import 'ids.dart';
import 'merchant_normalizer.dart';
import 'transaction_fingerprint.dart';

class ImportResult {
  const ImportResult({
    required this.job,
    required this.imported,
    required this.skipped,
    required this.requiresReview,
  });

  final ImportJob job;
  final int imported;
  final int skipped;
  final int requiresReview;
}

/// Idempotent import orchestration shared by SMS, Gmail, PDF, and manual paths.
///
/// Every record is accounted for. A missing card, ambiguous card, or ambiguous
/// duplicate becomes a review item and leaves an auditable source row.
class ImportService {
  // Public names intentionally differ from private fields.
  ImportService({
    required TransactionRepository transactions,
    required ImportJobRepository jobs,
    required ReviewRepository reviews,
    required CreditCardRepository cards,
    required BankRepository banks,
    required CategoryRepository categories,
  }) : _transactions = transactions,
       _jobs = jobs,
       _reviews = reviews,
       _cards = cards,
       _banks = banks,
       _categories = categories;

  final TransactionRepository _transactions;
  final ImportJobRepository _jobs;
  final ReviewRepository _reviews;
  final CreditCardRepository _cards;
  final BankRepository _banks;
  final CategoryRepository _categories;

  Future<ImportResult> importParsed({
    required TransactionSourceType sourceType,
    required List<ParsedTransaction> records,
    String? sourceReferencePrefix,
    String? parserId,
    String? parserVersion,
  }) async {
    final now = DateTime.now().toUtc();
    final job = ImportJob(
      id: Ids.next('import'),
      sourceType: sourceType.name,
      status: ImportJobStatus.running,
      startedAt: now,
      recordsFound: records.length,
      recordsImported: 0,
      recordsSkipped: 0,
      recordsRequiringReview: 0,
      progress: 0,
    );
    await _jobs.save(job);

    final cards = await _cards.getAll(includeArchived: false);
    final banks = await _banks.getAll();
    final categories = await _categories.getAll();

    var imported = 0;
    var skipped = 0;
    var review = 0;

    try {
      for (var index = 0; index < records.length; index++) {
        final record = records[index];
        final sourceReference =
            record.sourceReference ??
            '${sourceReferencePrefix ?? sourceType.name}:$index';
        try {
          final outcome = await _importOne(
            record: record,
            sourceType: sourceType,
            sourceReference: sourceReference,
            jobId: job.id,
            cards: cards,
            banks: banks,
            categories: categories,
            parserId: parserId ?? record.parserId,
            parserVersion: parserVersion ?? record.parserVersion,
          );
          if (outcome.created) imported++;
          if (outcome.linkedExisting) skipped++;
          if (outcome.needsReview) review++;
        } catch (_) {
          review++;
          await _reviews.add(
            ReviewItem(
              id: Ids.next('review'),
              entityType: 'import_record',
              reasonCode: 'import_failed',
              userMessage:
                  'A record could not be imported and was kept for review.',
              sourceType: sourceType.name,
              sourceReference: sourceReference,
              details: _details(record),
              status: ReviewStatus.open,
              createdAt: DateTime.now().toUtc(),
            ),
          );
        }

        await _jobs.save(
          ImportJob(
            id: job.id,
            sourceType: job.sourceType,
            status: ImportJobStatus.running,
            startedAt: job.startedAt,
            recordsFound: records.length,
            recordsImported: imported,
            recordsSkipped: skipped,
            recordsRequiringReview: review,
            progress: ((index + 1) * 100 ~/ records.length),
          ),
        );
      }

      final completed = ImportJob(
        id: job.id,
        sourceType: job.sourceType,
        status: review > 0
            ? ImportJobStatus.completedWithReview
            : ImportJobStatus.completed,
        startedAt: job.startedAt,
        completedAt: DateTime.now().toUtc(),
        recordsFound: records.length,
        recordsImported: imported,
        recordsSkipped: skipped,
        recordsRequiringReview: review,
        progress: 100,
      );
      await _jobs.save(completed);
      return ImportResult(
        job: completed,
        imported: imported,
        skipped: skipped,
        requiresReview: review,
      );
    } catch (_) {
      await _jobs.save(
        ImportJob(
          id: job.id,
          sourceType: job.sourceType,
          status: ImportJobStatus.failed,
          startedAt: job.startedAt,
          completedAt: DateTime.now().toUtc(),
          recordsFound: records.length,
          recordsImported: imported,
          recordsSkipped: skipped,
          recordsRequiringReview: review,
          progress: 100,
          errorCode: 'import_failed',
        ),
      );
      rethrow;
    }
  }

  Future<_ImportOutcome> _importOne({
    required ParsedTransaction record,
    required TransactionSourceType sourceType,
    required String sourceReference,
    required String jobId,
    required List<CreditCard> cards,
    required List<Bank> banks,
    required List<TransactionCategory> categories,
    String? parserId,
    String? parserVersion,
  }) async {
    final existingSource = await _transactions.findSource(
      sourceType: sourceType,
      sourceReference: sourceReference,
    );
    if (existingSource != null) {
      return const _ImportOutcome(linkedExisting: true);
    }

    final match = CardMatcher.match(
      lastFour: record.cardLastFour,
      bankHint: record.bankHint,
      cards: cards,
      banks: banks,
    );
    final now = DateTime.now().toUtc();
    final normalizedMerchant = MerchantNormalizer.normalize(
      record.merchant ?? record.description,
    );
    final categoryId = CategoryClassifier.classify(
      '$normalizedMerchant ${record.description}',
      categories,
    );

    CardTransaction? existing;
    final fingerprint = TransactionFingerprint.compute(
      cardId: match.card?.id,
      amountMinor: record.signedAmountMinor,
      currencyCode: record.currencyCode,
      transactionDate: record.transactionDate,
      merchant: normalizedMerchant,
      type: record.transactionType,
    );

    if (match.matched && fingerprint != null) {
      existing = await _transactions.findByFingerprint(fingerprint);
      if (existing != null) {
        await _linkSource(
          existing: existing,
          record: record,
          sourceType: sourceType,
          sourceReference: sourceReference,
          jobId: jobId,
          parserId: parserId,
          parserVersion: parserVersion,
          now: now,
        );
        return const _ImportOutcome(linkedExisting: true);
      }

      final fuzzy = await _transactions.fuzzyCandidates(
        cardId: match.card!.id,
        amountMinor: record.signedAmountMinor,
        currencyCode: record.currencyCode,
        transactionDate: record.transactionDate,
      );
      final strong = fuzzy
          .where((candidate) {
            final candidateMerchant =
                candidate.merchantNormalized ??
                candidate.merchantOriginal ??
                '';
            return MerchantNormalizer.similarity(
                  normalizedMerchant,
                  candidateMerchant,
                ) >=
                0.6;
          })
          .toList(growable: false);

      if (strong.length == 1) {
        await _linkSource(
          existing: strong.single,
          record: record,
          sourceType: sourceType,
          sourceReference: sourceReference,
          jobId: jobId,
          parserId: parserId,
          parserVersion: parserVersion,
          now: now,
        );
        return const _ImportOutcome(linkedExisting: true);
      }
      if (strong.length > 1) {
        return _createReviewRecord(
          record: record,
          sourceType: sourceType,
          sourceReference: sourceReference,
          jobId: jobId,
          match: match,
          categories: categories,
          normalizedMerchant: normalizedMerchant,
          now: now,
          reasonCode: 'duplicate_ambiguous',
          message:
              'More than one existing transaction could match this record. '
              'Choose the correct one before it is reconciled.',
          parserId: parserId,
          parserVersion: parserVersion,
        );
      }
    }

    if (!match.matched) {
      return _createReviewRecord(
        record: record,
        sourceType: sourceType,
        sourceReference: sourceReference,
        jobId: jobId,
        match: match,
        categories: categories,
        normalizedMerchant: normalizedMerchant,
        now: now,
        reasonCode: match.ambiguous ? 'card_ambiguous' : 'card_unmatched',
        message: match.ambiguous
            ? 'More than one card could match this record. Assign the card.'
            : 'No card could be matched to this record. Assign the card.',
        parserId: parserId,
        parserVersion: parserVersion,
      );
    }

    final transaction = CardTransaction(
      id: Ids.next('tx'),
      cardId: match.card!.id,
      bankId: match.card!.bankId,
      merchantOriginal: record.merchant ?? record.description,
      merchantNormalized: normalizedMerchant,
      amountMinor: record.signedAmountMinor,
      currencyCode: record.currencyCode.toUpperCase(),
      transactionDate: record.transactionDate,
      postingDate: record.postingDate,
      transactionType: record.transactionType,
      categoryId: categoryId,
      status:
          record.status ??
          (record.confidence == SourceConfidence.low
              ? TransactionStatus.needsReview
              : TransactionStatus.posted),
      sourceConfidence: record.confidence,
      notes: record.notes,
      fingerprint: fingerprint,
      fingerprintVersion: fingerprint == null
          ? null
          : TransactionFingerprint.currentVersion,
      createdAt: now,
      updatedAt: now,
    );
    final source = TransactionSource(
      id: Ids.next('source'),
      transactionId: transaction.id,
      sourceType: sourceType,
      sourceReference: sourceReference,
      sourceDate: record.transactionDate,
      originalDescription: record.description,
      importJobId: jobId,
      parserId: parserId,
      parserVersion: parserVersion,
      matchStatus: transaction.status == TransactionStatus.needsReview
          ? SourceMatchStatus.ambiguous
          : SourceMatchStatus.created,
      createdAt: now,
    );
    await _transactions.insertWithSource(
      transaction: transaction,
      source: source,
    );
    if (transaction.status == TransactionStatus.needsReview) {
      await _reviews.add(
        ReviewItem(
          id: Ids.next('review'),
          entityType: 'transaction',
          entityId: transaction.id,
          sourceType: sourceType.name,
          sourceReference: sourceReference,
          reasonCode: 'low_confidence',
          userMessage:
              'This transaction was imported with low confidence. Confirm its '
              'card, amount, and category.',
          details: _details(record),
          status: ReviewStatus.open,
          createdAt: now,
        ),
      );
      return const _ImportOutcome(created: true, needsReview: true);
    }
    return const _ImportOutcome(created: true);
  }

  Future<_ImportOutcome> _createReviewRecord({
    required ParsedTransaction record,
    required TransactionSourceType sourceType,
    required String sourceReference,
    required String jobId,
    required CardMatch match,
    required List<TransactionCategory> categories,
    required String normalizedMerchant,
    required DateTime now,
    required String reasonCode,
    required String message,
    String? parserId,
    String? parserVersion,
  }) async {
    final transaction = CardTransaction(
      id: Ids.next('tx'),
      cardId: match.card?.id,
      bankId: match.card?.bankId,
      merchantOriginal: record.merchant ?? record.description,
      merchantNormalized: normalizedMerchant,
      amountMinor: record.signedAmountMinor,
      currencyCode: record.currencyCode.toUpperCase(),
      transactionDate: record.transactionDate,
      postingDate: record.postingDate,
      transactionType: record.transactionType,
      categoryId: CategoryClassifier.classify(
        '$normalizedMerchant ${record.description}',
        categories,
      ),
      status: record.status ?? TransactionStatus.needsReview,
      sourceConfidence: record.confidence,
      notes: record.notes,
      createdAt: now,
      updatedAt: now,
    );
    final source = TransactionSource(
      id: Ids.next('source'),
      transactionId: transaction.id,
      sourceType: sourceType,
      sourceReference: sourceReference,
      sourceDate: record.transactionDate,
      originalDescription: record.description,
      importJobId: jobId,
      parserId: parserId,
      parserVersion: parserVersion,
      matchStatus: SourceMatchStatus.ambiguous,
      createdAt: now,
    );
    await _transactions.insertWithSource(
      transaction: transaction,
      source: source,
    );
    await _reviews.add(
      ReviewItem(
        id: Ids.next('review'),
        entityType: 'transaction',
        entityId: transaction.id,
        sourceType: sourceType.name,
        sourceReference: sourceReference,
        reasonCode: reasonCode,
        userMessage: message,
        details: _details(record),
        status: ReviewStatus.open,
        createdAt: now,
      ),
    );
    return const _ImportOutcome(created: true, needsReview: true);
  }

  Future<void> _linkSource({
    required CardTransaction existing,
    required ParsedTransaction record,
    required TransactionSourceType sourceType,
    required String sourceReference,
    required String jobId,
    required DateTime now,
    String? parserId,
    String? parserVersion,
  }) async {
    await _transactions.linkSource(
      TransactionSource(
        id: Ids.next('source'),
        transactionId: existing.id,
        sourceType: sourceType,
        sourceReference: sourceReference,
        sourceDate: record.transactionDate,
        originalDescription: record.description,
        importJobId: jobId,
        parserId: parserId,
        parserVersion: parserVersion,
        matchStatus: SourceMatchStatus.linkedExisting,
        createdAt: now,
      ),
    );
  }

  String _details(ParsedTransaction record) {
    return jsonEncode(<String, Object?>{
      'description': record.description,
      'amountMinor': record.amountMinor,
      'currencyCode': record.currencyCode,
      'transactionDate': record.transactionDate.toIso8601String(),
      'transactionType': record.transactionType.name,
      'cardLastFour': record.cardLastFour,
      'bankHint': record.bankHint,
      'confidence': record.confidence.name,
    });
  }
}

class _ImportOutcome {
  const _ImportOutcome({
    this.created = false,
    this.linkedExisting = false,
    this.needsReview = false,
  });

  final bool created;
  final bool linkedExisting;
  final bool needsReview;
}
