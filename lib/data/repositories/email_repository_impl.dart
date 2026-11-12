import 'package:drift/drift.dart';

import '../../domain/entities/email_account.dart';
import '../../domain/repositories/email_account_repository.dart';
import '../database/app_database.dart';

class EmailAccountRepositoryImpl implements EmailAccountRepository {
  EmailAccountRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(EmailAccount account) async {
    await _db
        .into(_db.emailAccounts)
        .insertOnConflictUpdate(
          EmailAccountsCompanion.insert(
            id: account.id,
            provider: account.provider,
            emailAddress: account.emailAddress,
            secureTokenReference: account.secureTokenReference,
            status: Value(account.status),
            syncEnabled: Value(account.syncEnabled),
            connectedAt: account.connectedAt,
            lastSuccessfulSync: Value(account.lastSuccessfulSync),
            createdAt: account.createdAt,
            updatedAt: account.updatedAt,
          ),
        );
  }

  @override
  Future<EmailAccount?> getById(String id) async {
    final row = await (_db.select(
      _db.emailAccounts,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<EmailAccount?> firstConnected() async {
    final row =
        await (_db.select(_db.emailAccounts)
              ..where((table) => table.status.equals('connected'))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<EmailAccount>> getAll() async {
    final rows = await _db.select(_db.emailAccounts).get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<void> markDisconnected(String id) async {
    await (_db.update(
      _db.emailAccounts,
    )..where((table) => table.id.equals(id))).write(
      EmailAccountsCompanion(
        status: const Value('disconnected'),
        syncEnabled: const Value(false),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> recordSuccessfulSync(String id, DateTime at) async {
    await (_db.update(
      _db.emailAccounts,
    )..where((table) => table.id.equals(id))).write(
      EmailAccountsCompanion(
        lastSuccessfulSync: Value(at),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> saveCheckpoint(SyncCheckpoint checkpoint) async {
    await _db
        .into(_db.syncCheckpoints)
        .insertOnConflictUpdate(
          SyncCheckpointsCompanion.insert(
            id: checkpoint.id,
            emailAccountId: checkpoint.emailAccountId,
            providerCheckpoint: Value(checkpoint.providerCheckpoint),
            lastSyncStarted: Value(checkpoint.lastSyncStarted),
            lastSyncCompleted: Value(checkpoint.lastSyncCompleted),
            status: checkpoint.status,
            errorCode: Value(checkpoint.errorCode),
            createdAt: checkpoint.createdAt,
            updatedAt: checkpoint.updatedAt,
          ),
        );
  }

  @override
  Future<SyncCheckpoint?> checkpointFor(String emailAccountId) async {
    final row =
        await (_db.select(_db.syncCheckpoints)
              ..where((table) => table.emailAccountId.equals(emailAccountId)))
            .getSingleOrNull();
    return row == null ? null : _checkpointToEntity(row);
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.syncCheckpoints).go();
    await _db.delete(_db.emailAccounts).go();
  }

  EmailAccount _toEntity(EmailAccountRow row) {
    return EmailAccount(
      id: row.id,
      provider: row.provider,
      emailAddress: row.emailAddress,
      secureTokenReference: row.secureTokenReference,
      status: row.status,
      syncEnabled: row.syncEnabled,
      connectedAt: row.connectedAt,
      lastSuccessfulSync: row.lastSuccessfulSync,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  SyncCheckpoint _checkpointToEntity(SyncCheckpointRow row) {
    return SyncCheckpoint(
      id: row.id,
      emailAccountId: row.emailAccountId,
      providerCheckpoint: row.providerCheckpoint,
      lastSyncStarted: row.lastSyncStarted,
      lastSyncCompleted: row.lastSyncCompleted,
      status: row.status,
      errorCode: row.errorCode,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}

class BankRuleRepositoryImpl implements BankRuleRepository {
  BankRuleRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(BankRule rule) async {
    await _db
        .into(_db.bankRules)
        .insertOnConflictUpdate(
          BankRulesCompanion.insert(
            id: rule.id,
            bankId: rule.bankId,
            ruleType: rule.ruleType,
            configurationVersion: rule.configurationVersion,
            configuration: rule.configuration,
            status: Value(rule.status),
            createdAt: rule.createdAt,
            updatedAt: rule.updatedAt,
          ),
        );
  }

  @override
  Future<List<BankRule>> forBank(String bankId) async {
    final rows = await (_db.select(
      _db.bankRules,
    )..where((table) => table.bankId.equals(bankId))).get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<List<BankRule>> getAll() async {
    final rows = await _db.select(_db.bankRules).get();
    return rows.map(_toEntity).toList(growable: false);
  }

  BankRule _toEntity(BankRuleRow row) {
    return BankRule(
      id: row.id,
      bankId: row.bankId,
      ruleType: row.ruleType,
      configurationVersion: row.configurationVersion,
      configuration: row.configuration,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
