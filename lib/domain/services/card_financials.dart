/// Pure financial calculations for credit cards.
///
/// All money values are integer minor units. `double` is only used for the
/// derived utilisation percentage, never for money.
abstract final class CardFinancials {
  /// Credit still available on a card.
  ///
  /// May be negative when the reconciled balance exceeds the limit.
  static int availableCreditMinor({
    required int creditLimitMinor,
    required int outstandingMinor,
  }) {
    return creditLimitMinor - outstandingMinor;
  }

  /// Utilisation as a percentage, or `null` when it cannot be calculated.
  ///
  /// Utilisation is omitted for a zero or negative limit. A zero or credit
  /// (negative outstanding) balance is reported as 0%.
  static double? utilisationPercent({
    required int creditLimitMinor,
    required int outstandingMinor,
  }) {
    if (creditLimitMinor <= 0) return null;
    if (outstandingMinor <= 0) return 0;
    return outstandingMinor / creditLimitMinor * 100;
  }
}
