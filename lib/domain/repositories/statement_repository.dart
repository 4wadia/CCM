import '../entities/statement.dart';

abstract interface class StatementRepository {
  Future<void> save(Statement statement);

  Future<Statement?> getById(String id);

  Future<Statement?> findByHash(String fileHash);

  Future<List<Statement>> getAll({int limit = 100});

  Future<List<Statement>> forCard(String cardId, {int limit = 100});

  Future<void> updateStatus(
    String id,
    StatementProcessingStatus status, {
    String? parserId,
    String? parserVersion,
  });

  Future<void> saveStatementTransaction(StatementTransaction transaction);

  Future<List<StatementTransaction>> transactionsFor(String statementId);

  Future<void> deleteAll();
}
