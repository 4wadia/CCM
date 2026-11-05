/// Card networks supported by the product specification.
enum CardNetwork {
  visa,
  mastercard,
  americanExpress,
  rupay,
  discover,
  other;

  static CardNetwork fromStorage(String value) {
    return CardNetwork.values.firstWhere(
      (network) => network.name == value,
      orElse: () => CardNetwork.other,
    );
  }
}

/// Lifecycle of a card. Cards are archived, not hard-deleted.
enum CardStatus {
  active,
  archived,
  closed;

  static CardStatus fromStorage(String value) {
    for (final status in CardStatus.values) {
      if (status.name == value) {
        return status;
      }
    }
    // Unknown statuses are a data-integrity problem; fail loudly rather than
    // hiding a card by guessing.
    throw ArgumentError.value(value, 'value', 'Unknown card status');
  }
}

/// A credit card owned by the user.
///
/// Only the last four digits are ever stored. CVV, PIN, and full card numbers are
/// prohibited by the specification.
class CreditCard {
  const CreditCard({
    required this.id,
    required this.bankId,
    required this.displayName,
    required this.network,
    required this.lastFour,
    required this.creditLimitMinor,
    required this.currencyCode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.cardholderName,
    this.statementDay,
    this.dueDay,
    this.billingCycleStart,
    this.billingCycleEnd,
    this.rewardProgramme,
    this.colorValue,
  });

  final String id;
  final String bankId;
  final String displayName;

  /// Only present when required by a bank's statement password rule.
  final String? cardholderName;

  final CardNetwork network;
  final String lastFour;

  /// Credit limit in integer minor units. Never a floating-point value.
  final int creditLimitMinor;

  /// ISO 4217 currency code.
  final String currencyCode;

  final int? statementDay;
  final int? dueDay;
  final DateTime? billingCycleStart;
  final DateTime? billingCycleEnd;
  final CardStatus status;
  final String? rewardProgramme;

  /// Optional visual identifier; the design workstream defines usage.
  final int? colorValue;

  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive => status == CardStatus.active;
}
