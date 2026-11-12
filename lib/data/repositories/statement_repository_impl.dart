import 'package:drift/drift.dart';

import '../../domain/entities/statement.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/statement_repository.dart';
import '../database/app_database.dart';

class StatementRepositoryImpl implements StatementRepository {
  StatementRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(Statement statement) async {
    final existing = await getById(statement.id);
    final companion = StatementsCompanion.insert(
      id: statement.id,
      cardId: Value(statement.cardId),
      bankId: Value(statement.bankId),
      statementPeriodStart: statement.statementPeriodStart,
      statementPeriodEnd: statement.statementPeriodEnd,
      statementDate: statement.statementDate,
      paymentDueDate: Value(statement.paymentDueDate),
      previousBalanceMinor: Value(statement.previousBalanceMinor),
      totalDueMinor: Value(statement.totalDueMinor),
      minimumDueMinor: Value(statement.minimumDueMinor),
      currencyCode: statement.currencyCode,
      encryptedFilePath: statement.encryptedFilePath,
      fileHash: statement.fileHash,
      fileSizeBytes: Value(statement.fileSizeBytes),
      processingStatus: statement.processingStatus.name,
      parserId: Value(statement.parserId),
      parserVersion: Value(statement.parserVersion),
      createdAt: statement.createdAt,
      updatedAt: statement.updatedAt,
    );
    if (existing == null) {
      await _db.into(_db.statements).insert(companion);
    } else {
      await (_db.update(
        _db.statements,
      )..where((table) => table.id.equals(statement.id))).write(companion);
    }
  }

  @override
  Future<Statement?> getById(String id) async {
    final row = await (_db.select(
      _db.statements,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<Statement?> findByHash(String fileHash) async {
    final row =
        await (_db.select(_db.statements)
              ..where((table) => table.fileHash.equals(fileHash))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<Statement>> getAll({int limit = 100}) async {
    final rows =
        await (_db.select(_db.statements)
              ..orderBy([(table) => OrderingTerm.desc(table.statementDate)])
              ..limit(limit))
            .get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<List<Statement>> forCard(String cardId, {int limit = 100}) async {
    final rows =
        await (_db.select(_db.statements)
              ..where((table) => table.cardId.equals(cardId))
              ..orderBy([(table) => OrderingTerm.desc(table.statementDate)])
              ..limit(limit))
            .get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<void> updateStatus(
    String id,
    StatementProcessingStatus status, {
    String? parserId,
    String? parserVersion,
  }) async {
    await (_db.update(
      _db.statements,
    )..where((table) => table.id.equals(id))).write(
      StatementsCompanion(
        processingStatus: Value(status.name),
        parserId: Value(parserId),
        parserVersion: Value(parserVersion),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> saveStatementTransaction(
    StatementTransaction transaction,
  ) async {
    await _db
        .into(_db.statementTransactions)
        .insertOnConflictUpdate(
          StatementTransactionsCompanion.insert(
            id: transaction.id,
            statementId: transaction.statementId,
            transactionId: Value(transaction.transactionId),
            description: transaction.description,
            merchantNormalized: Value(transaction.merchantNormalized),
            amountMinor: transaction.amountMinor,
            currencyCode: transaction.currencyCode,
            transactionDate: transaction.transactionDate,
            postingDate: Value(transaction.postingDate),
            transactionType: transaction.transactionType.name,
            matchStatus: transaction.matchStatus.name,
            createdAt: transaction.createdAt,
          ),
        );
  }

  @override
  Future<List<StatementTransaction>> transactionsFor(String statementId) async {
    final rows =
        await (_db.select(_db.statementTransactions)
              ..where((table) => table.statementId.equals(statementId))
              ..orderBy([(table) => OrderingTerm.asc(table.transactionDate)]))
            .get();
    return rows.map(_transactionToEntity).toList(growable: false);
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.statementTransactions).go();
    await _db.delete(_db.statements).go();
  }

  Statement _toEntity(StatementRow row) {
    return Statement(
      id: row.id,
      cardId: row.cardId,
      bankId: row.bankId,
      statementPeriodStart: row.statementPeriodStart,
      statementPeriodEnd: row.statementPeriodEnd,
      statementDate: row.statementDate,
      paymentDueDate: row.paymentDueDate,
      previousBalanceMinor: row.previousBalanceMinor,
      totalDueMinor: row.totalDueMinor,
      minimumDueMinor: row.minimumDueMinor,
      currencyCode: row.currencyCode,
      encryptedFilePath: row.encryptedFilePath,
      fileHash: row.fileHash,
      fileSizeBytes: row.fileSizeBytes,
      processingStatus: StatementProcessingStatus.fromStorage(
        row.processingStatus,
      ),
      parserId: row.parserId,
      parserVersion: row.parserVersion,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  StatementTransaction _transactionToEntity(StatementTransactionRow row) {
    return StatementTransaction(
      id: row.id,
      statementId: row.statementId,
      transactionId: row.transactionId,
      description: row.description,
      merchantNormalized: row.merchantNormalized,
      amountMinor: row.amountMinor,
      currencyCode: row.currencyCode,
      transactionDate: row.transactionDate,
      postingDate: row.postingDate,
      transactionType: TransactionType.fromStorage(row.transactionType),
      matchStatus: StatementMatchStatus.fromStorage(row.matchStatus),
      createdAt: row.createdAt,
    );
  }
}
