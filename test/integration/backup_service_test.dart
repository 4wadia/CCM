import 'dart:convert';
import 'dart:io';

import 'package:credit_card_manager/core/errors/app_failure.dart';
import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/repositories/bank_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/credit_card_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/email_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/reward_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/statement_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/transaction_repository_impl.dart';
import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/cashback.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/domain/entities/reward.dart';
import 'package:credit_card_manager/domain/entities/statement.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/integrations/backup/backup_service.dart';
import 'package:credit_card_manager/integrations/storage/encrypted_file_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../fakes/in_memory_file_key_provider.dart';
import '../fakes/in_memory_key_provider.dart';
import '../fakes/in_memory_secure_token_store.dart';

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late EncryptedFileStore files;
  late InMemorySecureTokenStore tokens;
  late EmailAccountRepositoryImpl emailAccounts;
  late BankRepositoryImpl banks;
  late CreditCardRepositoryImpl cards;
  late TransactionRepositoryImpl transactions;
  late StatementRepositoryImpl statements;
  late CashbackRepositoryImpl cashback;
  late RewardRepositoryImpl rewards;
  late BackupService backup;

  final now = DateTime.utc(2026, 11, 5);
  const password = 'correct horse battery staple';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_backup_test');
    database = await openEncryptedDatabase(
      file: File(p.join(tempDir.path, 'ccm.sqlite')),
      keyProvider: InMemoryKeyProvider(),
      background: false,
    );
    files = EncryptedFileStore(
      keyProvider: InMemoryFileKeyProvider(),
      directoryProvider: () async => tempDir,
    );
    tokens = InMemorySecureTokenStore();
    emailAccounts = EmailAccountRepositoryImpl(database);
    banks = BankRepositoryImpl(database);
    cards = CreditCardRepositoryImpl(database);
    transactions = TransactionRepositoryImpl(database);
    statements = StatementRepositoryImpl(database);
    cashback = CashbackRepositoryImpl(database);
    rewards = RewardRepositoryImpl(database);
    backup = BackupService(
      db: database,
      files: files,
      tokens: tokens,
      emailAccounts: emailAccounts,
    );

    await banks.upsert(
      Bank(
        id: 'bank_1',
        displayName: 'Alpha Bank',
        countryCode: 'IN',
        region: 'India',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await cards.upsert(
      CreditCard(
        id: 'card_1',
        bankId: 'bank_1',
        displayName: 'Everyday card',
        network: CardNetwork.visa,
        lastFour: '4242',
        creditLimitMinor: 1000000,
        currencyCode: 'INR',
        status: CardStatus.active,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await transactions.insert(
      CardTransaction(
        id: 'tx_1',
        cardId: 'card_1',
        bankId: 'bank_1',
        merchantOriginal: 'Coffee House',
        merchantNormalized: 'coffee house',
        amountMinor: 125050,
        currencyCode: 'INR',
        transactionDate: now,
        transactionType: TransactionType.purchase,
        status: TransactionStatus.posted,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await cashback.save(
      CashbackEntry(
        id: 'cashback_1',
        cardId: 'card_1',
        transactionId: 'tx_1',
        amountMinor: 2500,
        currencyCode: 'INR',
        status: CashbackStatus.pending,
        earnedAt: now,
        createdAt: now,
      ),
    );
    await rewards.saveAccount(
      RewardAccount(
        id: 'reward_1',
        cardId: 'card_1',
        programmeName: 'Points',
        currentPoints: 500,
        updatedAt: now,
      ),
    );
    await emailAccounts.save(
      EmailAccount(
        id: 'email_1',
        provider: 'gmail',
        emailAddress: 'user@example.com',
        secureTokenReference: 'opaque-reference',
        status: 'connected',
        syncEnabled: true,
        connectedAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await tokens.write(
      'opaque-reference',
      OAuthTokens(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        expiresAt: now.add(const Duration(hours: 1)),
      ),
    );
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  Future<Statement> addStatementWithFile() async {
    const pdfBytes = <int>[0x25, 0x50, 0x44, 0x46, 0x2D, 1, 2, 3, 4];
    final name = await files.writeEncrypted(
      bytes: pdfBytes,
      suggestedName: 'statement.pdf',
    );
    final statement = Statement(
      id: 'statement_1',
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
      encryptedFilePath: name,
      fileHash: 'file-hash',
      fileSizeBytes: pdfBytes.length,
      processingStatus: StatementProcessingStatus.reconciled,
      parserId: 'generic-statement',
      parserVersion: '1',
      createdAt: now,
      updatedAt: now,
    );
    await statements.save(statement);
    return statement;
  }

  test('creates an encrypted backup that does not expose plaintext', () async {
    final statement = await addStatementWithFile();
    final bytes = await backup.create(password: password);

    expect(bytes, isNotEmpty);
    final asText = String.fromCharCodes(bytes);
    expect(asText, isNot(contains('Coffee House')));
    expect(asText, isNot(contains('user@example.com')));
    expect(asText, isNot(contains('access-token')));
    expect(asText, isNot(contains('refresh-token')));
    expect(asText, isNot(contains(statement.encryptedFilePath)));

    final manifest = await backup.restore(bytes: bytes, password: password);
    expect(manifest.schemaVersion, 3);
    expect(manifest.tableCounts['transactions'], 1);
    expect(manifest.tableCounts['statements'], 1);
    expect(manifest.includedFiles, 1);
    expect(manifest.skippedFiles, 0);
  });

  test(
    'restores data, re-encrypts statement files, and removes tokens',
    () async {
      final statement = await addStatementWithFile();
      final bytes = await backup.create(password: password);

      await cashback.deleteAll();
      await rewards.deleteAll();
      await statements.deleteAll();
      await transactions.deleteAll();
      await transactions.insert(
        CardTransaction(
          id: 'tx_extra',
          amountMinor: 999,
          currencyCode: 'INR',
          transactionDate: now,
          transactionType: TransactionType.purchase,
          status: TransactionStatus.posted,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final manifest = await backup.restore(bytes: bytes, password: password);

      expect(manifest.tableCounts['transactions'], 1);
      expect(
        (await transactions.getById('tx_1'))!.merchantOriginal,
        'Coffee House',
      );
      expect(await transactions.getById('tx_extra'), isNull);
      expect((await cashback.getAll()).single.amountMinor, 2500);
      expect((await rewards.accounts()).single.currentPoints, 500);

      final restored = await statements.getById('statement_1');
      expect(restored, isNotNull);
      expect(restored!.encryptedFilePath, isNot(statement.encryptedFilePath));
      final decrypted = await files.readEncrypted(restored.encryptedFilePath);
      expect(decrypted, [0x25, 0x50, 0x44, 0x46, 0x2D, 1, 2, 3, 4]);
      expect(await files.listNames(), [restored.encryptedFilePath]);

      expect(await emailAccounts.getAll(), isEmpty);
      expect(tokens.tokens, isEmpty);
      expect(tokens.deletedReferences, contains('opaque-reference'));
    },
  );

  test('rejects an incorrect password without changing local data', () async {
    final bytes = await backup.create(password: password);

    await expectLater(
      backup.restore(bytes: bytes, password: 'wrong password entirely'),
      throwsA(
        isA<AppFailure>().having(
          (error) => error.code,
          'code',
          'CCM-BACKUP-004',
        ),
      ),
    );

    expect(await transactions.getById('tx_1'), isNotNull);
  });

  test('rejects short passwords before reading or writing data', () async {
    await expectLater(
      backup.create(password: 'short'),
      throwsA(
        isA<AppFailure>().having(
          (error) => error.code,
          'code',
          'CCM-BACKUP-005',
        ),
      ),
    );
    await expectLater(
      backup.restore(bytes: [1, 2, 3], password: 'short'),
      throwsA(
        isA<AppFailure>().having(
          (error) => error.code,
          'code',
          'CCM-BACKUP-005',
        ),
      ),
    );
  });

  test('rejects malformed and tampered backup envelopes', () async {
    await expectLater(
      backup.restore(bytes: [1, 2, 3], password: password),
      throwsA(
        isA<AppFailure>().having(
          (error) => error.code,
          'code',
          'CCM-BACKUP-001',
        ),
      ),
    );

    final bytes = await backup.create(password: password);
    final tampered = List<int>.from(bytes);
    tampered[tampered.length - 1] ^= 0xFF;

    await expectLater(
      backup.restore(bytes: tampered, password: password),
      throwsA(
        isA<AppFailure>().having(
          (error) => error.code,
          'code',
          'CCM-BACKUP-004',
        ),
      ),
    );
  });

  test('backup contains only the allow-listed logical tables', () async {
    final bytes = await backup.create(password: password);
    final manifest = await backup.restore(bytes: bytes, password: password);

    expect(manifest.tableCounts.keys, isNot(contains('email_accounts')));
    expect(manifest.tableCounts.keys, isNot(contains('sync_checkpoints')));
    expect(manifest.tableCounts.keys, contains('cashback_rules'));
    expect(manifest.tableCounts.keys, contains('reward_accounts'));
    expect(manifest.tableCounts.keys, contains('bank_rules'));
  });

  test('backup magic and version are stable', () async {
    final bytes = await backup.create(password: password);
    expect(bytes.take(10).toList(), utf8.encode('CCMBACKUP1'));
  });
}
