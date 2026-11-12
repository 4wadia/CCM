import '../entities/transaction.dart';

abstract interface class TransactionRepository {
  Future<CardTransaction?> getById(String id);

  Future<List<CardTransaction>> search({
    TransactionFilter filter = const TransactionFilter(),
    int limit = 100,
    int offset = 0,
  });

  Future<int> count(TransactionFilter filter);

  Future<List<CardTransaction>> recentForCard({int limit = 5, String? cardId});

  Future<void> insert(CardTransaction transaction);

  /// Atomically inserts the canonical transaction and its source audit row.
  Future<void> insertWithSource({
    required CardTransaction transaction,
    required TransactionSource source,
  });

  Future<void> updateCategory(String id, String? categoryId);

  Future<void> updateMerchant({
    required String id,
    required String merchantOriginal,
    String? merchantNormalized,
  });

  Future<void> assignCard({
    required String id,
    required String? cardId,
    String? bankId,
  });

  Future<void> setStatus(String id, TransactionStatus status);

  Future<void> markForReview(String id);

  Future<CardTransaction?> findByFingerprint(String fingerprint);

  Future<List<CardTransaction>> fuzzyCandidates({
    required String cardId,
    required int amountMinor,
    required String currencyCode,
    required DateTime transactionDate,
    int dayWindow = 3,
  });

  Future<TransactionSource?> findSource({
    required TransactionSourceType sourceType,
    required String? sourceReference,
  });

  Future<void> linkSource(TransactionSource source);

  Future<List<TransactionSource>> sourcesFor(String transactionId);

  Future<void> deleteAll();
}
