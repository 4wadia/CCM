import 'package:credit_card_manager/core/errors/app_failure.dart';
import 'package:credit_card_manager/integrations/gmail/android_google_auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('app.creditcardmanager/googleauth');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('uses a short-lived access token from Google Play services', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'authorize');
          return <String, Object?>{'accessToken': 'access-token'};
        });

    final service = AndroidGoogleAuthService(supported: true);
    final tokens = await service.connect();

    expect(tokens.accessToken, 'access-token');
    expect(tokens.refreshToken, isNull);
    expect(tokens.expiresAt.isAfter(DateTime.now().toUtc()), isTrue);
  });

  test('maps cancellation to a safe failure', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          throw PlatformException(code: 'cancelled', message: 'cancelled');
        });

    final service = AndroidGoogleAuthService(supported: true);

    await expectLater(
      service.connect(),
      throwsA(
        isA<AppFailure>().having(
          (failure) => failure.message,
          'message',
          contains('cancelled'),
        ),
      ),
    );
  });

  test('is not configured off Android', () {
    final service = AndroidGoogleAuthService(supported: false);
    expect(service.isConfigured, isFalse);
  });
}
