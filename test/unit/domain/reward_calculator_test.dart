import 'package:credit_card_manager/domain/entities/cashback.dart';
import 'package:credit_card_manager/domain/entities/reward.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/domain/services/reward_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 11, 5);

  CardTransaction transaction({
    int amountMinor = 100000,
    String currencyCode = 'INR',
    TransactionType type = TransactionType.purchase,
    String? categoryId = 'cat_dining',
    String? merchant = 'Coffee House',
  }) {
    return CardTransaction(
      id: 'tx_1',
      cardId: 'card_1',
      amountMinor: amountMinor,
      currencyCode: currencyCode,
      transactionDate: now,
      transactionType: type,
      categoryId: categoryId,
      merchantOriginal: merchant,
      status: TransactionStatus.posted,
      createdAt: now,
      updatedAt: now,
    );
  }

  CashbackRule percentage({
    int basisPoints = 200,
    String? currencyCode = 'INR',
    String? categoryId,
    String? merchantContains,
    int? monthlyCapMinor,
  }) {
    return CashbackRule(
      id: 'rule_1',
      cardId: 'card_1',
      kind: CashbackRuleKind.percentage,
      rateBasisPoints: basisPoints,
      currencyCode: currencyCode,
      categoryId: categoryId,
      merchantContains: merchantContains,
      monthlyCapMinor: monthlyCapMinor,
    );
  }

  test('calculates percentage cashback with integer basis points', () {
    final result = RewardCalculator.cashbackFor(
      transaction: transaction(),
      rule: percentage(basisPoints: 250),
      monthEarnedMinor: 0,
    );

    expect(result.eligible, isTrue);
    expect(result.amountMinor, 2500);
    expect(result.capApplied, isFalse);
  });

  test('calculates flat cashback', () {
    final result = RewardCalculator.cashbackFor(
      transaction: transaction(),
      rule: const CashbackRule(
        id: 'rule_flat',
        cardId: 'card_1',
        kind: CashbackRuleKind.flat,
        flatAmountMinor: 5000,
        currencyCode: 'INR',
      ),
      monthEarnedMinor: 0,
    );

    expect(result.amountMinor, 5000);
  });

  test('applies the remaining monthly cap', () {
    final result = RewardCalculator.cashbackFor(
      transaction: transaction(),
      rule: percentage(basisPoints: 500, monthlyCapMinor: 3000),
      monthEarnedMinor: 2900,
    );

    expect(result.amountMinor, 100);
    expect(result.capApplied, isTrue);
    expect(result.eligible, isTrue);
  });

  test('returns zero once the cap is exhausted', () {
    final result = RewardCalculator.cashbackFor(
      transaction: transaction(),
      rule: percentage(monthlyCapMinor: 3000),
      monthEarnedMinor: 3000,
    );

    expect(result.amountMinor, 0);
    expect(result.capApplied, isTrue);
    expect(result.eligible, isFalse);
  });

  test('does not earn cashback on credits or payments', () {
    for (final type in [
      TransactionType.refund,
      TransactionType.payment,
      TransactionType.reversal,
    ]) {
      final result = RewardCalculator.cashbackFor(
        transaction: transaction(type: type),
        rule: percentage(),
        monthEarnedMinor: 0,
      );
      expect(result.eligible, isFalse, reason: type.name);
      expect(result.amountMinor, 0);
    }
  });

  test('does not earn on negative or zero purchases', () {
    final result = RewardCalculator.cashbackFor(
      transaction: transaction(amountMinor: 0),
      rule: percentage(),
      monthEarnedMinor: 0,
    );

    expect(result.eligible, isFalse);
  });

  test('requires the rule currency to match', () {
    final result = RewardCalculator.cashbackFor(
      transaction: transaction(currencyCode: 'USD'),
      rule: percentage(currencyCode: 'INR'),
      monthEarnedMinor: 0,
    );

    expect(result.eligible, isFalse);
  });

  test('honours category and merchant eligibility', () {
    final categoryMismatch = RewardCalculator.cashbackFor(
      transaction: transaction(categoryId: 'cat_fuel'),
      rule: percentage(categoryId: 'cat_dining'),
      monthEarnedMinor: 0,
    );
    expect(categoryMismatch.eligible, isFalse);

    final merchantMismatch = RewardCalculator.cashbackFor(
      transaction: transaction(merchant: 'Fuel Station'),
      rule: percentage(merchantContains: 'coffee'),
      monthEarnedMinor: 0,
    );
    expect(merchantMismatch.eligible, isFalse);

    final merchantMatch = RewardCalculator.cashbackFor(
      transaction: transaction(merchant: 'Coffee House'),
      rule: percentage(merchantContains: 'coffee'),
      monthEarnedMinor: 0,
    );
    expect(merchantMatch.eligible, isTrue);
  });

  test('estimates point value without floating point', () {
    final estimate = RewardCalculator.estimatePoints(
      points: 1250,
      minorUnitsPerPoint: 25,
      currencyCode: 'INR',
    );

    expect(estimate.estimatedValueMinor, 31250);
    expect(estimate.currencyCode, 'INR');
  });

  test('active points exclude expired entries', () {
    final entries = [
      RewardEntry(
        id: 'one',
        rewardAccountId: 'account',
        points: 100,
        entryType: RewardEntryType.earned,
        createdAt: now,
      ),
      RewardEntry(
        id: 'two',
        rewardAccountId: 'account',
        points: 50,
        entryType: RewardEntryType.earned,
        expiresAt: now.subtract(const Duration(days: 1)),
        createdAt: now,
      ),
      RewardEntry(
        id: 'three',
        rewardAccountId: 'account',
        points: -25,
        entryType: RewardEntryType.redeemed,
        createdAt: now,
      ),
    ];

    expect(RewardCalculator.activePoints(entries, asOf: now), 75);
  });
}
