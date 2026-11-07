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
        },
      ),
      beforeOpen: (details) async {
        // Per-connection pragma; also set in the database factory setup.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
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
