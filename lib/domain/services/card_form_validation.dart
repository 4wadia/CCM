import '../entities/currency.dart';
import 'money_amount.dart';

/// Reusable, pure validation for card form fields.
abstract final class CardFormValidation {
  static String? requiredText(String? value) {
    return value == null || value.trim().isEmpty ? 'Required' : null;
  }

  static String? countryCode(String? value) {
    final code = value?.trim() ?? '';
    return RegExp(r'^[A-Za-z]{2}$').hasMatch(code)
        ? null
        : 'Use a two-letter code';
  }

  static String? lastFour(String? value) {
    return RegExp(r'^\d{4}$').hasMatch(value?.trim() ?? '')
        ? null
        : 'Enter exactly four digits';
  }

  static String? currency(String? value) {
    final code = value?.trim().toUpperCase() ?? '';
    return CurrencyMetadata.isWellFormed(code)
        ? null
        : 'Use a 3-letter ISO code';
  }

  static String? creditLimit(String? value, String currencyCode) {
    final code = currencyCode.trim().toUpperCase();
    if (!CurrencyMetadata.isWellFormed(code)) {
      return 'Enter a valid currency first';
    }
    return MoneyAmount.parseMinorUnits(value ?? '', code) == null
        ? 'Enter a positive amount with valid currency precision'
        : null;
  }

  static String? outstanding(String? value, String currencyCode) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    final code = currencyCode.trim().toUpperCase();
    if (!CurrencyMetadata.isWellFormed(code)) {
      return 'Enter a valid currency first';
    }
    return MoneyAmount.parseNonNegativeMinorUnits(text, code) == null
        ? 'Enter zero or a positive amount with valid precision'
        : null;
  }

  static String? dayOfMonth(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final day = int.tryParse(value.trim());
    return day != null && day >= 1 && day <= 31
        ? null
        : 'Enter a day from 1 to 31';
  }
}
