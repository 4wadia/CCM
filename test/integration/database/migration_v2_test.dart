import 'dart:io';

import 'package:credit_card_manager/core/security/key_encoding.dart';
import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/repositories/credit_card_repository_impl.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../../fakes/in_memory_key_provider.dart';

void main() {
  late Directory tempDir;
  late File file;
  late InMemoryKeyProvider keyProvider;
  late AppDatabase database;

  final now = DateTime.utc(2026, 11, 5);
  final nowSeconds = now.millisecondsSinceEpoch ~/ 1000;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_migration_test');
    file = File(p.join(tempDir.path, 'ccm.sqlite'));
    keyProvider = InMemoryKeyProvider();
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  Future<void> createVersionOneDatabase() async {
    final key = await keyProvider.getOrCreateDatabaseKey();
    final keyHex = encodeDatabaseKeyHex(key);
    key.fillRange(0, key.length, 0);

    final raw = sqlite.sqlite3.open(file.path);
    try {
      configureEncryptedConnection(raw, keyHex);
      raw.execute('''
        CREATE TABLE banks (
          id TEXT NOT NULL PRIMARY KEY,
          display_name TEXT NOT NULL,
          country_code TEXT NOT NULL,
          region TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');
      raw.execute('''
        CREATE TABLE credit_cards (
          id TEXT NOT NULL PRIMARY KEY,
          bank_id TEXT NOT NULL REFERENCES banks(id),
          display_name TEXT NOT NULL,
          cardholder_name TEXT NULL,
          network TEXT NOT NULL,
          last_four TEXT NOT NULL,
          credit_limit_minor INTEGER NOT NULL,
          currency_code TEXT NOT NULL,
          statement_day INTEGER NULL,
          due_day INTEGER NULL,
          billing_cycle_start INTEGER NULL,
          billing_cycle_end INTEGER NULL,
          status TEXT NOT NULL DEFAULT 'active',
          reward_programme TEXT NULL,
          color_value INTEGER NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');
      raw.execute('INSERT INTO banks VALUES (?, ?, ?, ?, ?, ?)', [
        'bank_v1',
        'V1 Bank',
        'IN',
        'India',
        nowSeconds,
        nowSeconds,
      ]);
      raw.execute(
        'INSERT INTO credit_cards '
        '(id, bank_id, display_name, network, last_four, credit_limit_minor, '
        'currency_code, status, created_at, updated_at) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          'card_v1',
          'bank_v1',
          'Legacy card',
          'visa',
          '4242',
          25000000,
          'INR',
          'active',
          nowSeconds,
          nowSeconds,
        ],
      );
      raw.execute('PRAGMA user_version = 1');
    } finally {
      raw.close();
    }
  }

  test('upgrades a populated v1 database and preserves the card', () async {
    await createVersionOneDatabase();

    database = await openEncryptedDatabase(
      file: file,
      keyProvider: keyProvider,
      background: false,
    );

    final columns = await database
        .customSelect('PRAGMA table_info(credit_cards)')
        .get();
    expect(
      columns.map((row) => row.read<String>('name')),
      contains('current_outstanding_minor'),
    );

    final repository = CreditCardRepositoryImpl(database);
    final upgraded = await repository.getById('card_v1');
    expect(upgraded, isNotNull);
    expect(upgraded!.creditLimitMinor, 25000000);
    expect(upgraded.currentOutstandingMinor, 0);

    await repository.upsert(_withOutstanding(upgraded, 125000));
    final updated = await repository.getById('card_v1');
    expect(updated!.currentOutstandingMinor, 125000);
  });
}

CreditCard _withOutstanding(CreditCard card, int outstandingMinor) {
  return CreditCard(
    id: card.id,
    bankId: card.bankId,
    displayName: card.displayName,
    cardholderName: card.cardholderName,
    network: card.network,
    lastFour: card.lastFour,
    creditLimitMinor: card.creditLimitMinor,
    currentOutstandingMinor: outstandingMinor,
    currencyCode: card.currencyCode,
    statementDay: card.statementDay,
    dueDay: card.dueDay,
    billingCycleStart: card.billingCycleStart,
    billingCycleEnd: card.billingCycleEnd,
    status: card.status,
    rewardProgramme: card.rewardProgramme,
    colorValue: card.colorValue,
    createdAt: card.createdAt,
    updatedAt: card.updatedAt,
  );
}
