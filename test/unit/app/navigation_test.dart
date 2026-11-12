import 'package:credit_card_manager/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/test_overrides.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      testProviderScope(child: const CreditCardManagerApp()),
    );
    await tester.pumpAndSettle();
  }

  NavigationBar navigationBar(WidgetTester tester) =>
      tester.widget<NavigationBar>(find.byType(NavigationBar));

  testWidgets('starts on the home destination', (tester) async {
    await pumpApp(tester);

    expect(find.byKey(const Key('home-page')).hitTestable(), findsOneWidget);
    expect(navigationBar(tester).selectedIndex, 0);
  });

  testWidgets('reaches every top-level destination', (tester) async {
    await pumpApp(tester);

    const destinations = <(String, String, int)>[
      ('nav-cards', 'cards-page', 1),
      ('nav-transactions', 'transactions-page', 2),
      ('nav-rewards', 'rewards-page', 3),
      ('nav-settings', 'settings-page', 4),
      ('nav-home', 'home-page', 0),
    ];

    for (final (navKey, pageKey, index) in destinations) {
      await tester.tap(find.byKey(Key(navKey)));
      await tester.pumpAndSettle();

      expect(
        find.byKey(Key(pageKey)).hitTestable(),
        findsOneWidget,
        reason: '$pageKey should be visible after tapping $navKey',
      );
      expect(navigationBar(tester).selectedIndex, index);
    }
  });

  testWidgets('keeps each destination mounted across tab switches', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('nav-cards')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-home')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-cards')));
    await tester.pumpAndSettle();

    // The indexed stack keeps the branch alive; it must still be visible.
    expect(find.byKey(const Key('cards-page')).hitTestable(), findsOneWidget);
    expect(navigationBar(tester).selectedIndex, 1);
  });
}
