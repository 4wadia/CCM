import 'package:credit_card_manager/core/errors/app_failure.dart';
import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/integrations/gmail/oauth_service.dart';
import 'package:credit_card_manager/services/auto_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FailingOAuth implements OAuthService {
  _FailingOAuth(this.error);

  final Object error;

  @override
  bool get isConfigured => true;

  @override
  Future<OAuthTokens> connect({String? loginHint}) async {
    throw error;
  }

  @override
  Future<OAuthTokens> refresh(String? refreshToken) async {
    throw error;
  }

  @override
  Future<void> revoke(String token) async {}
}

void main() {
  test('propagates a typed Google setup failure to the UI', () async {
    final service = AutoSyncService(
      googleAuth: _FailingOAuth(
        const AppFailure(
          code: 'CCM-GMAIL-005',
          message: 'Google sign-in is not configured for this build.',
        ),
      ),
    );

    await expectLater(
      service.connectGoogleAccount(),
      throwsA(
        isA<AppFailure>()
            .having((failure) => failure.code, 'code', 'CCM-GMAIL-005')
            .having(
              (failure) => failure.message,
              'message',
              contains('not configured'),
            ),
      ),
    );
  });

  test('wraps unexpected Google failures in a user-safe AppFailure', () async {
    final service = AutoSyncService(
      googleAuth: _FailingOAuth(StateError('socket closed')),
    );

    await expectLater(
      service.connectGoogleAccount(),
      throwsA(
        isA<AppFailure>()
            .having((failure) => failure.code, 'code', 'CCM-GMAIL-011')
            .having(
              (failure) => failure.message,
              'message',
              contains('could not be completed'),
            ),
      ),
    );
  });
}
