import '../entities/bank.dart';

abstract interface class BankRepository {
  Future<List<Bank>> getAll();

  Future<Bank?> getById(String id);

  Future<void> upsert(Bank bank);
}
