import '../entities/transaction_category.dart';

abstract interface class CategoryRepository {
  Future<List<TransactionCategory>> getAll();

  Future<void> upsert(TransactionCategory category);
}
