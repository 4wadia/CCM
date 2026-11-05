import '../entities/credit_card.dart';

abstract interface class CreditCardRepository {
  /// Returns cards ordered by display name. Archived and closed cards are
  /// excluded unless [includeArchived] is true.
  Future<List<CreditCard>> getAll({bool includeArchived = false});

  Future<CreditCard?> getById(String id);

  Future<void> upsert(CreditCard card);

  Future<void> archive(String id);

  Future<void> restore(String id);

  Future<void> close(String id);
}
