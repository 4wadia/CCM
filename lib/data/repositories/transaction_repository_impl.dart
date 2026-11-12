import 'package:drift/drift.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../database/app_database.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<CardTransaction?> getById(String id) async {
    final row = await (_db.select(
      _db.transactions,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<CardTransaction>> search({
    TransactionFilter filter = const TransactionFilter(),
    int limit = 100,
    int offset = 0,
  }) async {
    final query = _db.select(_db.transactions);
    final predicate = await _buildPredicate(filter);
    if (predicate case final p?) query.where((_) => p);
    query
      ..orderBy([
        (table) => OrderingTerm.desc(table.transactionDate),
        (table) => OrderingTerm.desc(table.createdAt),
      ])
      ..limit(limit, offset: offset);
    final rows = await query.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<int> count(TransactionFilter filter) async {
    final count = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)..addColumns([count]);
    final predicate = await _buildPredicate(filter);
    if (predicate case final p?) query.where(p);
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<List<CardTransaction>> recentForCard({
    int limit = 5,
    String? cardId,
  }) async {
    final query = _db.select(_db.transactions);
    if (cardId != null) {
      query.where((table) => table.cardId.equals(cardId));
    }
    query
      ..orderBy([
        (table) => OrderingTerm.desc(table.transactionDate),
        (table) => OrderingTerm.desc(table.createdAt),
      ])
      ..limit(limit);
    final rows = await query.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<void> insert(CardTransaction transaction) async {
    await _db.into(_db.transactions).insert(_toCompanion(transaction));
  }

  @override
  Future<void> insertWithSource({
    required CardTransaction transaction,
    required TransactionSource source,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.transactions).insert(_toCompanion(transaction));
      await _db.into(_db.transactionSources).insert(_sourceCompanion(source));
    });
  }

  @override
  Future<void> updateCategory(String id, String? categoryId) async {
    await (_db.update(
      _db.transactions,
    )..where((table) => table.id.equals(id))).write(
      TransactionsCompanion(
        categoryId: Value(categoryId),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> updateMerchant({
    required String id,
    required String merchantOriginal,
    String? merchantNormalized,
  }) async {
    await (_db.update(
      _db.transactions,
    )..where((table) => table.id.equals(id))).write(
      TransactionsCompanion(
        merchantOriginal: Value(merchantOriginal),
        merchantNormalized: Value(merchantNormalized),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> assignCard({
    required String id,
    required String? cardId,
    String? bankId,
  }) async {
    await (_db.update(
      _db.transactions,
    )..where((table) => table.id.equals(id))).write(
      TransactionsCompanion(
        cardId: Value(cardId),
        bankId: Value(bankId),
        status: const Value('posted'),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> setStatus(String id, TransactionStatus status) async {
    await (_db.update(
      _db.transactions,
    )..where((table) => table.id.equals(id))).write(
      TransactionsCompanion(
        status: Value(status.name),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> markForReview(String id) =>
      setStatus(id, TransactionStatus.needsReview);

  @override
  Future<CardTransaction?> findByFingerprint(String fingerprint) async {
    final row =
        await (_db.select(_db.transactions)
              ..where((table) => table.fingerprint.equals(fingerprint))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<CardTransaction>> fuzzyCandidates({
    required String cardId,
    required int amountMinor,
    required String currencyCode,
    required DateTime transactionDate,
    int dayWindow = 3,
  }) async {
    final from = transactionDate.subtract(Duration(days: dayWindow));
    final to = transactionDate.add(Duration(days: dayWindow + 1));
    final rows =
        await (_db.select(_db.transactions)
              ..where(
                (table) =>
                    table.cardId.equals(cardId) &
                    table.amountMinor.equals(amountMinor) &
                    table.currencyCode.equals(currencyCode.toUpperCase()) &
                    table.transactionDate.isBiggerOrEqualValue(from) &
                    table.transactionDate.isSmallerThanValue(to),
              )
              ..limit(25))
            .get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<TransactionSource?> findSource({
    required TransactionSourceType sourceType,
    required String? sourceReference,
  }) async {
    if (sourceReference == null || sourceReference.trim().isEmpty) return null;
    final row =
        await (_db.select(_db.transactionSources)..where(
              (table) =>
                  table.sourceType.equals(sourceType.name) &
                  table.sourceReference.equals(sourceReference),
            ))
            .getSingleOrNull();
    return row == null ? null : _sourceToEntity(row);
  }

  @override
  Future<void> linkSource(TransactionSource source) async {
    await _db
        .into(_db.transactionSources)
        .insert(_sourceCompanion(source), mode: InsertMode.insertOrIgnore);
  }

  @override
  Future<List<TransactionSource>> sourcesFor(String transactionId) async {
    final rows = await (_db.select(
      _db.transactionSources,
    )..where((table) => table.transactionId.equals(transactionId))).get();
    return rows.map(_sourceToEntity).toList(growable: false);
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.transactionSources).go();
    await _db.delete(_db.transactions).go();
  }

  Future<Expression<bool>?> _buildPredicate(TransactionFilter f) async {
    final t = _db.transactions;
    Expression<bool>? predicate;
    void and(Expression<bool> expression) {
      predicate = predicate == null ? expression : predicate! & expression;
    }

    if (f.cardId != null) and(t.cardId.equals(f.cardId!));
    if (f.bankId != null) and(t.bankId.equals(f.bankId!));
    if (f.categoryId != null) and(t.categoryId.equals(f.categoryId!));
    if (f.unassignedOnly) and(t.cardId.isNull());
    if (f.reviewOnly) {
      and(t.status.equals(TransactionStatus.needsReview.name));
    }
    if (f.status != null) and(t.status.equals(f.status!.name));
    if (f.from != null) {
      and(t.transactionDate.isBiggerOrEqualValue(f.from!));
    }
    if (f.to != null) {
      and(
        t.transactionDate.isSmallerThanValue(
          DateTime(
            f.to!.year,
            f.to!.month,
            f.to!.day,
          ).add(const Duration(days: 1)),
        ),
      );
    }
    if (f.minAmountMinor != null) {
      and(t.amountMinor.isBiggerOrEqualValue(f.minAmountMinor!));
    }
    if (f.maxAmountMinor != null) {
      and(t.amountMinor.isSmallerOrEqualValue(f.maxAmountMinor!));
    }
    if (f.types.isNotEmpty) {
      and(t.transactionType.isIn(f.types.map((type) => type.name)));
    }
    final merchant = f.merchant?.trim();
    if (merchant != null && merchant.isNotEmpty) {
      final escaped = merchant.replaceAll('%', r'\%').replaceAll('_', r'\_');
      and(
        t.merchantNormalized.like('%$escaped%') |
            t.merchantOriginal.like('%$escaped%'),
      );
    }
    if (f.sourceType != null) {
      final sourceRows =
          await (_db.selectOnly(_db.transactionSources)
                ..addColumns([_db.transactionSources.transactionId])
                ..where(
                  _db.transactionSources.sourceType.equals(f.sourceType!.name) &
                      _db.transactionSources.transactionId.isNotNull(),
                ))
              .get();
      final ids = sourceRows
          .map((row) => row.read(_db.transactionSources.transactionId))
          .whereType<String>()
          .toSet();
      and(t.id.isIn(ids.isEmpty ? const <String>['__none__'] : ids));
    }
    return predicate;
  }

  CardTransaction _toEntity(TransactionRow row) {
    return CardTransaction(
      id: row.id,
      cardId: row.cardId,
      bankId: row.bankId,
      merchantOriginal: row.merchantOriginal,
      merchantNormalized: row.merchantNormalized,
      amountMinor: row.amountMinor,
      currencyCode: row.currencyCode,
      transactionDate: row.transactionDate,
      postingDate: row.postingDate,
      transactionType: TransactionType.fromStorage(row.transactionType),
      categoryId: row.categoryId,
      status: TransactionStatus.fromStorage(row.status),
      sourceConfidence: row.sourceConfidence == null
          ? null
          : SourceConfidence.fromStorage(row.sourceConfidence),
      notes: row.notes,
      fingerprint: row.fingerprint,
      fingerprintVersion: row.fingerprintVersion,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  TransactionsCompanion _toCompanion(CardTransaction tx) {
    return TransactionsCompanion.insert(
      id: tx.id,
      cardId: Value(tx.cardId),
      bankId: Value(tx.bankId),
      merchantOriginal: Value(tx.merchantOriginal),
      merchantNormalized: Value(tx.merchantNormalized),
      amountMinor: tx.amountMinor,
      currencyCode: tx.currencyCode,
      transactionDate: tx.transactionDate,
      postingDate: Value(tx.postingDate),
      transactionType: tx.transactionType.name,
      categoryId: Value(tx.categoryId),
      status: tx.status.name,
      sourceConfidence: Value(tx.sourceConfidence?.name),
      notes: Value(tx.notes),
      fingerprint: Value(tx.fingerprint),
      fingerprintVersion: Value(tx.fingerprintVersion),
      createdAt: tx.createdAt,
      updatedAt: tx.updatedAt,
    );
  }

  TransactionSource _sourceToEntity(TransactionSourceRow row) {
    return TransactionSource(
      id: row.id,
      transactionId: row.transactionId,
      sourceType: TransactionSourceType.fromStorage(row.sourceType),
      sourceReference: row.sourceReference,
      sourceDate: row.sourceDate,
      originalDescription: row.originalDescription,
      importJobId: row.importJobId,
      parserId: row.parserId,
      parserVersion: row.parserVersion,
      matchStatus: SourceMatchStatus.fromStorage(row.matchStatus),
      createdAt: row.createdAt,
    );
  }

  TransactionSourcesCompanion _sourceCompanion(TransactionSource source) {
    return TransactionSourcesCompanion.insert(
      id: source.id,
      transactionId: Value(source.transactionId),
      sourceType: source.sourceType.name,
      sourceReference: Value(source.sourceReference),
      sourceDate: Value(source.sourceDate),
      originalDescription: source.originalDescription,
      importJobId: Value(source.importJobId),
      parserId: Value(source.parserId),
      parserVersion: Value(source.parserVersion),
      matchStatus: source.matchStatus.name,
      createdAt: source.createdAt,
    );
  }
}
