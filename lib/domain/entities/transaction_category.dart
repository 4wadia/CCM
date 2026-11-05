/// A spending category. System categories are seeded and shared across cards.
class TransactionCategory {
  const TransactionCategory({
    required this.id,
    required this.name,
    required this.isSystemCategory,
    this.parentId,
  });

  final String id;
  final String name;
  final String? parentId;
  final bool isSystemCategory;
}
