/// Deterministic merchant normalization used for fingerprints and matching.
///
/// This is intentionally conservative: it removes payment-channel noise but
/// keeps the distinguishing merchant words. The algorithm is versioned so
/// fingerprints can be recalculated if it changes.
abstract final class MerchantNormalizer {
  static const int version = 1;

  static final List<RegExp> _noise = <RegExp>[
    RegExp(r'\bpos\b', caseSensitive: false),
    RegExp(r'\bvisa\b', caseSensitive: false),
    RegExp(r'\bmastercard\b', caseSensitive: false),
    RegExp(r'\brupay\b', caseSensitive: false),
    RegExp(r'\bamex\b', caseSensitive: false),
    RegExp(r'\bdebit\b', caseSensitive: false),
    RegExp(r'\bcredit\b', caseSensitive: false),
    RegExp(r'\bpurchase\b', caseSensitive: false),
    RegExp(r'\bpayment\b', caseSensitive: false),
    RegExp(r'\btxn\b', caseSensitive: false),
    RegExp(r'\btransaction\b', caseSensitive: false),
    RegExp(r'\bref(?:erence)?\b', caseSensitive: false),
  ];

  static String normalize(String? raw) {
    if (raw == null) return '';
    var value = raw.toLowerCase().trim();
    if (value.isEmpty) return '';
    value = value.replaceAll('&', ' and ');
    for (final pattern in _noise) {
      value = value.replaceAll(pattern, ' ');
    }
    value = value
        .replaceAll(RegExp(r'\b\d{4,}\b'), ' ')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return value;
  }

  /// Jaccard similarity over tokens. Values are in the range 0..1.
  static double similarity(String left, String right) {
    final a = normalize(left).split(' ').where((t) => t.isNotEmpty).toSet();
    final b = normalize(right).split(' ').where((t) => t.isNotEmpty).toSet();
    if (a.isEmpty || b.isEmpty) return 0;
    final intersection = a.intersection(b).length;
    final union = a.union(b).length;
    return union == 0 ? 0 : intersection / union;
  }
}
