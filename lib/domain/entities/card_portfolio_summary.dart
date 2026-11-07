import '../services/card_financials.dart';
import 'credit_card.dart';
import 'money.dart';

/// One active card with derived financial values.
class CardSummary {
  const CardSummary(this.card);

  final CreditCard card;

  int get creditLimitMinor => card.creditLimitMinor;
  int get outstandingMinor => card.currentOutstandingMinor;

  int get availableCreditMinor => CardFinancials.availableCreditMinor(
    creditLimitMinor: creditLimitMinor,
    outstandingMinor: outstandingMinor,
  );

  double? get utilisationPercent => CardFinancials.utilisationPercent(
    creditLimitMinor: creditLimitMinor,
    outstandingMinor: outstandingMinor,
  );

  Money get limit =>
      Money(amountMinor: creditLimitMinor, currencyCode: card.currencyCode);
  Money get outstanding =>
      Money(amountMinor: outstandingMinor, currencyCode: card.currencyCode);
  Money get availableCredit =>
      Money(amountMinor: availableCreditMinor, currencyCode: card.currencyCode);
}

/// Credit totals for one currency.
///
/// Values from different currencies are never added together. A separate
/// summary exists for each currency represented by an active card.
class CardPortfolioSummary {
  const CardPortfolioSummary({
    required this.currencyCode,
    required this.creditLimitMinor,
    required this.outstandingMinor,
    required this.cardCount,
  });

  final String currencyCode;
  final int creditLimitMinor;
  final int outstandingMinor;
  final int cardCount;

  int get availableCreditMinor => CardFinancials.availableCreditMinor(
    creditLimitMinor: creditLimitMinor,
    outstandingMinor: outstandingMinor,
  );

  /// `null` when the combined limit is zero, so division is never attempted.
  double? get utilisationPercent => CardFinancials.utilisationPercent(
    creditLimitMinor: creditLimitMinor,
    outstandingMinor: outstandingMinor,
  );

  Money get creditLimit =>
      Money(amountMinor: creditLimitMinor, currencyCode: currencyCode);
  Money get outstanding =>
      Money(amountMinor: outstandingMinor, currencyCode: currencyCode);
  Money get availableCredit =>
      Money(amountMinor: availableCreditMinor, currencyCode: currencyCode);

  static List<CardPortfolioSummary> fromCards(Iterable<CreditCard> cards) {
    final totals = <String, (int limit, int outstanding, int count)>{};
    for (final card in cards) {
      if (!card.isActive) continue;

      final current = totals[card.currencyCode] ?? (0, 0, 0);
      totals[card.currencyCode] = (
        current.$1 + card.creditLimitMinor,
        current.$2 + card.currentOutstandingMinor,
        current.$3 + 1,
      );
    }

    return totals.entries
        .map(
          (entry) => CardPortfolioSummary(
            currencyCode: entry.key,
            creditLimitMinor: entry.value.$1,
            outstandingMinor: entry.value.$2,
            cardCount: entry.value.$3,
          ),
        )
        .toList()
      ..sort((left, right) => left.currencyCode.compareTo(right.currencyCode));
  }
}

/// Active cards and their currency-grouped totals.
class CardPortfolio {
  const CardPortfolio({required this.cards, required this.byCurrency});

  final List<CardSummary> cards;
  final List<CardPortfolioSummary> byCurrency;

  bool get isEmpty => cards.isEmpty;

  /// Utilisation is only comparable when every active card shares a currency.
  bool get hasComparableCurrencies => byCurrency.length == 1;

  /// Overall utilisation, or `null` when currencies are mixed or no limit
  /// exists.
  double? get overallUtilisationPercent {
    if (!hasComparableCurrencies) return null;
    return byCurrency.single.utilisationPercent;
  }

  factory CardPortfolio.fromCards(Iterable<CreditCard> cards) {
    final active = cards.where((card) => card.isActive).toList()
      ..sort(
        (left, right) => left.displayName.toLowerCase().compareTo(
          right.displayName.toLowerCase(),
        ),
      );

    return CardPortfolio(
      cards: active.map(CardSummary.new).toList(growable: false),
      byCurrency: CardPortfolioSummary.fromCards(active),
    );
  }
}
