enum CashbackStatus {
  pending,
  credited,
  reversed,
  adjusted;

  static CashbackStatus fromStorage(String value) {
    return CashbackStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => CashbackStatus.pending,
    );
  }
}

class CashbackEntry {
  const CashbackEntry({
    required this.id,
    required this.cardId,
    required this.amountMinor,
    required this.currencyCode,
    required this.status,
    required this.earnedAt,
    required this.createdAt,
    this.transactionId,
    this.creditedAt,
    this.reversedAt,
    this.notes,
  });

  final String id;
  final String cardId;
  final String? transactionId;
  final int amountMinor;
  final String currencyCode;
  final CashbackStatus status;
  final DateTime earnedAt;
  final DateTime? creditedAt;
  final DateTime? reversedAt;
  final String? notes;
  final DateTime createdAt;
}

/// Declarative cashback rule. Percentages are stored in basis points (1% = 100).
class CashbackRule {
  const CashbackRule({
    required this.kind,
    this.id = '',
    this.cardId = '',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.rateBasisPoints,
    this.flatAmountMinor,
    this.categoryId,
    this.merchantContains,
    this.monthlyCapMinor,
    this.currencyCode,
  });

  final String id;
  final String cardId;
  final CashbackRuleKind kind;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? rateBasisPoints;
  final int? flatAmountMinor;
  final String? categoryId;
  final String? merchantContains;
  final int? monthlyCapMinor;
  final String? currencyCode;

  bool matches({String? categoryId, String? merchant}) {
    if (this.categoryId != null && this.categoryId != categoryId) return false;
    final needle = merchantContains?.toLowerCase().trim();
    if (needle != null &&
        needle.isNotEmpty &&
        !(merchant?.toLowerCase().contains(needle) ?? false)) {
      return false;
    }
    return true;
  }
}

enum CashbackRuleKind { flat, percentage }
