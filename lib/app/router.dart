import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/cards/presentation/pages/cards_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/rewards/presentation/pages/rewards_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/transactions/presentation/pages/transactions_page.dart';
import 'app_shell.dart';

/// Canonical route paths. Use constants instead of string literals at call sites.
abstract final class AppRoutes {
  static const String home = '/home';
  static const String cards = '/cards';
  static const String transactions = '/transactions';
  static const String rewards = '/rewards';
  static const String settings = '/settings';
}

/// Router owned by Riverpod so tests and features can override navigation.
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cards,
                builder: (context, state) => const CardsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.rewards,
                builder: (context, state) => const RewardsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
