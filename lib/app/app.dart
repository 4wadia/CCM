import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

/// Root application widget.
///
/// Visual design is a separate workstream. M0 intentionally uses Material 3
/// defaults; themes and design tokens are introduced with the design hand-off.
class CreditCardManagerApp extends ConsumerWidget {
  const CreditCardManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Credit Card Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F5C99)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F5C99),
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: router,
    );
  }
}
