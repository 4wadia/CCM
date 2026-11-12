// ignore_for_file: prefer_initializing_formals
import '../entities/cashback.dart';
import '../repositories/reward_repository.dart';
import '../repositories/transaction_repository.dart';
import 'ids.dart';
import 'reward_calculator.dart';

/// Applies active declarative rules to recent purchases, creating pending ledger
/// entries only once per transaction. No points are assumed for ordinary
/// purchases.
class CashbackApplicationService {
  CashbackApplicationService({
    required CashbackRepository cashback,
    required TransactionRepository transactions,
  }) : _cashback = cashback,
       _transactions = transactions;

  final CashbackRepository _cashback;
  final TransactionRepository _transactions;

  Future<int> applyRules({DateTime? now}) async {
    final rules = await _cashback.allRules();
    if (rules.isEmpty) return 0;
    final transactions = await _transactions.search(limit: 1000);
    final existing = await _cashback.getAll(limit: 10000);
    final claimed = existing
        .map((entry) => entry.transactionId)
        .whereType<String>()
        .toSet();
    final cutoff = (now ?? DateTime.now()).subtract(const Duration(days: 120));
    var created = 0;
    for (final rule in rules.where((rule) => rule.isActive)) {
      final cardTransactions = transactions.where(
        (tx) =>
            tx.cardId == rule.cardId &&
            !tx.transactionDate.isBefore(cutoff) &&
            !claimed.contains(tx.id) &&
            tx.currencyCode.toUpperCase() ==
                (rule.currencyCode ?? tx.currencyCode).toUpperCase(),
      );
      for (final transaction in cardTransactions) {
        final monthStart = DateTime(
          transaction.transactionDate.year,
          transaction.transactionDate.month,
        );
        final monthEarned = existing
            .where(
              (entry) =>
                  entry.cardId == rule.cardId &&
                  entry.currencyCode == transaction.currencyCode &&
                  !entry.earnedAt.isBefore(monthStart) &&
                  entry.earnedAt.isBefore(
                    DateTime(monthStart.year, monthStart.month + 1),
                  ),
            )
            .fold<int>(0, (sum, entry) => sum + entry.amountMinor);
        final calculation = RewardCalculator.cashbackFor(
          transaction: transaction,
          rule: rule,
          monthEarnedMinor: monthEarned,
        );
        if (!calculation.eligible || calculation.amountMinor <= 0) continue;
        final entry = CashbackEntry(
          id: Ids.next('cashback'),
          cardId: rule.cardId,
          transactionId: transaction.id,
          amountMinor: calculation.amountMinor,
          currencyCode: transaction.currencyCode,
          status: calculation.status,
          earnedAt: transaction.transactionDate,
          createdAt: DateTime.now().toUtc(),
          notes: calculation.capApplied ? 'Monthly cap applied.' : null,
        );
        await _cashback.save(entry);
        existing.add(entry);
        claimed.add(transaction.id);
        created++;
      }
    }
    return created;
  }
}
