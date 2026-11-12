class EmailAccount {
  const EmailAccount({
    required this.id,
    required this.provider,
    required this.emailAddress,
    required this.secureTokenReference,
    required this.status,
    required this.syncEnabled,
    required this.connectedAt,
    required this.createdAt,
    required this.updatedAt,
    this.lastSuccessfulSync,
  });

  final String id;
  final String provider;
  final String emailAddress;

  /// Opaque reference to tokens in platform secure storage. Never a token.
  final String secureTokenReference;
  final String status;
  final bool syncEnabled;
  final DateTime connectedAt;
  final DateTime? lastSuccessfulSync;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class SyncCheckpoint {
  const SyncCheckpoint({
    required this.id,
    required this.emailAccountId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.providerCheckpoint,
    this.lastSyncStarted,
    this.lastSyncCompleted,
    this.errorCode,
  });

  final String id;
  final String emailAccountId;
  final String? providerCheckpoint;
  final DateTime? lastSyncStarted;
  final DateTime? lastSyncCompleted;
  final String status;
  final String? errorCode;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class OAuthTokens {
  const OAuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.emailAddress,
    this.scopes = const <String>[],
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String? emailAddress;
  final List<String> scopes;
}

class EmailAttachment {
  const EmailAttachment({
    required this.attachmentId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
  });

  final String attachmentId;
  final String fileName;
  final String mimeType;
  final int sizeBytes;

  bool get isPdf =>
      mimeType.toLowerCase() == 'application/pdf' ||
      fileName.toLowerCase().endsWith('.pdf');
}

class EmailCandidate {
  const EmailCandidate({
    required this.messageId,
    required this.sender,
    required this.subject,
    required this.receivedAt,
    required this.attachments,
    required this.confidence,
    this.cardLastFour,
    this.bankHint,
    this.reason,
  });

  final String messageId;
  final String sender;
  final String subject;
  final DateTime receivedAt;
  final List<EmailAttachment> attachments;
  final double confidence;
  final String? cardLastFour;
  final String? bankHint;
  final String? reason;
}

class BankRule {
  const BankRule({
    required this.id,
    required this.bankId,
    required this.ruleType,
    required this.configurationVersion,
    required this.configuration,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String bankId;
  final String ruleType;
  final String configurationVersion;
  final String configuration;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
}
