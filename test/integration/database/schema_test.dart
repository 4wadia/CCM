import 'dart:io';

import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/database/migrations.dart';
import 'package:credit_card_manager/data/repositories/category_repository_impl.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' show SqliteException;

import '../../fakes/in_memory_key_provider.dart';

void main() {
  late Directory tempDir;
  late AppDatabase database;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_schema_test');
    database = await openEncryptedDatabase(
      file: File(p.join(tempDir.path, 'ccm.sqlite')),
      keyProvider: InMemoryKeyProvider(),
      background: false,
    );
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  Future<Set<String>> schemaObjects(String type) async {
    final rows = await database
        .customSelect(
          """
          SELECT name FROM sqlite_master
          WHERE type = ? AND name NOT LIKE 'sqlite_%'
          """,
          variables: [Variable<String>(type)],
        )
        .get();
    return rows.map((row) => row.read<String>('name')).toSet();
  }

  test('reports the latest schema version', () async {
    final version = await database.customSelect('PRAGMA user_version').get();
    expect(version.single.data['user_version'], latestSchemaVersion);
  });

  test('creates every table', () async {
    final tables = await schemaObjects('table');

    expect(
      tables,
      containsAll(<String>[
        'banks',
        'credit_cards',
        'categories',
        'transactions',
        'transaction_sources',
        'import_jobs',
        'app_settings',
      ]),
    );
  });

  test('adds the v2 outstanding column', () async {
    final columns = await database
        .customSelect('PRAGMA table_info(credit_cards)')
        .get();
    expect(
      columns.map((row) => row.read<String>('name')),
      contains('current_outstanding_minor'),
    );
  });

  test('creates the required indexes', () async {
    final indexes = await schemaObjects('index');

    expect(
      indexes,
      containsAll(<String>[
        'idx_cards_bank_id',
        'idx_cards_status',
        'idx_tx_card_id',
        'idx_tx_date',
        'idx_tx_card_date',
        'idx_tx_merchant',
        'idx_tx_category',
        'idx_sources_transaction',
        'idx_sources_reference',
        'idx_categories_parent',
        'idx_settings_key',
      ]),
    );
  });

  test('seeds system categories exactly once', () async {
    final categories = await CategoryRepositoryImpl(database).getAll();

    expect(categories, hasLength(12));
    expect(categories.every((category) => category.isSystemCategory), isTrue);
    expect(
      categories.map((category) => category.id),
      contains('cat_groceries'),
    );

    // Reopening an existing database must not duplicate seed rows.
    await database.close();
    database = await openEncryptedDatabase(
      file: File(p.join(tempDir.path, 'ccm.sqlite')),
      keyProvider: InMemoryKeyProvider(),
      background: false,
    );

    expect(await CategoryRepositoryImpl(database).getAll(), hasLength(12));
  });

  test('enforces foreign keys', () async {
    final now = DateTime.utc(2026, 11, 5);

    await expectLater(
      database
          .into(database.creditCards)
          .insert(
            CreditCardsCompanion.insert(
              id: 'card_orphan',
              bankId: 'bank_missing',
              displayName: 'Orphan card',
              network: 'visa',
              lastFour: '4242',
              creditLimitMinor: 100000,
              currencyCode: 'INR',
              createdAt: now,
              updatedAt: now,
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('rejects duplicate transaction source references', () async {
    final now = DateTime.utc(2026, 11, 5);

    Future<void> insertSource(String id) {
      return database
          .into(database.transactionSources)
          .insert(
            TransactionSourcesCompanion.insert(
              id: id,
              sourceType: 'SMS',
              sourceReference: const Value('ref-1'),
              originalDescription: 'synthetic',
              matchStatus: 'matched',
              createdAt: now,
            ),
          );
    }

    await insertSource('source_1');

    await expectLater(
      insertSource('source_2'),
      throwsA(isA<SqliteException>()),
    );
  });
}
