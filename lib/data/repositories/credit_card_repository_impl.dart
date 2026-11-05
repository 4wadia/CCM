import 'package:drift/drift.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/repositories/credit_card_repository.dart';
import '../database/app_database.dart';

class CreditCardRepositoryImpl implements CreditCardRepository {
  CreditCardRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<CreditCard>> getAll({bool includeArchived = false}) async {
    final query = _db.select(_db.creditCards);
    if (!includeArchived) {
      query.where((table) => table.status.equals(CardStatus.active.name));
    }
    query.orderBy([(table) => OrderingTerm.asc(table.displayName)]);

    final rows = await query.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<CreditCard?> getById(String id) async {
    final query = _db.select(_db.creditCards)
      ..where((table) => table.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> upsert(CreditCard card) async {
    await _db
        .into(_db.creditCards)
        .insertOnConflictUpdate(
          CreditCardsCompanion.insert(
            id: card.id,
            bankId: card.bankId,
            displayName: card.displayName,
            cardholderName: Value(card.cardholderName),
            network: card.network.name,
            lastFour: card.lastFour,
            creditLimitMinor: card.creditLimitMinor,
            currencyCode: card.currencyCode,
            statementDay: Value(card.statementDay),
            dueDay: Value(card.dueDay),
            billingCycleStart: Value(card.billingCycleStart),
            billingCycleEnd: Value(card.billingCycleEnd),
            status: Value(card.status.name),
            rewardProgramme: Value(card.rewardProgramme),
            colorValue: Value(card.colorValue),
            createdAt: card.createdAt,
            updatedAt: card.updatedAt,
          ),
        );
  }

  @override
  Future<void> archive(String id) => _setStatus(id, CardStatus.archived);

  @override
  Future<void> restore(String id) => _setStatus(id, CardStatus.active);

  @override
  Future<void> close(String id) => _setStatus(id, CardStatus.closed);

  Future<void> _setStatus(String id, CardStatus status) async {
    final update = _db.update(_db.creditCards)
      ..where((table) => table.id.equals(id));

    await update.write(
      CreditCardsCompanion(
        status: Value(status.name),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}

CreditCard _toEntity(CreditCardRow row) {
  return CreditCard(
    id: row.id,
    bankId: row.bankId,
    displayName: row.displayName,
    cardholderName: row.cardholderName,
    network: CardNetwork.fromStorage(row.network),
    lastFour: row.lastFour,
    creditLimitMinor: row.creditLimitMinor,
    currencyCode: row.currencyCode,
    statementDay: row.statementDay,
    dueDay: row.dueDay,
    billingCycleStart: row.billingCycleStart,
    billingCycleEnd: row.billingCycleEnd,
    status: CardStatus.fromStorage(row.status),
    rewardProgramme: row.rewardProgramme,
    colorValue: row.colorValue,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
