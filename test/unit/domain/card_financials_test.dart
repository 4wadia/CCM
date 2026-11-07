import 'package:credit_card_manager/domain/entities/card_portfolio_summary.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/services/card_financials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 11, 5);

  CreditCard card({
    required String id,
    required String currencyCode,
    required int limitMinor,
    int outstandingMinor = 0,
    CardStatus status = CardStatus.active,
  }) {
    return CreditCard(
      id: id,
      bankId: 'bank_$id',
      displayName: id,
      network: CardNetwork.visa,
      lastFour: '4242',
      creditLimitMinor: limitMinor,
      currentOutstandingMinor: outstandingMinor,
      currencyCode: currencyCode,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('calculates available credit and utilisation exactly', () {
    expect(
      CardFinancials.availableCreditMinor(
        creditLimitMinor: 100000,
        outstandingMinor: 25000,
      ),
      75000,
    );
    expect(
      CardFinancials.utilisationPercent(
        creditLimitMinor: 100000,
        outstandingMinor: 25000,
      ),
      25,
    );
    expect(
      CardFinancials.utilisationPercent(
        creditLimitMinor: 100000,
        outstandingMinor: 0,
      ),
      0,
    );
    expect(
      CardFinancials.utilisationPercent(
        creditLimitMinor: 100000,
        outstandingMinor: -5000,
      ),
      0,
    );
    expect(
      CardFinancials.utilisationPercent(
        creditLimitMinor: 100000,
        outstandingMinor: 150000,
      ),
      150,
    );
  });

  test('omits utilisation when the combined limit is zero', () {
    expect(
      CardFinancials.utilisationPercent(
        creditLimitMinor: 0,
        outstandingMinor: 1000,
      ),
      isNull,
    );
    expect(
      CardFinancials.utilisationPercent(
        creditLimitMinor: -1,
        outstandingMinor: 1000,
      ),
      isNull,
    );
  });

  test('groups limits, outstanding, and available credit by currency', () {
    final summaries = CardPortfolioSummary.fromCards([
      card(
        id: 'usd_1',
        currencyCode: 'USD',
        limitMinor: 125050,
        outstandingMinor: 25050,
      ),
      card(
        id: 'inr',
        currencyCode: 'INR',
        limitMinor: 2500000,
        outstandingMinor: 500000,
      ),
      card(
        id: 'usd_2',
        currencyCode: 'USD',
        limitMinor: 50000,
        outstandingMinor: 10000,
      ),
    ]);

    expect(summaries.map((summary) => summary.currencyCode), ['INR', 'USD']);
    expect(summaries[0].creditLimitMinor, 2500000);
    expect(summaries[0].outstandingMinor, 500000);
    expect(summaries[0].availableCreditMinor, 2000000);
    expect(summaries[0].utilisationPercent, 20);
    expect(summaries[1].creditLimitMinor, 175050);
    expect(summaries[1].outstandingMinor, 35050);
    expect(summaries[1].availableCreditMinor, 140000);
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

  test('does not compute an overall percentage across currencies', () {
    final portfolio = CardPortfolio.fromCards([
      card(id: 'usd', currencyCode: 'USD', limitMinor: 10000),
      card(id: 'inr', currencyCode: 'INR', limitMinor: 200000),
    ]);

    expect(portfolio.byCurrency, hasLength(2));
    expect(portfolio.hasComparableCurrencies, isFalse);
    expect(portfolio.overallUtilisationPercent, isNull);
  });

  test('computes overall utilisation for a single currency', () {
    final portfolio = CardPortfolio.fromCards([
      card(
        id: 'usd_1',
        currencyCode: 'USD',
        limitMinor: 10000,
        outstandingMinor: 2500,
      ),
      card(
        id: 'usd_2',
        currencyCode: 'USD',
        limitMinor: 30000,
        outstandingMinor: 7500,
      ),
    ]);

    expect(portfolio.hasComparableCurrencies, isTrue);
    expect(portfolio.overallUtilisationPercent, 25);
    expect(portfolio.cards, hasLength(2));
    expect(portfolio.cards.first.card.id, 'usd_1');
    expect(portfolio.cards.first.availableCreditMinor, 7500);
  });

  test('empty portfolios have no currency totals or cards', () {
    final portfolio = CardPortfolio.fromCards([]);
    expect(portfolio.isEmpty, isTrue);
    expect(portfolio.byCurrency, isEmpty);
    expect(portfolio.overallUtilisationPercent, isNull);
  });
}
