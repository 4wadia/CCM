import '../entities/currency.dart';

/// Converts user-entered decimal amounts to ISO currency minor units exactly.
abstract final class MoneyAmount {
  static int? fractionDigits(String currencyCode) {
    return CurrencyMetadata.minorDigitsFor(currencyCode);
  }

  /// Parses a strictly positive amount, suitable for a credit limit.
  static int? parseMinorUnits(String text, String currencyCode) {
    return _parse(text, currencyCode, allowZero: false, allowNegative: false);
  }

  /// Parses a zero-or-positive amount, suitable for a current outstanding
  /// balance. Empty text is not accepted here; callers decide whether an empty
  /// field means zero.
  static int? parseNonNegativeMinorUnits(String text, String currencyCode) {
    return _parse(text, currencyCode, allowZero: true, allowNegative: false);
  }

  static int? _parse(
    String text,
    String currencyCode, {
    required bool allowZero,
    required bool allowNegative,
  }) {
    final digits = CurrencyMetadata.minorDigitsFor(currencyCode);
    if (digits == null) return null;

    final match = RegExp(r'^(-?)(\d+)(?:\.(\d*))?$').firstMatch(text.trim());
    if (match == null) return null;

    final isNegative = match.group(1) == '-';
    if (isNegative && !allowNegative) return null;

    final fraction = match.group(3) ?? '';
    if (fraction.length > digits) return null;

    final wholeValue = BigInt.tryParse(match.group(2)!);
    if (wholeValue == null) return null;

    final scale = BigInt.from(10).pow(digits);
    final fractionValue = digits == 0
        ? BigInt.zero
        : BigInt.tryParse(fraction.padRight(digits, '0'));
    if (fractionValue == null) return null;

    var minorUnits = wholeValue * scale + fractionValue;
    if (isNegative) minorUnits = -minorUnits;
    if (minorUnits < BigInt.zero) return null;
    if (!allowZero && minorUnits == BigInt.zero) return null;

    return int.tryParse(minorUnits.toString());
  }

  static String formatMinorUnits(int amountMinor, String currencyCode) {
    final digits = CurrencyMetadata.minorDigitsFor(currencyCode);
    if (digits == null) {
      throw ArgumentError.value(
        currencyCode,
        'currencyCode',
        'Expected a three-letter ISO currency code',
      );
    }

    final scale = BigInt.from(10).pow(digits);
    final value = BigInt.from(amountMinor);
    final wholeDigits = (value.abs() ~/ scale).toString();
    final groupedWhole = wholeDigits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    final sign = value.isNegative ? '-' : '';
    final fraction = digits == 0
        ? ''
        : '.${(value.abs() % scale).toString().padLeft(digits, '0')}';
    return '$currencyCode $sign$groupedWhole$fraction';
  }
}
