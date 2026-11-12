import 'package:drift/drift.dart';

import 'migrations.dart';
import 'seed_data.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Indexes required by the specification (§15.2).
///
/// Kept as explicit SQL so they can be created on fresh databases and re-created
/// by future migrations without relying on analyzer annotations.
const List<String> databaseIndexStatements = <String>[
  'CREATE INDEX IF NOT EXISTS idx_cards_bank_id ON credit_cards (bank_id)',
  'CREATE INDEX IF NOT EXISTS idx_cards_status ON credit_cards (status)',
  'CREATE INDEX IF NOT EXISTS idx_tx_card_id ON transactions (card_id)',
  'CREATE INDEX IF NOT EXISTS idx_tx_date ON transactions (transaction_date)',
  'CREATE INDEX IF NOT EXISTS idx_tx_card_date ON transactions (card_id, transaction_date)',
  'CREATE INDEX IF NOT EXISTS idx_tx_merchant ON transactions (merchant_normalized)',
  'CREATE INDEX IF NOT EXISTS idx_tx_category ON transactions (category_id)',
  'CREATE INDEX IF NOT EXISTS idx_sources_transaction ON transaction_sources (transaction_id)',
  'CREATE UNIQUE INDEX IF NOT EXISTS idx_sources_reference ON transaction_sources (source_type, source_reference)',
  'CREATE INDEX IF NOT EXISTS idx_categories_parent ON categories (parent_id)',
  'CREATE UNIQUE INDEX IF NOT EXISTS idx_settings_key ON app_settings (setting_key)',
];

@DriftDatabase(
  tables: [
    Banks,
    CreditCards,
    Categories,
    Transactions,
    TransactionSources,
    ImportJobs,
    AppSettings,
    ReviewItems,
    Statements,
    StatementTransactions,
    CashbackEntries,
    CashbackRules,
    RewardAccounts,
    RewardEntries,
    BankRules,
    EmailAccounts,
    SyncCheckpoints,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => latestSchemaVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
        await _createIndexes();
        await _seedSystemCategories();
      },
      onUpgrade: (migrator, from, to) => DatabaseMigrations.run(
        from: from,
        to: to,
        steps: <int, MigrationStep>{
          2: () async {
            await migrator.addColumn(
              creditCards,
              creditCards.currentOutstandingMinor,
            );
          },
          3: () async {
            // createAll() creates only tables that do not already exist. Existing
            // v2 tables keep their data; the additive columns below are applied
            // independently so both v1 and v2 databases upgrade safely.
            await migrator.createAll();
            await _addColumnIfMissing(
              'transactions',
              'fingerprint',
              'TEXT NULL',
            );
            await _addColumnIfMissing(
              'transactions',
              'fingerprint_version',
              'INTEGER NULL',
            );
            await _addColumnIfMissing(
              'transaction_sources',
              'source_date',
              'INTEGER NULL',
            );
            await _createIndexes();
            await _seedSystemCategories();
          },
        },
      ),
      beforeOpen: (details) async {
        // Per-connection pragma; also set in the database factory setup.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _addColumnIfMissing(
    String table,
    String column,
    String definition,
  ) async {
    final info = await customSelect('PRAGMA table_info($table)').get();
    final exists = info.any((row) => row.read<String>('name') == column);
    if (!exists) {
      await customStatement(
        'ALTER TABLE $table ADD COLUMN $column $definition',
      );
    }
  }

  Future<void> _createIndexes() async {
    for (final statement in databaseIndexStatements) {
      await customStatement(statement);
    }
  }

  Future<void> _seedSystemCategories() async {
    await batch((batch) {
      for (final category in systemCategories) {
        batch.insert(
          categories,
          CategoriesCompanion.insert(
            id: category.id,
            name: category.name,
            isSystemCategory: const Value(true),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
