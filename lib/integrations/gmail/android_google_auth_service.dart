import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../domain/entities/email_account.dart';
import 'gmail_config.dart';
import 'oauth_service.dart';

/// Android authorization through Google Play services.
///
/// Google no longer accepts custom URI redirect schemes on Android. The
/// platform `AuthorizationClient` shows the consent screen and returns a
/// short-lived access token without putting a client secret or refresh token in
/// the app. An Android OAuth client must exist for this package and signing
/// certificate, and the Gmail API must be enabled in that Google Cloud project.
class AndroidGoogleAuthService implements OAuthService {
  AndroidGoogleAuthService({
    this._channel = const MethodChannel('app.creditcardmanager/googleauth'),
    bool? supported,
    http.Client? httpClient,
  }) : _supported = supported ?? Platform.isAndroid,
       _http = httpClient ?? http.Client();

  final MethodChannel _channel;
  final bool _supported;
  final http.Client _http;

  @override
  bool get isConfigured => _supported;

  @override
  Future<OAuthTokens> connect({String? loginHint}) async {
    if (!_supported) {
      throw const AppFailure(
        code: 'CCM-GMAIL-001',
        message: 'Gmail authorization is available only on Android.',
      );
    }
    try {
      final response = await _channel.invokeMapMethod<String, Object?>(
        'authorize',
      );
      final accessToken = response?['accessToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        throw const AppFailure(
          code: 'CCM-GMAIL-008',
          message:
              'Google did not return an access token. Try connecting again.',
        );
      }
      return OAuthTokens(
        accessToken: accessToken,
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 55)),
        scopes: GmailConfig.defaultScopes,
      );
    } on PlatformException catch (error) {
      throw AppFailure(
        code: 'CCM-GMAIL-005',
        message: _messageFor(error),
        cause: error,
      );
    }
  }

  @override
  Future<OAuthTokens> refresh(String? refreshToken) => connect();

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

  String _messageFor(PlatformException error) {
    final platformMessage = error.message?.trim();
    return switch (error.code) {
      'cancelled' => 'Gmail connection was cancelled.',
      'in_progress' => 'Gmail authorization is already in progress.',
      'no_token' =>
        'Google did not return an access token. Try connecting again.',
      'scope_denied' =>
        platformMessage?.isNotEmpty == true
            ? platformMessage!
            : 'Gmail read access was not granted. Enable the Gmail API and '
                  'approve the Gmail read-only scope during sign-in.',
      _ =>
        platformMessage?.isNotEmpty == true
            ? platformMessage!
            : 'Gmail could not be connected. Create an Android OAuth client for '
                  'package app.creditcardmanager with this app\'s signing SHA-1, '
                  'enable the Gmail API, and add your Google account as a test '
                  'user. Open Google sign-in setup help for details.',
    };
  }
}
