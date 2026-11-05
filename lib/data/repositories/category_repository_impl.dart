import 'package:drift/drift.dart';

import '../../domain/entities/transaction_category.dart';
import '../../domain/repositories/category_repository.dart';
import '../database/app_database.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<TransactionCategory>> getAll() async {
    final query = _db.select(_db.categories)
      ..orderBy([(table) => OrderingTerm.asc(table.name)]);
    final rows = await query.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<void> upsert(TransactionCategory category) async {
    await _db
        .into(_db.categories)
        .insertOnConflictUpdate(
          CategoriesCompanion.insert(
            id: category.id,
            name: category.name,
            parentId: Value(category.parentId),
            isSystemCategory: Value(category.isSystemCategory),
          ),
        );
  }
}

TransactionCategory _toEntity(CategoryRow row) {
  return TransactionCategory(
    id: row.id,
    name: row.name,
    parentId: row.parentId,
    isSystemCategory: row.isSystemCategory,
  );
}
