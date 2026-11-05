import 'package:drift/drift.dart';

import '../../domain/entities/bank.dart';
import '../../domain/repositories/bank_repository.dart';
import '../database/app_database.dart';

class BankRepositoryImpl implements BankRepository {
  BankRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Bank>> getAll() async {
    final query = _db.select(_db.banks)
      ..orderBy([(table) => OrderingTerm.asc(table.displayName)]);
    final rows = await query.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<Bank?> getById(String id) async {
    final query = _db.select(_db.banks)..where((table) => table.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> upsert(Bank bank) async {
    await _db
        .into(_db.banks)
        .insertOnConflictUpdate(
          BanksCompanion.insert(
            id: bank.id,
            displayName: bank.displayName,
            countryCode: bank.countryCode,
            region: bank.region,
            createdAt: bank.createdAt,
            updatedAt: bank.updatedAt,
          ),
        );
  }
}

Bank _toEntity(BankRow row) {
  return Bank(
    id: row.id,
    displayName: row.displayName,
    countryCode: row.countryCode,
    region: row.region,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
