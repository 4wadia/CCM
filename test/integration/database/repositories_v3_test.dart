import 'dart:io';

import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/repositories/bank_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/credit_card_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/email_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/import_repositories_impl.dart';
import 'package:credit_card_manager/data/repositories/reward_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/statement_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/transaction_repository_impl.dart';
import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/cashback.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/domain/entities/import_job.dart';
import 'package:credit_card_manager/domain/entities/reward.dart';
import 'package:credit_card_manager/domain/entities/statement.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../fakes/in_memory_key_provider.dart';

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late BankRepositoryImpl banks;
  late CreditCardRepositoryImpl cards;
  late TransactionRepositoryImpl transactions;
  late ReviewRepositoryImpl reviews;
  late ImportJobRepositoryImpl jobs;
  late StatementRepositoryImpl statements;
  late CashbackRepositoryImpl cashback;
  late RewardRepositoryImpl rewards;
  late EmailAccountRepositoryImpl emails;
  late BankRuleRepositoryImpl bankRules;

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

  CardTransaction transaction({
    String id = 'tx_1',
    String? cardId = 'card_1',
    int amountMinor = 125050,
    String merchant = 'Coffee House',
    TransactionType type = TransactionType.purchase,
    TransactionStatus status = TransactionStatus.posted,
    DateTime? date,
    String? fingerprint,
    String? categoryId,
  }) {
    return CardTransaction(
      id: id,
      cardId: cardId,
      bankId: cardId == null ? null : 'bank_1',
      merchantOriginal: merchant,
      merchantNormalized: merchant.toLowerCase(),
      amountMinor: amountMinor,
      currencyCode: 'INR',
      transactionDate: date ?? now,
      transactionType: type,
      categoryId: categoryId,
      status: status,
      fingerprint: fingerprint,
      fingerprintVersion: fingerprint == null ? null : 1,
      createdAt: now,
      updatedAt: now,
    );
  }

  TransactionSource source({
    String id = 'source_1',
    String? transactionId = 'tx_1',
    String reference = 'sms:1',
    TransactionSourceType type = TransactionSourceType.sms,
  }) {
    return TransactionSource(
      id: id,
      transactionId: transactionId,
      sourceType: type,
      sourceReference: reference,
      sourceDate: now,
      originalDescription: 'Coffee House',
      matchStatus: SourceMatchStatus.created,
      createdAt: now,
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_repositories_v3');
    database = await openEncryptedDatabase(
      file: File(p.join(tempDir.path, 'ccm.sqlite')),
      keyProvider: InMemoryKeyProvider(),
      background: false,
    );
    banks = BankRepositoryImpl(database);
    cards = CreditCardRepositoryImpl(database);
    transactions = TransactionRepositoryImpl(database);
    reviews = ReviewRepositoryImpl(database);
    jobs = ImportJobRepositoryImpl(database);
    statements = StatementRepositoryImpl(database);
    cashback = CashbackRepositoryImpl(database);
    rewards = RewardRepositoryImpl(database);
    emails = EmailAccountRepositoryImpl(database);
    bankRules = BankRuleRepositoryImpl(database);

    await banks.upsert(bank('bank_1', 'Alpha Bank'));
    await cards.upsert(card());
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  group('transactions', () {
    test('inserts a transaction and source atomically', () async {
      await transactions.insertWithSource(
        transaction: transaction(fingerprint: 'abc'),
        source: source(),
      );

      final stored = await transactions.getById('tx_1');
      expect(stored, isNotNull);
      expect(stored!.cardId, 'card_1');
      expect(stored.fingerprint, 'abc');
      expect(stored.fingerprintVersion, 1);

      final sources = await transactions.sourcesFor('tx_1');
      expect(sources.single.sourceReference, 'sms:1');
      expect(sources.single.sourceDate!.isAtSameMomentAs(now), isTrue);
      expect(
        await transactions.findSource(
          sourceType: TransactionSourceType.sms,
          sourceReference: 'sms:1',
        ),
        isNotNull,
      );
    });

    test(
      'filters by card, status, type, date, amount, merchant, and source',
      () async {
        await transactions.insertWithSource(
          transaction: transaction(id: 'tx_1', fingerprint: 'one'),
          source: source(id: 'source_1', reference: 'sms:1'),
        );
        await transactions.insertWithSource(
          transaction: transaction(
            id: 'tx_2',
            cardId: null,
            amountMinor: 5000,
            merchant: 'Fuel Station',
            type: TransactionType.refund,
            status: TransactionStatus.needsReview,
            date: now.subtract(const Duration(days: 10)),
          ),
          source: source(
            id: 'source_2',
            transactionId: 'tx_2',
            reference: 'pdf:1',
            type: TransactionSourceType.pdfStatement,
          ),
        );

        expect(
          (await transactions.search(
            filter: const TransactionFilter(cardId: 'card_1'),
          )).single.id,
          'tx_1',
        );
        expect(
          (await transactions.search(
            filter: const TransactionFilter(reviewOnly: true),
          )).single.id,
          'tx_2',
        );
        expect(
          (await transactions.search(
            filter: const TransactionFilter(unassignedOnly: true),
          )).single.id,
          'tx_2',
        );
        expect(
          (await transactions.search(
            filter: const TransactionFilter(types: {TransactionType.refund}),
          )).single.id,
          'tx_2',
        );
        expect(
          (await transactions.search(
            filter: TransactionFilter(
              from: now.subtract(const Duration(days: 1)),
              to: now,
            ),
          )).single.id,
          'tx_1',
        );
        expect(
          (await transactions.search(
            filter: const TransactionFilter(minAmountMinor: 100000),
          )).single.id,
          'tx_1',
        );
        expect(
          (await transactions.search(
            filter: const TransactionFilter(merchant: 'fuel'),
          )).single.id,
          'tx_2',
        );
        expect(
          (await transactions.search(
            filter: const TransactionFilter(
              sourceType: TransactionSourceType.pdfStatement,
            ),
          )).single.id,
          'tx_2',
        );
        expect(await transactions.count(const TransactionFilter()), 2);
        expect(
          (await transactions.recentForCard(cardId: 'card_1')).single.id,
          'tx_1',
        );
      },
    );

    test('updates category, merchant, card, and status', () async {
      await transactions.insert(transaction());

      await transactions.updateCategory('tx_1', 'cat_dining');
      await transactions.updateMerchant(
        id: 'tx_1',
        merchantOriginal: 'Coffee House Branch',
        merchantNormalized: 'coffee house branch',
      );
      expect((await transactions.getById('tx_1'))!.categoryId, 'cat_dining');
      expect(
        (await transactions.getById('tx_1'))!.merchantNormalized,
        'coffee house branch',
      );

      await transactions.markForReview('tx_1');
      expect(
        (await transactions.getById('tx_1'))!.status,
        TransactionStatus.needsReview,
      );

      await transactions.assignCard(
        id: 'tx_1',
        cardId: 'card_1',
        bankId: 'bank_1',
      );
      final assigned = (await transactions.getById('tx_1'))!;
      expect(assigned.cardId, 'card_1');
      expect(assigned.status, TransactionStatus.posted);

      await transactions.setStatus('tx_1', TransactionStatus.reversed);
      expect(
        (await transactions.getById('tx_1'))!.status,
        TransactionStatus.reversed,
      );
    });

    test('finds fingerprints and fuzzy candidates', () async {
      await transactions.insert(
        transaction(
          id: 'tx_1',
          fingerprint: 'fingerprint-1',
          date: DateTime.utc(2026, 11, 5),
        ),
      );
      await transactions.insert(
        transaction(
          id: 'tx_2',
          fingerprint: 'fingerprint-2',
          date: DateTime.utc(2026, 11, 20),
        ),
      );

      expect(
        (await transactions.findByFingerprint('fingerprint-1'))!.id,
        'tx_1',
      );
      expect(await transactions.findByFingerprint('missing'), isNull);

      final fuzzy = await transactions.fuzzyCandidates(
        cardId: 'card_1',
        amountMinor: 125050,
        currencyCode: 'INR',
        transactionDate: DateTime.utc(2026, 11, 6),
      );
      expect(fuzzy.map((tx) => tx.id), ['tx_1']);
    });

    test('links additional sources idempotently and deletes all', () async {
      await transactions.insertWithSource(
        transaction: transaction(),
        source: source(),
      );
      await transactions.linkSource(
        source(id: 'source_2', reference: 'gmail:1'),
      );
      await transactions.linkSource(
        source(id: 'source_3', reference: 'gmail:1'),
      );

      expect(await transactions.sourcesFor('tx_1'), hasLength(2));

      await transactions.deleteAll();
      expect(await transactions.count(const TransactionFilter()), 0);
      expect(await transactions.sourcesFor('tx_1'), isEmpty);
    });

    test(
      'clears one source type without deleting shared transactions',
      () async {
        await transactions.insertWithSource(
          transaction: transaction(),
          source: source(),
        );
        await transactions.linkSource(
          source(
            id: 'source_pdf',
            reference: 'pdf:1',
            type: TransactionSourceType.pdfStatement,
          ),
        );
        await transactions.insertWithSource(
          transaction: transaction(id: 'tx_2', fingerprint: 'two'),
          source: source(
            id: 'source_sms_2',
            transactionId: 'tx_2',
            reference: 'sms:2',
          ),
        );

        final result = await transactions.clearImportedSource(
          TransactionSourceType.sms,
        );

        expect(result.deletedSources, 2);
        expect(result.deletedTransactions, 1);
        expect(result.retainedTransactions, 1);
        expect(await transactions.getById('tx_1'), isNotNull);
        expect(await transactions.getById('tx_2'), isNull);
        final remaining = await transactions.sourcesFor('tx_1');
        expect(remaining.single.sourceType, TransactionSourceType.pdfStatement);
      },
    );
  });

  group('import jobs and reviews', () {
    test('round-trips jobs and review lifecycle', () async {
      final job = ImportJob(
        id: 'job_1',
        sourceType: 'sms',
        status: ImportJobStatus.completedWithReview,
        startedAt: now,
        completedAt: now,
        progress: 100,
        recordsFound: 2,
        recordsImported: 1,
        recordsSkipped: 0,
        recordsRequiringReview: 1,
      );
      await jobs.save(job);
      final storedJob = await jobs.getById('job_1');
      expect(storedJob!.status, ImportJobStatus.completedWithReview);
      expect(storedJob.recordsRequiringReview, 1);
      expect((await jobs.recent()).single.id, 'job_1');

      final review = ReviewItem(
        id: 'review_1',
        entityType: 'transaction',
        entityId: 'tx_1',
        reasonCode: 'card_ambiguous',
        userMessage: 'Assign a card.',
        sourceType: 'sms',
        sourceReference: 'sms:1',
        status: ReviewStatus.open,
        createdAt: now,
      );
      await reviews.add(review);
      await reviews.add(review);
      expect(await reviews.countOpen(), 1);
      expect((await reviews.listOpen()).single.id, 'review_1');

      await reviews.resolveForEntity(
        entityType: 'transaction',
        entityId: 'tx_1',
      );
      expect(await reviews.countOpen(), 0);

      final second = ReviewItem(
        id: 'review_2',
        entityType: 'statement',
        reasonCode: 'statement_extraction',
        userMessage: 'Review the statement.',
        status: ReviewStatus.open,
        createdAt: now,
      );
      await reviews.add(second);
      await reviews.dismiss('review_2');
      expect(await reviews.countOpen(), 0);

      await reviews.add(second);
      await reviews.resolve('review_2');
      expect(await reviews.countOpen(), 0);

      await reviews.deleteAll();
      expect(await reviews.listOpen(), isEmpty);
    });
  });

  group('statements', () {
    Statement statement({String id = 'statement_1'}) => Statement(
      id: id,
      cardId: 'card_1',
      bankId: 'bank_1',
      statementPeriodStart: DateTime(2026, 10, 6),
      statementPeriodEnd: DateTime(2026, 11, 5),
      statementDate: now,
      paymentDueDate: DateTime(2026, 11, 25),
      previousBalanceMinor: 100000,
      totalDueMinor: 250000,
      minimumDueMinor: 25000,
      currencyCode: 'INR',
      encryptedFilePath: 'opaque.ccmenc',
      fileHash: 'hash-$id',
      fileSizeBytes: 1024,
      processingStatus: StatementProcessingStatus.needsReview,
      parserId: 'generic-statement',
      parserVersion: '1',
      createdAt: now,
      updatedAt: now,
    );

    test('round-trips metadata and extracted transactions', () async {
      await statements.save(statement());

      final stored = await statements.getById('statement_1');
      expect(stored, isNotNull);
      expect(stored!.totalDueMinor, 250000);
      expect(stored.processingStatus, StatementProcessingStatus.needsReview);
      expect(
        (await statements.findByHash('hash-statement_1'))!.id,
        'statement_1',
      );
      expect((await statements.getAll()).single.id, 'statement_1');
      expect((await statements.forCard('card_1')).single.id, 'statement_1');

      await transactions.insert(transaction());
      await statements.saveStatementTransaction(
        StatementTransaction(
          id: 'stx_1',
          statementId: 'statement_1',
          transactionId: 'tx_1',
          description: 'Coffee House',
          merchantNormalized: 'coffee house',
          amountMinor: 125050,
          currencyCode: 'INR',
          transactionDate: now,
          transactionType: TransactionType.purchase,
          matchStatus: StatementMatchStatus.matched,
          createdAt: now,
        ),
      );

      final extracted = await statements.transactionsFor('statement_1');
      expect(extracted.single.transactionId, 'tx_1');
      expect(extracted.single.matchStatus, StatementMatchStatus.matched);

      await statements.updateStatus(
        'statement_1',
        StatementProcessingStatus.reconciled,
        parserId: 'generic-statement',
        parserVersion: '2',
      );
      final updated = await statements.getById('statement_1');
      expect(updated!.processingStatus, StatementProcessingStatus.reconciled);
      expect(updated.parserVersion, '2');

      await statements.deleteAll();
      expect(await statements.getAll(), isEmpty);
      expect(await statements.transactionsFor('statement_1'), isEmpty);
    });
  });

  group('cashback and rewards', () {
    test('round-trips cashback rules and entries', () async {
      final rule = CashbackRule(
        id: 'rule_1',
        cardId: 'card_1',
        kind: CashbackRuleKind.percentage,
        rateBasisPoints: 200,
        categoryId: 'cat_dining',
        monthlyCapMinor: 5000,
        currencyCode: 'INR',
        createdAt: now,
        updatedAt: now,
      );
      await cashback.saveRule(rule);
      final storedRule = (await cashback.rulesForCard('card_1')).single;
      expect(storedRule.kind, CashbackRuleKind.percentage);
      expect(storedRule.rateBasisPoints, 200);
      expect(storedRule.monthlyCapMinor, 5000);
      expect((await cashback.allRules()).single.id, 'rule_1');

      await cashback.save(
        CashbackEntry(
          id: 'cashback_1',
          cardId: 'card_1',
          amountMinor: 2500,
          currencyCode: 'INR',
          status: CashbackStatus.pending,
          earnedAt: now,
          createdAt: now,
        ),
      );
      await cashback.save(
        CashbackEntry(
          id: 'cashback_2',
          cardId: 'card_1',
          amountMinor: 1000,
          currencyCode: 'INR',
          status: CashbackStatus.reversed,
          earnedAt: now,
          createdAt: now,
        ),
      );

      expect(await cashback.getAll(), hasLength(2));
      expect(await cashback.forCard('card_1'), hasLength(2));
      expect(await cashback.pendingTotalMinor('INR'), 2500);

      await cashback.deleteRule('rule_1');
      expect(await cashback.allRules(), isEmpty);
      await cashback.deleteAll();
      expect(await cashback.getAll(), isEmpty);
    });

    test('round-trips reward accounts and entries', () async {
      await rewards.saveAccount(
        RewardAccount(
          id: 'account_1',
          cardId: 'card_1',
          programmeName: 'Reward points',
          currentPoints: 1500,
          estimatedValueMinor: 37500,
          currencyCode: 'INR',
          updatedAt: now,
        ),
      );
      final account = await rewards.accountForCard('card_1');
      expect(account!.programmeName, 'Reward points');
      expect(account.currentPoints, 1500);
      expect((await rewards.accounts()).single.id, 'account_1');

      await rewards.saveEntry(
        RewardEntry(
          id: 'entry_1',
          rewardAccountId: 'account_1',
          points: 100,
          entryType: RewardEntryType.earned,
          description: 'Dining bonus',
          createdAt: now,
        ),
      );
      final entries = await rewards.entriesForAccount('account_1');
      expect(entries.single.points, 100);
      expect(entries.single.entryType, RewardEntryType.earned);

      await rewards.deleteAll();
      expect(await rewards.accounts(), isEmpty);
      expect(await rewards.entriesForAccount('account_1'), isEmpty);
    });
  });

  group('email and bank rules', () {
    test('round-trips accounts, checkpoints, and disconnection', () async {
      final account = EmailAccount(
        id: 'email_1',
        provider: 'gmail',
        emailAddress: 'user@example.com',
        secureTokenReference: 'opaque-token-reference',
        status: 'connected',
        syncEnabled: true,
        connectedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      await emails.save(account);
      expect(
        (await emails.getById('email_1'))!.emailAddress,
        'user@example.com',
      );
      expect((await emails.firstConnected())!.id, 'email_1');
      expect(await emails.getAll(), hasLength(1));

      await emails.saveCheckpoint(
        SyncCheckpoint(
          id: 'checkpoint_1',
          emailAccountId: 'email_1',
          providerCheckpoint: 'message-42',
          status: 'completed',
          lastSyncStarted: now,
          lastSyncCompleted: now,
          createdAt: now,
          updatedAt: now,
        ),
      );
      final checkpoint = await emails.checkpointFor('email_1');
      expect(checkpoint!.providerCheckpoint, 'message-42');

      await emails.recordSuccessfulSync('email_1', now);
      expect(
        (await emails.getById('email_1'))!.lastSuccessfulSync!
            .isAtSameMomentAs(now),
        isTrue,
      );

      await emails.markDisconnected('email_1');
      final disconnected = (await emails.getById('email_1'))!;
      expect(disconnected.status, 'disconnected');
      expect(disconnected.syncEnabled, isFalse);
      expect(await emails.firstConnected(), isNull);

      await emails.deleteAll();
      expect(await emails.getAll(), isEmpty);
      expect(await emails.checkpointFor('email_1'), isNull);
    });

    test('round-trips declarative bank rules', () async {
      final rule = BankRule(
        id: 'bank_rule_1',
        bankId: 'bank_1',
        ruleType: 'name_prefix_and_birth_date',
        configurationVersion: '1',
        configuration: '{"strategy":"name_prefix_and_birth_date"}',
        status: 'active',
        createdAt: now,
        updatedAt: now,
      );
      await bankRules.save(rule);

      expect((await bankRules.forBank('bank_1')).single.id, 'bank_rule_1');
      expect(
        (await bankRules.getAll()).single.ruleType,
        'name_prefix_and_birth_date',
      );
    });
  });
}
