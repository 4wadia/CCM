import 'package:credit_card_manager/app/router.dart';
import 'package:credit_card_manager/core/errors/app_failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('router provider', () {
    test('creates a router', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(appRouterProvider), isA<GoRouter>());
    });
  });

  group('AppFailure', () {
    test('keeps the diagnostic cause out of its string form', () {
      const failure = AppFailure(
        code: 'CCM-SMS-001',
        message: 'SMS access is not available on this device.',
        cause: 'sensitive diagnostic payload',
      );

      expect(failure.toString(), 'AppFailure(CCM-SMS-001)');
      expect(failure.toString(), isNot(contains('sensitive')));
      expect(failure.message, isNot(contains('sensitive')));
    });
  });
}
