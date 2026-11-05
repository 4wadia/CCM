import 'dart:convert';

import 'package:credit_card_manager/core/secure_storage/database_key_provider.dart';
import 'package:credit_card_manager/integrations/platform/secure_key_store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('app.creditcardmanager/security');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('decodes a valid 32-byte key from the native side', () async {
    final rawKey = List<int>.generate(32, (index) => index);
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'getOrCreateDatabaseKey');
      return base64Encode(rawKey);
    });

    final key = await const SecureKeyStore(channel: channel)
        .getOrCreateDatabaseKey();

    expect(key, orderedEquals(rawKey));
    expect(key, hasLength(32));
  });

  test('rejects a key of the wrong length', () async {
    messenger.setMockMethodCallHandler(
      channel,
      (call) async => base64Encode(List<int>.filled(16, 1)),
    );

    await expectLater(
      const SecureKeyStore(channel: channel).getOrCreateDatabaseKey(),
      throwsA(isA<DatabaseKeyUnavailableException>()),
    );
  });

  test('rejects a null or malformed response', () async {
    messenger.setMockMethodCallHandler(channel, (call) async => null);
    await expectLater(
      const SecureKeyStore(channel: channel).getOrCreateDatabaseKey(),
      throwsA(isA<DatabaseKeyUnavailableException>()),
    );

    messenger.setMockMethodCallHandler(channel, (call) async => 'not base64!!');
    await expectLater(
      const SecureKeyStore(channel: channel).getOrCreateDatabaseKey(),
      throwsA(isA<DatabaseKeyUnavailableException>()),
    );
  });

  test('maps platform failures to a typed exception', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'KEYSTORE_ERROR');
    });

    await expectLater(
      const SecureKeyStore(channel: channel).getOrCreateDatabaseKey(),
      throwsA(isA<DatabaseKeyUnavailableException>()),
    );
  });

  test('forwards deletion to the native side', () async {
    var deleted = false;
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'deleteDatabaseKey');
      deleted = true;
      return null;
    });

    await const SecureKeyStore(channel: channel).deleteDatabaseKey();

    expect(deleted, isTrue);
  });
}
