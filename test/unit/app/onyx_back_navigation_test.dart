import 'dart:ui';

import 'package:credit_card_manager/main.dart';
import 'package:credit_card_manager/widgets/physical_credit_card.dart';
import 'package:flutter/material.dart';
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

  testWidgets('back returns to the previously visited tab', (tester) async {
    await openDashboard(tester);

    await tester.tap(find.text('Cards').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Your Cards'), findsOneWidget);
    expect(find.text('TOTAL MONTH SPEND'), findsNothing);
  });

  testWidgets('adding a card closes the form and shows the new card', (
    tester,
  ) async {
    await openDashboard(tester);

    await tester.tap(find.text('Cards').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Card'));
    await tester.pumpAndSettle();

    expect(find.text('Issue Card'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), '1234');
    await tester.enterText(find.byType(TextFormField).at(1), 'TEST USER');
    await tester.enterText(find.byType(TextFormField).at(2), '100000');
    await tester.ensureVisible(find.text('Issue Instrument'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Issue Instrument'));
    await tester.pumpAndSettle();

    expect(find.text('Issue Card'), findsNothing);
    expect(find.text('AUTO-SYNC IN PROGRESS'), findsNothing);
    expect(find.byType(PhysicalCreditCard), findsOneWidget);

    await tester.tap(find.byType(PhysicalCreditCard));
    await tester.pumpAndSettle();
    expect(find.text('Manage Card'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Your Cards'), findsOneWidget);
    expect(find.text('Manage Card'), findsNothing);
  });
}
