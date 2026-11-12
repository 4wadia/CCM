import 'package:drift/drift.dart';

import '../../domain/entities/cashback.dart';
import '../../domain/entities/reward.dart';
import '../../domain/repositories/reward_repository.dart';
import '../database/app_database.dart';

class CashbackRepositoryImpl implements CashbackRepository {
  CashbackRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(CashbackEntry entry) async {
    await _db
        .into(_db.cashbackEntries)
        .insertOnConflictUpdate(
          CashbackEntriesCompanion.insert(
            id: entry.id,
            cardId: entry.cardId,
            transactionId: Value(entry.transactionId),
            amountMinor: entry.amountMinor,
            currencyCode: entry.currencyCode,
            status: entry.status.name,
            earnedAt: entry.earnedAt,
            creditedAt: Value(entry.creditedAt),
            reversedAt: Value(entry.reversedAt),
            notes: Value(entry.notes),
            createdAt: entry.createdAt,
          ),
        );
  }

  @override
  Future<void> saveRule(CashbackRule rule) async {
    await _db
        .into(_db.cashbackRules)
        .insertOnConflictUpdate(
          CashbackRulesCompanion.insert(
            id: rule.id,
            cardId: rule.cardId,
            kind: rule.kind.name,
            rateBasisPoints: Value(rule.rateBasisPoints),
            flatAmountMinor: Value(rule.flatAmountMinor),
            categoryId: Value(rule.categoryId),
            merchantContains: Value(rule.merchantContains),
            monthlyCapMinor: Value(rule.monthlyCapMinor),
            currencyCode: rule.currencyCode ?? 'INR',
            isActive: Value(rule.isActive),
            createdAt: rule.createdAt ?? DateTime.now().toUtc(),
            updatedAt: rule.updatedAt ?? DateTime.now().toUtc(),
          ),
        );
  }

  @override
  Future<List<CashbackRule>> rulesForCard(String cardId) async {
    final rows =
        await (_db.select(_db.cashbackRules)..where(
              (table) =>
                  table.cardId.equals(cardId) & table.isActive.equals(true),
            ))
            .get();
    return rows.map(_ruleToEntity).toList(growable: false);
  }

  @override
  Future<List<CashbackRule>> allRules() async {
    final rows = await _db.select(_db.cashbackRules).get();
    return rows.map(_ruleToEntity).toList(growable: false);
  }

  @override
  Future<void> deleteRule(String id) async {
    await (_db.delete(
      _db.cashbackRules,
    )..where((table) => table.id.equals(id))).go();
  }

  @override
  Future<List<CashbackEntry>> getAll({int limit = 200}) async {
    final rows =
        await (_db.select(_db.cashbackEntries)
              ..orderBy([(table) => OrderingTerm.desc(table.earnedAt)])
              ..limit(limit))
            .get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<List<CashbackEntry>> forCard(String cardId, {int limit = 200}) async {
    final rows =
        await (_db.select(_db.cashbackEntries)
              ..where((table) => table.cardId.equals(cardId))
              ..orderBy([(table) => OrderingTerm.desc(table.earnedAt)])
              ..limit(limit))
            .get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<int> pendingTotalMinor(String currencyCode) async {
    final amount = _db.cashbackEntries.amountMinor.sum();
    final row =
        await (_db.selectOnly(_db.cashbackEntries)
              ..addColumns([amount])
              ..where(
                _db.cashbackEntries.currencyCode.equals(currencyCode) &
                    _db.cashbackEntries.status.isIn([
                      CashbackStatus.pending.name,
                      CashbackStatus.credited.name,
                    ]),
              ))
            .getSingle();
    return row.read(amount) ?? 0;
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.cashbackEntries).go();
    await _db.delete(_db.cashbackRules).go();
  }

  CashbackRule _ruleToEntity(CashbackRuleRow row) {
    return CashbackRule(
      id: row.id,
      cardId: row.cardId,
      kind: row.kind == 'percentage'
          ? CashbackRuleKind.percentage
          : CashbackRuleKind.flat,
      isActive: row.isActive,
      rateBasisPoints: row.rateBasisPoints,
      flatAmountMinor: row.flatAmountMinor,
      categoryId: row.categoryId,
      merchantContains: row.merchantContains,
      monthlyCapMinor: row.monthlyCapMinor,
      currencyCode: row.currencyCode,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  CashbackEntry _toEntity(CashbackEntryRow row) {
    return CashbackEntry(
      id: row.id,
      cardId: row.cardId,
      transactionId: row.transactionId,
      amountMinor: row.amountMinor,
      currencyCode: row.currencyCode,
      status: CashbackStatus.fromStorage(row.status),
      earnedAt: row.earnedAt,
      creditedAt: row.creditedAt,
      reversedAt: row.reversedAt,
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }
}

class RewardRepositoryImpl implements RewardRepository {
  RewardRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> saveAccount(RewardAccount account) async {
    await _db
        .into(_db.rewardAccounts)
        .insertOnConflictUpdate(
          RewardAccountsCompanion.insert(
            id: account.id,
            cardId: account.cardId,
            programmeName: account.programmeName,
            currentPoints: Value(account.currentPoints),
            estimatedValueMinor: Value(account.estimatedValueMinor),
            currencyCode: Value(account.currencyCode),
            updatedAt: account.updatedAt,
          ),
        );
  }

  @override
  Future<RewardAccount?> accountForCard(String cardId) async {
    final row =
        await (_db.select(_db.rewardAccounts)
              ..where((table) => table.cardId.equals(cardId))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _accountToEntity(row);
  }

  @override
  Future<List<RewardAccount>> accounts() async {
    final rows = await _db.select(_db.rewardAccounts).get();
    return rows.map(_accountToEntity).toList(growable: false);
  }

  @override
  Future<void> saveEntry(RewardEntry entry) async {
    await _db
        .into(_db.rewardEntries)
        .insertOnConflictUpdate(
          RewardEntriesCompanion.insert(
            id: entry.id,
            rewardAccountId: entry.rewardAccountId,
            transactionId: Value(entry.transactionId),
            points: entry.points,
            entryType: entry.entryType.name,
            description: Value(entry.description),
            expiresAt: Value(entry.expiresAt),
            createdAt: entry.createdAt,
          ),
        );
  }

  @override
  Future<List<RewardEntry>> entriesForAccount(
    String accountId, {
    int limit = 200,
  }) async {
    final rows =
        await (_db.select(_db.rewardEntries)
              ..where((table) => table.rewardAccountId.equals(accountId))
              ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
              ..limit(limit))
            .get();
    return rows.map(_entryToEntity).toList(growable: false);
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.rewardEntries).go();
    await _db.delete(_db.rewardAccounts).go();
  }

  RewardAccount _accountToEntity(RewardAccountRow row) {
    return RewardAccount(
      id: row.id,
      cardId: row.cardId,
      programmeName: row.programmeName,
      currentPoints: row.currentPoints,
      estimatedValueMinor: row.estimatedValueMinor,
      currencyCode: row.currencyCode,
      updatedAt: row.updatedAt,
    );
  }

  RewardEntry _entryToEntity(RewardEntryRow row) {
    return RewardEntry(
      id: row.id,
      rewardAccountId: row.rewardAccountId,
      transactionId: row.transactionId,
      points: row.points,
      entryType: RewardEntryType.fromStorage(row.entryType),
      description: row.description,
      expiresAt: row.expiresAt,
      createdAt: row.createdAt,
    );
  }
}
