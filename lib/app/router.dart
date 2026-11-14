import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/analytics/presentation/pages/analytics_page.dart';
import '../features/cards/presentation/pages/cards_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/rewards/presentation/pages/rewards_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/statements/presentation/pages/statements_page.dart';
import '../features/transactions/presentation/pages/transactions_page.dart';
import '../shared/theme/app_motion.dart';
import 'app_shell.dart';

/// Canonical route paths. Use constants instead of string literals at call sites.
abstract final class AppRoutes {
  static const String home = '/home';
  static const String cards = '/cards';
  static const String transactions = '/transactions';
  static const String rewards = '/rewards';
  static const String settings = '/settings';
  static const String statements = '/statements';
  static const String analytics = '/analytics';
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
      GoRoute(
        path: AppRoutes.statements,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: AppMotion.effective(context, AppMotion.standard),
          reverseTransitionDuration: AppMotion.effective(
            context,
            AppMotion.standard,
          ),
          child: const StatementsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: AppMotion.curve,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.025),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) => const AnalyticsPage(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
