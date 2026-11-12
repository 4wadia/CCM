import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/card_portfolio_summary.dart';
import '../../../../domain/entities/email_account.dart';
import '../../../../domain/entities/reward.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/services/analytics.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';

class HomeDashboard {
  const HomeDashboard({
    required this.portfolio,
    required this.analytics,
    required this.recentTransactions,
    required this.cashbackByCurrency,
    required this.rewardAccounts,
    required this.emailAccount,
    required this.reviewCount,
  });

  final CardPortfolio portfolio;
  final AnalyticsSnapshot analytics;
  final List<CardTransaction> recentTransactions;
  final Map<String, int> cashbackByCurrency;
  final List<RewardAccount> rewardAccounts;
  final EmailAccount? emailAccount;
  final int reviewCount;
}

final cashbackByCurrencyProvider = FutureProvider<Map<String, int>>((
  ref,
) async {
  final repository = await ref.watch(cashbackRepositoryProvider.future);
  final entries = await repository.getAll();
  final totals = <String, int>{};
  for (final entry in entries) {
    if (entry.status.name == 'reversed') continue;
    totals[entry.currencyCode] =
        (totals[entry.currencyCode] ?? 0) + entry.amountMinor;
  }
  return totals;
});

final rewardAccountsProvider = FutureProvider<List<RewardAccount>>((ref) async {
  final repository = await ref.watch(rewardRepositoryProvider.future);
  return repository.accounts();
});

final emailAccountProvider = FutureProvider<EmailAccount?>((ref) async {
  final repository = await ref.watch(emailAccountRepositoryProvider.future);
  return repository.firstConnected();
});

final homeDashboardProvider = FutureProvider<HomeDashboard>((ref) async {
  final cards = await ref.watch(creditCardsProvider.future);
  final repository = await ref.watch(transactionRepositoryProvider.future);
  final transactions = await repository.search(limit: 1000);
  final recent = await ref.watch(recentTransactionsProvider.future);
  final cashback = await ref.watch(cashbackByCurrencyProvider.future);
  final rewards = await ref.watch(rewardAccountsProvider.future);
  final email = await ref.watch(emailAccountProvider.future);
  final reviews = await ref.watch(reviewCountProvider.future);
  return HomeDashboard(
    portfolio: CardPortfolio.fromCards(cards),
    analytics: AnalyticsService.build(transactions: transactions, cards: cards),
    recentTransactions: recent,
    cashbackByCurrency: cashback,
    rewardAccounts: rewards,
    emailAccount: email,
    reviewCount: reviews,
  );
});
