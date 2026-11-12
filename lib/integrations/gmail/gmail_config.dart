/// Public OAuth configuration supplied at build time. No client secret is used
/// and no credential is checked into source control.
class GmailConfig {
  const GmailConfig({
    required this.clientId,
    required this.redirectUri,
    this.scopes = defaultScopes,
  });

  factory GmailConfig.fromEnvironment() {
    const clientId = String.fromEnvironment('GMAIL_CLIENT_ID');
    const configuredRedirect = String.fromEnvironment('GMAIL_REDIRECT_URI');
    final redirect = configuredRedirect.isNotEmpty
        ? configuredRedirect
        : clientId.isEmpty
        ? ''
        : 'com.googleusercontent.apps.$clientId:/oauth2redirect';
    return GmailConfig(clientId: clientId, redirectUri: redirect);
  }

  static const List<String> defaultScopes = <String>[
    'openid',
    'email',
    'https://www.googleapis.com/auth/gmail.readonly',
  ];

  static const String authorizationEndpoint =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String tokenEndpoint = 'https://oauth2.googleapis.com/token';
  static const String revocationEndpoint =
      'https://oauth2.googleapis.com/revoke';

  final String clientId;
  final String redirectUri;
  final List<String> scopes;

  bool get isConfigured => clientId.trim().isNotEmpty && redirectUri.isNotEmpty;
}
