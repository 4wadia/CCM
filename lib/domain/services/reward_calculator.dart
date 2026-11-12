import 'dart:math';

import '../entities/cashback.dart';
import '../entities/reward.dart';
import '../entities/transaction.dart';

class CashbackCalculation {
  const CashbackCalculation({
    required this.amountMinor,
    required this.status,
    required this.capApplied,
    required this.eligible,
  });

  final int amountMinor;
  final CashbackStatus status;
  final bool capApplied;
  final bool eligible;
}

/// Pure integer cashback arithmetic. A rule applies only to purchases and
/// category/merchant eligibility. Monthly caps are evaluated against the
/// already-earned amount supplied by the caller.
abstract final class RewardCalculator {
  static CashbackCalculation cashbackFor({
    required CardTransaction transaction,
    required CashbackRule rule,
    required int monthEarnedMinor,
  }) {
    if (transaction.transactionType != TransactionType.purchase ||
        transaction.amountMinor <= 0) {
      return const CashbackCalculation(
        amountMinor: 0,
        status: CashbackStatus.pending,
        capApplied: false,
        eligible: false,
      );
    }
    if (rule.currencyCode != null &&
        rule.currencyCode!.toUpperCase() !=
            transaction.currencyCode.toUpperCase()) {
      return const CashbackCalculation(
        amountMinor: 0,
        status: CashbackStatus.pending,
        capApplied: false,
        eligible: false,
      );
    }
    if (!rule.matches(
      categoryId: transaction.categoryId,
      merchant: transaction.displayMerchant,
    )) {
      return const CashbackCalculation(
        amountMinor: 0,
        status: CashbackStatus.pending,
        capApplied: false,
        eligible: false,
      );
    }

    final raw = switch (rule.kind) {
      CashbackRuleKind.flat => rule.flatAmountMinor ?? 0,
      CashbackRuleKind.percentage =>
        transaction.amountMinor * (rule.rateBasisPoints ?? 0) ~/ 10000,
    };
    var amount = max(0, raw);
    var capped = false;
    if (rule.monthlyCapMinor != null) {
      final remaining = max(0, rule.monthlyCapMinor! - monthEarnedMinor);
      if (amount > remaining) {
        amount = remaining;
        capped = true;
      }
    }
    return CashbackCalculation(
      amountMinor: amount,
      status: CashbackStatus.pending,
      capApplied: capped,
      eligible: amount > 0,
    );
  }

  /// Estimates a monetary value for points using a caller-supplied conversion
  /// rate. The result is always labelled as an estimate in the UI.
  static RewardEstimate estimatePoints({
    required int points,
    required int minorUnitsPerPoint,
    required String currencyCode,
  }) {
    return RewardEstimate(
      points: points,
      estimatedValueMinor: max(0, points) * max(0, minorUnitsPerPoint),
      currencyCode: currencyCode,
    );
  }

  static int activePoints(List<RewardEntry> entries, {DateTime? asOf}) {
    final now = asOf ?? DateTime.now();
    var total = 0;
    for (final entry in entries) {
      if (entry.expiresAt != null && entry.expiresAt!.isBefore(now)) continue;
      total += entry.points;
    }
    return max(0, total);
  }
}
