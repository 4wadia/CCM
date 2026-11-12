import 'dart:io';

import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/repositories/bank_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/category_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/credit_card_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/import_repositories_impl.dart';
import 'package:credit_card_manager/data/repositories/transaction_repository_impl.dart';
import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/import_job.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/domain/services/import_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../fakes/in_memory_key_provider.dart';

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late BankRepositoryImpl banks;
  late CreditCardRepositoryImpl cards;
  late TransactionRepositoryImpl transactions;
  late ImportJobRepositoryImpl jobs;
  late ReviewRepositoryImpl reviews;
  late ImportService service;

  final now = DateTime.utc(2026, 11, 5);

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
    CardStatus status = CardStatus.active,
  }) {
    return CreditCard(
      id: id,
      bankId: bankId,
      displayName: id,
      network: CardNetwork.visa,
      lastFour: lastFour,
      creditLimitMinor: 1000000,
      currencyCode: 'INR',
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  ParsedTransaction record({
    String description = 'Coffee House',
    int amountMinor = 125050,
    TransactionType type = TransactionType.purchase,
    SourceConfidence confidence = SourceConfidence.high,
    String? cardLastFour = '4242',
    String? bankHint = 'Alpha Bank',
    String? sourceReference = 'sms:1',
    DateTime? date,
  }) {
    return ParsedTransaction(
      description: description,
      merchant: description,
      amountMinor: amountMinor,
      currencyCode: 'INR',
      transactionDate: date ?? now,
      transactionType: type,
      confidence: confidence,
      cardLastFour: cardLastFour,
      bankHint: bankHint,
      sourceReference: sourceReference,
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_import_test');
    database = await openEncryptedDatabase(
      file: File(p.join(tempDir.path, 'ccm.sqlite')),
      keyProvider: InMemoryKeyProvider(),
      background: false,
    );
    banks = BankRepositoryImpl(database);
    cards = CreditCardRepositoryImpl(database);
    transactions = TransactionRepositoryImpl(database);
    jobs = ImportJobRepositoryImpl(database);
    reviews = ReviewRepositoryImpl(database);
    service = ImportService(
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

  test('imports a high-confidence purchase with provenance', () async {
    final result = await service.importParsed(
      sourceType: TransactionSourceType.sms,
      records: [record()],
    );

    expect(result.imported, 1);
    expect(result.skipped, 0);
    expect(result.requiresReview, 0);
    expect(result.job.status, ImportJobStatus.completed);
    expect(result.job.recordsFound, 1);
    expect(result.job.recordsImported, 1);
    expect(result.job.progress, 100);

    final stored = (await transactions.search()).single;
    expect(stored.cardId, 'card_1');
    expect(stored.bankId, 'bank_1');
    expect(stored.amountMinor, 125050);
    expect(stored.currencyCode, 'INR');
    expect(stored.status, TransactionStatus.posted);
    expect(stored.sourceConfidence, SourceConfidence.high);
    expect(stored.fingerprint, isNotNull);
    expect(stored.fingerprintVersion, 1);
    expect(stored.categoryId, 'cat_dining');

    final sources = await transactions.sourcesFor(stored.id);
    expect(sources, hasLength(1));
    expect(sources.single.sourceType, TransactionSourceType.sms);
    expect(sources.single.sourceReference, 'sms:1');
    expect(sources.single.matchStatus, SourceMatchStatus.created);
    expect(sources.single.importJobId, result.job.id);
  });

  test(
    'links an exact duplicate fingerprint to the existing transaction',
    () async {
      await service.importParsed(
        sourceType: TransactionSourceType.sms,
        records: [record(sourceReference: 'sms:1')],
      );

      final duplicate = await service.importParsed(
        sourceType: TransactionSourceType.sms,
        records: [record(sourceReference: 'sms:2')],
      );

      expect(duplicate.imported, 0);
      expect(duplicate.skipped, 1);
      expect(duplicate.requiresReview, 0);
      expect(await transactions.count(const TransactionFilter()), 1);

      final stored = (await transactions.search()).single;
      final sources = await transactions.sourcesFor(stored.id);
      expect(sources, hasLength(2));
      expect(
        sources.map((source) => source.matchStatus),
        containsAll([
          SourceMatchStatus.created,
          SourceMatchStatus.linkedExisting,
        ]),
      );
    },
  );

  test('treats a repeated source reference as idempotent', () async {
    await service.importParsed(
      sourceType: TransactionSourceType.sms,
      records: [record(sourceReference: 'sms:1')],
    );
    final retry = await service.importParsed(
      sourceType: TransactionSourceType.sms,
      records: [record(sourceReference: 'sms:1')],
    );

    expect(retry.skipped, 1);
    expect(await transactions.count(const TransactionFilter()), 1);
    final stored = (await transactions.search()).single;
    expect(await transactions.sourcesFor(stored.id), hasLength(1));
  });

  test('creates review records for an ambiguous card match', () async {
    await banks.upsert(bank('bank_2', 'Beta Bank'));
    await cards.upsert(card(id: 'card_2', bankId: 'bank_2', lastFour: '4242'));

    final result = await service.importParsed(
      sourceType: TransactionSourceType.sms,
      records: [record(bankHint: null)],
    );

    expect(result.requiresReview, 1);
    expect(result.job.status, ImportJobStatus.completedWithReview);
    final stored = (await transactions.search()).single;
    expect(stored.status, TransactionStatus.needsReview);
    expect(stored.cardId, isNull);
    expect(await reviews.countOpen(), 1);
    final review = (await reviews.listOpen()).single;
    expect(review.reasonCode, 'card_ambiguous');
    expect(review.entityId, stored.id);
  });

  test('creates review records when no card matches', () async {
    final result = await service.importParsed(
      sourceType: TransactionSourceType.sms,
      records: [record(cardLastFour: '9999')],
    );

    expect(result.requiresReview, 1);
    final stored = (await transactions.search()).single;
    expect(stored.status, TransactionStatus.needsReview);
    final review = (await reviews.listOpen()).single;
    expect(review.reasonCode, 'card_unmatched');
    expect(review.sourceReference, 'sms:1');
  });

  test('creates review records for low-confidence matches', () async {
    final result = await service.importParsed(
      sourceType: TransactionSourceType.sms,
      records: [record(confidence: SourceConfidence.low)],
    );

    expect(result.imported, 1);
    expect(result.requiresReview, 1);
    final stored = (await transactions.search()).single;
    expect(stored.status, TransactionStatus.needsReview);
    expect(stored.cardId, 'card_1');
    final review = (await reviews.listOpen()).single;
    expect(review.reasonCode, 'low_confidence');
    expect(review.entityId, stored.id);
  });

  test('completes an empty import without dividing by zero', () async {
    final result = await service.importParsed(
      sourceType: TransactionSourceType.sms,
      records: const [],
    );

    expect(result.job.status, ImportJobStatus.completed);
    expect(result.job.progress, 100);
    expect(result.job.recordsFound, 0);
    expect(await transactions.count(const TransactionFilter()), 0);
  });

  test('ignores archived cards during matching', () async {
    await cards.archive('card_1');
    final result = await service.importParsed(
      sourceType: TransactionSourceType.sms,
      records: [record(bankHint: null)],
    );

    expect(result.requiresReview, 1);
    final review = (await reviews.listOpen()).single;
    expect(review.reasonCode, 'card_unmatched');
  });
}
