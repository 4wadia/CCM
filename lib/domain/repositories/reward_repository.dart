import '../entities/cashback.dart';
import '../entities/reward.dart';

abstract interface class CashbackRepository {
  Future<void> save(CashbackEntry entry);

  Future<void> saveRule(CashbackRule rule);

  Future<List<CashbackRule>> rulesForCard(String cardId);

  Future<List<CashbackRule>> allRules();

  Future<void> deleteRule(String id);

  Future<List<CashbackEntry>> getAll({int limit = 200});

  Future<List<CashbackEntry>> forCard(String cardId, {int limit = 200});

  Future<int> pendingTotalMinor(String currencyCode);

  Future<void> deleteAll();
}

abstract interface class RewardRepository {
  Future<void> saveAccount(RewardAccount account);

  Future<RewardAccount?> accountForCard(String cardId);

  Future<List<RewardAccount>> accounts();

  Future<void> saveEntry(RewardEntry entry);

  Future<List<RewardEntry>> entriesForAccount(
    String accountId, {
    int limit = 200,
  });

  Future<void> deleteAll();
}
