import 'dart:ui';

import 'package:credit_card_manager/main.dart';
import 'package:flutter/widgets.dart' show Navigator;
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> openDashboard(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 892));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const OnyxCardsApp());
    await tester.pumpAndSettle();

    final onboarding = find.text('Setup Smart Sync');
    if (onboarding.evaluate().isNotEmpty) {
      // The first-run sheet can be taller than a phone viewport. Dismiss it
      // directly so the test can exercise the underlying dashboard.
      Navigator.of(tester.element(onboarding)).pop();
      await tester.pumpAndSettle();
    }
  }

  testWidgets('system back returns to Home from Cards', (tester) async {
    await openDashboard(tester);

    await tester.tap(find.text('Cards').last);
    await tester.pumpAndSettle();
    expect(find.text('Your Cards'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('TOTAL MONTH SPEND'), findsOneWidget);
    expect(find.text('Your Cards'), findsNothing);
  });

  testWidgets('system back returns to Home from Profile', (tester) async {
    await openDashboard(tester);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('TOTAL MONTH SPEND'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('TOTAL MONTH SPEND'), findsOneWidget);
  });
}
