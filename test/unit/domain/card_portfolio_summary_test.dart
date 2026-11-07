import 'package:credit_card_manager/domain/entities/card_portfolio_summary.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 11, 5);

  CreditCard card({
    required String id,
    required String currencyCode,
    required int limitMinor,
    CardStatus status = CardStatus.active,
  }) {
    return CreditCard(
      id: id,
      bankId: 'bank_$id',
      displayName: id,
      network: CardNetwork.visa,
      lastFour: '4242',
      creditLimitMinor: limitMinor,
      currencyCode: currencyCode,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('groups integer credit limits without combining currencies', () {
    final summaries = CardPortfolioSummary.fromCards([
      card(id: 'usd_1', currencyCode: 'USD', limitMinor: 125050),
      card(id: 'inr', currencyCode: 'INR', limitMinor: 2500000),
      card(id: 'usd_2', currencyCode: 'USD', limitMinor: 50000),
    ]);

    expect(summaries.map((summary) => summary.currencyCode), ['INR', 'USD']);
    expect(summaries[0].creditLimitMinor, 2500000);
    expect(summaries[0].cardCount, 1);
    expect(summaries[1].creditLimitMinor, 175050);
    expect(summaries[1].cardCount, 2);
  });

  test('excludes archived and closed cards', () {
    final summaries = CardPortfolioSummary.fromCards([
      card(id: 'active', currencyCode: 'USD', limitMinor: 10000),
      card(
        id: 'archived',
        currencyCode: 'USD',
        limitMinor: 20000,
        status: CardStatus.archived,
      ),
      card(
        id: 'closed',
        currencyCode: 'USD',
        limitMinor: 30000,
        status: CardStatus.closed,
      ),
    ]);

    expect(summaries.single.creditLimitMinor, 10000);
    expect(summaries.single.cardCount, 1);
  });

  test('empty portfolios have no currency totals', () {
    expect(CardPortfolioSummary.fromCards([]), isEmpty);
  });
}
