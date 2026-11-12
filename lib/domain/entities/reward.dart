enum RewardEntryType {
  earned,
  redeemed,
  expired,
  adjustment;

  static RewardEntryType fromStorage(String value) {
    return RewardEntryType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => RewardEntryType.adjustment,
    );
  }
}

class RewardAccount {
  const RewardAccount({
    required this.id,
    required this.cardId,
    required this.programmeName,
    required this.currentPoints,
    required this.updatedAt,
    this.estimatedValueMinor,
    this.currencyCode,
  });

  final String id;
  final String cardId;
  final String programmeName;
  final int currentPoints;
  final int? estimatedValueMinor;
  final String? currencyCode;
  final DateTime updatedAt;
}

class RewardEntry {
  const RewardEntry({
    required this.id,
    required this.rewardAccountId,
    required this.points,
    required this.entryType,
    required this.createdAt,
    this.transactionId,
    this.description,
    this.expiresAt,
  });

  final String id;
  final String rewardAccountId;
  final String? transactionId;
  final int points;
  final RewardEntryType entryType;
  final String? description;
  final DateTime? expiresAt;
  final DateTime createdAt;
}

/// Estimated monetary value is always explicitly an estimate.
class RewardEstimate {
  const RewardEstimate({
    required this.points,
    required this.estimatedValueMinor,
    required this.currencyCode,
  });

  final int points;
  final int estimatedValueMinor;
  final String currencyCode;
}
