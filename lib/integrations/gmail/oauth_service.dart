// ignore_for_file: prefer_initializing_formals
import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../domain/entities/email_account.dart';
import 'gmail_config.dart';

abstract interface class OAuthService {
  bool get isConfigured;

  Future<OAuthTokens> connect({String? loginHint});

  Future<OAuthTokens> refresh(String refreshToken);

  Future<void> revoke(String token);
}

/// Native Authorization Code + PKCE. No client secret is present in the app.
class GoogleOAuthService implements OAuthService {
  GoogleOAuthService({
    required this.config,
    FlutterAppAuth appAuth = const FlutterAppAuth(),
    http.Client? httpClient,
  }) : _appAuth = appAuth,
       _http = httpClient ?? http.Client();

  final GmailConfig config;
  final FlutterAppAuth _appAuth;
  final http.Client _http;

  static const AuthorizationServiceConfiguration _serviceConfiguration =
      AuthorizationServiceConfiguration(
        authorizationEndpoint: GmailConfig.authorizationEndpoint,
        tokenEndpoint: GmailConfig.tokenEndpoint,
      );

  @override
  bool get isConfigured => config.isConfigured;

  @override
  Future<OAuthTokens> connect({String? loginHint}) async {
    _requireConfigured();
    try {
      final response = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          config.clientId,
          config.redirectUri,
          scopes: config.scopes,
          serviceConfiguration: _serviceConfiguration,
          loginHint: loginHint,
          promptValues: <String>[Prompt.consent, Prompt.selectAccount],
          allowInsecureConnections: false,
        ),
      );
      return _tokensFromResponse(response, previousRefreshToken: null);
    } on FlutterAppAuthUserCancelledException {
      throw const AppFailure(
        code: 'CCM-GMAIL-004',
        message: 'Gmail connection was cancelled.',
      );
    } on FlutterAppAuthPlatformException catch (error) {
      throw AppFailure(
        code: 'CCM-GMAIL-005',
        message: 'Gmail could not be connected. Check the OAuth setup.',
        cause: error,
      );
    }
  }

  @override
  Future<OAuthTokens> refresh(String refreshToken) async {
    _requireConfigured();
    try {
      final response = await _appAuth.token(
        TokenRequest(
          config.clientId,
          config.redirectUri,
          scopes: config.scopes,
          serviceConfiguration: _serviceConfiguration,
          refreshToken: refreshToken,
          grantType: GrantType.refreshToken,
          allowInsecureConnections: false,
        ),
      );
      return _tokensFromResponse(response, previousRefreshToken: refreshToken);
    } on FlutterAppAuthPlatformException catch (error) {
      throw AppFailure(
        code: 'CCM-GMAIL-006',
        message: 'Gmail access expired. Reconnect the account.',
        cause: error,
      );
    }
  }

  @override
  Future<void> revoke(String token) async {
    try {
      await _http.post(
        Uri.parse(GmailConfig.revocationEndpoint),
        headers: const <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{'token': token},
      );
    } catch (error) {
      throw AppFailure(
        code: 'CCM-GMAIL-007',
        message:
            'The Gmail account could not be revoked remotely. '
            'Local tokens were still removed.',
        cause: error,
      );
    }
  }

  OAuthTokens _tokensFromResponse(
    TokenResponse response, {
    required String? previousRefreshToken,
  }) {
    final access = response.accessToken;
    final refresh = response.refreshToken ?? previousRefreshToken;
    if (access == null || refresh == null) {
      throw const AppFailure(
        code: 'CCM-GMAIL-008',
        message: 'Gmail returned an incomplete authorization response.',
      );
    }
    return OAuthTokens(
      accessToken: access,
      refreshToken: refresh,
      expiresAt:
          response.accessTokenExpirationDateTime ??
          DateTime.now().add(const Duration(hours: 1)),
      emailAddress: _emailFromIdToken(response.idToken),
      scopes: response.scopes ?? config.scopes,
    );
  }

  String? _emailFromIdToken(String? idToken) {
    if (idToken == null) return null;
    final parts = idToken.split('.');
    if (parts.length < 2) return null;
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload is Map<String, Object?>
          ? payload['email'] as String?
          : null;
    } on FormatException {
      return null;
    }
  }

  void _requireConfigured() {
    if (!isConfigured) {
      throw const AppFailure(
        code: 'CCM-GMAIL-001',
        message:
            'Gmail is not configured in this build. Add GMAIL_CLIENT_ID and '
            'GMAIL_REDIRECT_URI at build time.',
      );
    }
  }
}
