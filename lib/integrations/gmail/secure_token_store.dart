import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/email_account.dart';

/// OAuth tokens are stored only in Android Keystore-backed secure storage or
/// the iOS Keychain. The database stores an opaque reference, never a token.
abstract interface class SecureTokenStore {
  Future<OAuthTokens?> read(String reference);

  Future<void> write(String reference, OAuthTokens tokens);

  Future<void> delete(String reference);
}

class FlutterSecureTokenStore implements SecureTokenStore {
  const FlutterSecureTokenStore({
    this.storage = const FlutterSecureStorage(),
    this.keyPrefix = 'ccm.gmail.',
  });

  final FlutterSecureStorage storage;
  final String keyPrefix;

  @override
  Future<OAuthTokens?> read(String reference) async {
    final raw = await storage.read(key: '$keyPrefix$reference');
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, Object?>;
      final access = json['access'] as String?;
      final refresh = json['refresh'] as String?;
      final expires = json['expires'] as String?;
      if (access == null || refresh == null || expires == null) return null;
      return OAuthTokens(
        accessToken: access,
        refreshToken: refresh,
        expiresAt: DateTime.parse(expires),
        emailAddress: json['email'] as String?,
        scopes: (json['scopes'] as List<Object?>? ?? const <Object?>[])
            .whereType<String>()
            .toList(growable: false),
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  @override
  Future<void> write(String reference, OAuthTokens tokens) async {
    final raw = jsonEncode(<String, Object?>{
      'access': tokens.accessToken,
      'refresh': tokens.refreshToken,
      'expires': tokens.expiresAt.toUtc().toIso8601String(),
      'email': tokens.emailAddress,
      'scopes': tokens.scopes,
    });
    await storage.write(key: '$keyPrefix$reference', value: raw);
  }

  @override
  Future<void> delete(String reference) async {
    await storage.delete(key: '$keyPrefix$reference');
  }
}
