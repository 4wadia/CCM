import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../domain/entities/card_portfolio_summary.dart';
import '../../../../domain/entities/credit_card.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/formatting/percent.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/app_progress_indicator.dart';
import '../../../../shared/widgets/card_network_badge.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../providers/home_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(homeDashboardProvider);

    return Scaffold(
      key: const Key('home-page'),
      appBar: AppBar(title: const Text('Home')),
      body: dashboard.when(
        loading: () =>
            const AppLoadingState(message: 'Loading your card overview…'),
        error: (_, _) => AppErrorState(
          message: 'Your dashboard could not be loaded.',
          onRetry: () => ref.invalidate(homeDashboardProvider),
        ),
        data: (value) => value.portfolio.isEmpty
            ? _EmptyPortfolio(onAddCard: () => context.go(AppRoutes.cards))
            : _Dashboard(dashboard: value),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final portfolio = dashboard.portfolio;
    final analytics = dashboard.analytics;
    final cardMap = <String, CreditCard>{
      for (final summary in portfolio.cards) summary.card.id: summary.card,
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        if (dashboard.reviewCount > 0) ...[
          Card(
            color: theme.colorScheme.errorContainer,
            child: ListTile(
              key: const Key('home-review-banner'),
              leading: Icon(
                Icons.rule,
                color: theme.colorScheme.onErrorContainer,
              ),
              title: Text(
                '${dashboard.reviewCount} '
                '${dashboard.reviewCount == 1 ? 'item needs' : 'items need'} '
                'review',
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
              subtitle: Text(
                'Ambiguous imports are waiting for a decision.',
                style: TextStyle(
                  color: theme.colorScheme.onErrorContainer,
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(AppRoutes.transactions),
            ),
          ),
          const SizedBox(height: 16),
        ],
        const _SectionTitle(
          title: 'Credit limits',
          subtitle: 'Active cards, shown separately by currency',
        ),
        for (final summary in portfolio.byCurrency)
          _CurrencySummaryCard(summary: summary),
        if (!portfolio.hasComparableCurrencies) ...[
          const SizedBox(height: 4),
          Text(
            'Utilisation is shown per currency because your cards use more '
            'than one currency.',
            style: theme.textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 18),
        const _SectionTitle(
          title: 'This month',
          subtitle: 'Spending by currency, never combined across currencies.',
        ),
        AppCard(
          child: analytics.currentMonth.isEmpty
              ? const Text('No spending recorded this month.')
              : Column(
                  children: [
                    for (final spending in analytics.currentMonth)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${spending.currencyCode} · '
                                '${spending.transactionCount} '
                                '${spending.transactionCount == 1 ? 'transaction' : 'transactions'}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            CurrencyText(
                              amountMinor: spending.amountMinor,
                              currencyCode: spending.currencyCode,
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
        if (analytics.upcomingPayments.isNotEmpty) ...[
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Upcoming payments',
            action: TextButton(
              onPressed: () => context.go(AppRoutes.cards),
              child: const Text('Cards'),
            ),
          ),
          for (final payment in analytics.upcomingPayments.take(3))
            AppCard(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              onTap: () => context.go(AppRoutes.cards),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    child: Icon(Icons.event_outlined, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${payment.displayName} •••• ${payment.lastFour}',
                          style: theme.textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Due ${formatShortDate(payment.dueDate)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  CurrencyText(
                    amountMinor: payment.amountMinor,
                    currencyCode: payment.currencyCode,
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 18),
        _SectionTitle(
          title: 'Recent transactions',
          action: TextButton(
            onPressed: () => context.go(AppRoutes.transactions),
            child: const Text('View all'),
          ),
        ),
        if (dashboard.recentTransactions.isEmpty)
          const AppCard(child: Text('No transactions yet.'))
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final tx in dashboard.recentTransactions.take(5))
                  TransactionTile(
                    transaction: tx,
                    card: tx.cardId == null ? null : cardMap[tx.cardId],
                    onTap: () => context.go(AppRoutes.transactions),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 18),
        _SectionTitle(
          title: 'Cashback',
          action: TextButton(
            onPressed: () => context.go(AppRoutes.rewards),
            child: const Text('Rewards'),
          ),
        ),
        AppCard(
          child: dashboard.cashbackByCurrency.isEmpty
              ? const Text('No cashback recorded yet.')
              : Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    for (final entry in dashboard.cashbackByCurrency.entries)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key, style: theme.textTheme.labelSmall),
                          CurrencyText(
                            amountMinor: entry.value,
                            currencyCode: entry.key,
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                  ],
                ),
        ),
        if (dashboard.rewardAccounts.isNotEmpty) ...[
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Reward points',
            action: TextButton(
              onPressed: () => context.go(AppRoutes.rewards),
              child: const Text('Manage'),
            ),
          ),
          AppCard(
            child: Column(
              children: [
                for (final account in dashboard.rewardAccounts)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            account.programmeName,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          '${account.currentPoints} pts',
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        const _SectionTitle(title: 'Gmail statements'),
        AppCard(
          child: Row(
            children: [
              Icon(
                dashboard.emailAccount == null
                    ? Icons.link_off
                    : Icons.mark_email_read_outlined,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dashboard.emailAccount == null
                          ? 'Not connected'
                          : dashboard.emailAccount!.emailAddress,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      dashboard.emailAccount == null
                          ? 'Connect in Settings to fetch statement emails.'
                          : 'Last sync '
                                '${formatDateTime(dashboard.emailAccount!.lastSuccessfulSync)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.settings),
                child: Text(
                  dashboard.emailAccount == null ? 'Connect' : 'Settings',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionTitle(
          title: 'Cards',
          action: TextButton(
            onPressed: () => context.go(AppRoutes.cards),
            child: const Text('Manage'),
          ),
        ),
        for (final summary in portfolio.cards)
          _CardSummaryCard(summary: summary),
        const SizedBox(height: 12),
        Text(
          'Outstanding is the reconciled balance you entered for each card. '
          'It is not derived from lifetime purchases.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.subtitle, this.action});

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

class _CurrencySummaryCard extends StatelessWidget {
  const _CurrencySummaryCard({required this.summary});

  final CardPortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final utilisation = summary.utilisationPercent;

    return AppCard(
      key: Key('currency-summary-${summary.currencyCode}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  summary.currencyCode,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                '${summary.cardCount} '
                '${summary.cardCount == 1 ? 'active card' : 'active cards'}',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _AmountRow(
            key: Key('limit-${summary.currencyCode}'),
            label: 'Total limit',
            amountMinor: summary.creditLimitMinor,
            currencyCode: summary.currencyCode,
          ),
          _AmountRow(
            key: Key('outstanding-${summary.currencyCode}'),
            label: 'Outstanding',
            amountMinor: summary.outstandingMinor,
            currencyCode: summary.currencyCode,
          ),
          _AmountRow(
            key: Key('available-${summary.currencyCode}'),
            label: 'Available credit',
            amountMinor: summary.availableCreditMinor,
            currencyCode: summary.currencyCode,
          ),
          const SizedBox(height: 10),
          if (utilisation == null)
            Text(
              'Utilisation unavailable (zero limit)',
              style: theme.textTheme.labelSmall,
            )
          else
            AppProgressIndicator(
              value: utilisation / 100,
              label: 'Utilisation ${formatPercent(utilisation)}',
              showLabel: true,
            ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    super.key,
    required this.label,
    required this.amountMinor,
    required this.currencyCode,
  });

  final String label;
  final int amountMinor;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          CurrencyText(
            amountMinor: amountMinor,
            currencyCode: currencyCode,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _CardSummaryCard extends StatelessWidget {
  const _CardSummaryCard({required this.summary});

  final CardSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = summary.card;
    final utilisation = summary.utilisationPercent;

    return AppCard(
      key: Key('card-summary-${card.id}'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CardNetworkBadge(network: card.network, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.displayName,
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '•••• ${card.lastFour}',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Text(
                utilisation == null ? '—' : formatPercent(utilisation),
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CompactAmount(
                  label: 'Limit',
                  amountMinor: summary.creditLimitMinor,
                  currencyCode: card.currencyCode,
                ),
              ),
              Expanded(
                child: _CompactAmount(
                  label: 'Outstanding',
                  amountMinor: summary.outstandingMinor,
                  currencyCode: card.currencyCode,
                ),
              ),
              Expanded(
                child: _CompactAmount(
                  label: 'Available',
                  amountMinor: summary.availableCreditMinor,
                  currencyCode: card.currencyCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactAmount extends StatelessWidget {
  const _CompactAmount({
    required this.label,
    required this.amountMinor,
    required this.currencyCode,
  });

  final String label;
  final int amountMinor;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        CurrencyText(
          amountMinor: amountMinor,
          currencyCode: currencyCode,
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _EmptyPortfolio extends StatelessWidget {
  const _EmptyPortfolio({required this.onAddCard});

  final VoidCallback onAddCard;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      key: const Key('home-empty'),
      icon: Icons.dashboard_outlined,
      title: 'Your cards, in one place',
      subtitle:
          'Add a card to see your credit limit, outstanding balance, and '
          'available credit.',
      actionLabel: 'View cards',
      onAction: onAddCard,
    );
  }
}
