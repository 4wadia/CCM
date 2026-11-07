/// An exact monetary value in integer minor units.
///
/// Never construct money from a `double`. Arithmetic is only allowed between
/// values in the same currency; callers must group by currency first.
class Money {
  const Money({required this.amountMinor, required this.currencyCode});

  const Money.zero(this.currencyCode) : amountMinor = 0;

  final int amountMinor;
  final String currencyCode;

  bool get isNegative => amountMinor < 0;

  Money operator +(Money other) {
    _requireSameCurrency(other);
    return Money(
      amountMinor: amountMinor + other.amountMinor,
      currencyCode: currencyCode,
    );
  }

  Money operator -(Money other) {
    _requireSameCurrency(other);
    return Money(
      amountMinor: amountMinor - other.amountMinor,
      currencyCode: currencyCode,
    );
  }

  void _requireSameCurrency(Money other) {
    if (other.currencyCode != currencyCode) {
      throw ArgumentError(
        'Cannot combine ${other.currencyCode} with $currencyCode',
      );
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Money &&
        other.amountMinor == amountMinor &&
        other.currencyCode == currencyCode;
  }

  @override
  int get hashCode => Object.hash(amountMinor, currencyCode);

  @override
  String toString() => '$currencyCode $amountMinor minor units';
}
