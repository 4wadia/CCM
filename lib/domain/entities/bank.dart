/// A bank or card issuer.
class Bank {
  const Bank({
    required this.id,
    required this.displayName,
    required this.countryCode,
    required this.region,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String displayName;

  /// ISO 3166-1 alpha-2 country code.
  final String countryCode;

  /// Human-readable region used by the adapter catalogue (for example, "India").
  final String region;

  final DateTime createdAt;
  final DateTime updatedAt;
}
