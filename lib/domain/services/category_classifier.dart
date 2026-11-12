import '../entities/transaction_category.dart';

/// Conservative keyword categorization. Users can always change the result.
abstract final class CategoryClassifier {
  static const Map<String, List<String>> _keywords = <String, List<String>>{
    'cat_groceries': ['grocery', 'supermarket', 'mart', 'food hall'],
    'cat_dining': ['restaurant', 'cafe', 'coffee', 'pizza', 'dining', 'bistro'],
    'cat_fuel': ['fuel', 'petrol', 'gas station', 'diesel'],
    'cat_travel': ['airline', 'flight', 'hotel', 'railway', 'irctc', 'travel'],
    'cat_utilities': [
      'electric',
      'water bill',
      'broadband',
      'utility',
      'gas bill',
    ],
    'cat_entertainment': ['cinema', 'movie', 'theatre', 'spotify', 'netflix'],
    'cat_shopping': ['amazon', 'flipkart', 'store', 'mall', 'shop'],
    'cat_health': ['pharmacy', 'hospital', 'clinic', 'medical', 'health'],
    'cat_education': ['school', 'college', 'course', 'tuition', 'education'],
    'cat_fees_interest': ['annual fee', 'late fee', 'interest charge'],
    'cat_cash_advance': ['cash advance', 'atm withdrawal'],
  };

  static String? classify(
    String description,
    List<TransactionCategory> categories,
  ) {
    final text = description.toLowerCase();
    final known = categories.map((category) => category.id).toSet();
    for (final entry in _keywords.entries) {
      if (!known.contains(entry.key)) continue;
      if (entry.value.any(text.contains)) return entry.key;
    }
    return null;
  }
}
