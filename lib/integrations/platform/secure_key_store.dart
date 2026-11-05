import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/secure_storage/database_key_provider.dart';
import '../../core/security/key_encoding.dart';

/// Database key backed by Android Keystore or the iOS Keychain.
///
/// The native side owns generation and wrapping. Dart receives the unwrapped key
/// only for the duration of opening the database.
class SecureKeyStore implements DatabaseKeyProvider {
  const SecureKeyStore({this.channel = _defaultChannel});

  static const MethodChannel _defaultChannel = MethodChannel(
    'app.creditcardmanager/security',
  );

  final MethodChannel channel;

  @override
  Future<Uint8List> getOrCreateDatabaseKey() async {
    final String? encoded;
    try {
      encoded = await channel.invokeMethod<String>('getOrCreateDatabaseKey');
    } on PlatformException catch (error) {
      throw DatabaseKeyUnavailableException(cause: error);
    } on MissingPluginException catch (error) {
      throw DatabaseKeyUnavailableException(cause: error);
    }

    if (encoded == null) {
      throw const DatabaseKeyUnavailableException(
        cause: 'Native key store returned no key',
      );
    }

    final Uint8List key;
    try {
      key = base64Decode(encoded);
    } on FormatException catch (error) {
      throw DatabaseKeyUnavailableException(cause: error);
    }

    if (key.length != databaseKeyLength) {
      key.fillRange(0, key.length, 0);
      throw const DatabaseKeyUnavailableException(
        cause: 'Native key store returned a key of the wrong length',
      );
    }

    return key;
  }

  @override
  Future<void> deleteDatabaseKey() async {
    try {
      await channel.invokeMethod<void>('deleteDatabaseKey');
    } on PlatformException catch (error) {
      throw DatabaseKeyUnavailableException(cause: error);
    } on MissingPluginException catch (error) {
      throw DatabaseKeyUnavailableException(cause: error);
    }
  }
}
