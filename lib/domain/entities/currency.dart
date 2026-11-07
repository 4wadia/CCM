/// ISO 4217 currency metadata used for exact minor-unit conversion.
///
/// Most currencies use two decimal digits. The exception sets below are the
/// maintained table required by the specification; unknown but well-formed codes
/// fall back to two digits rather than guessing a different precision.
abstract final class CurrencyMetadata {
  static final RegExp _codePattern = RegExp(r'^[A-Z]{3}$');

  static const Set<String> zeroDigitCurrencies = <String>{
    'BIF',
    'CLP',
    'DJF',
    'GNF',
    'ISK',
    'JPY',
    'KMF',
    'KRW',
    'PYG',
    'RWF',
    'UGX',
    'UYI',
    'VND',
    'VUV',
    'XAF',
    'XOF',
    'XPF',
  };

  static const Set<String> threeDigitCurrencies = <String>{
    'BHD',
    'IQD',
    'JOD',
    'KWD',
    'LYD',
    'OMR',
    'TND',
  };

  static const Set<String> fourDigitCurrencies = <String>{'CLF', 'UYW'};

  static bool isWellFormed(String currencyCode) {
    return _codePattern.hasMatch(currencyCode);
  }

  /// Returns the number of decimal digits for [currencyCode], or `null` when the
  /// code is not a three-letter uppercase ISO-style code.
  static int? minorDigitsFor(String currencyCode) {
    if (!isWellFormed(currencyCode)) return null;
    if (zeroDigitCurrencies.contains(currencyCode)) return 0;
    if (threeDigitCurrencies.contains(currencyCode)) return 3;
    if (fourDigitCurrencies.contains(currencyCode)) return 4;
    return 2;
  }
}
