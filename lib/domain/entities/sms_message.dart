/// Raw SMS metadata. [body] is sensitive and must never be logged.
class SmsMessage {
  const SmsMessage({
    required this.id,
    required this.sender,
    required this.body,
    required this.receivedAt,
  });

  final String id;
  final String sender;
  final String body;
  final DateTime receivedAt;
}

enum SmsCategory {
  otp,
  promotional,
  transactional,
  unknown;

  String get label => switch (this) {
    SmsCategory.otp => 'One-time code',
    SmsCategory.promotional => 'Promotional',
    SmsCategory.transactional => 'Transaction alert',
    SmsCategory.unknown => 'Unclassified',
  };
}
