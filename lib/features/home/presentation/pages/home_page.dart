import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router.dart';
import '../../../../domain/entities/card_portfolio_summary.dart';
import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/email_account.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/formatting/percent.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/app_progress_indicator.dart';
import '../../../../shared/widgets/card_network_badge.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../providers/home_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(homeDashboardProvider);

    return Scaffold(
      key: const Key('home-page'),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Spending Analytics',
            onPressed: () => context.push(AppRoutes.analytics),
            icon: const Icon(Icons.insights_rounded),
          ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        12,
        AppSpacing.pageHorizontal,
        40,
      ),
      children: [
        if (dashboard.reviewCount > 0) ...[
          _ReviewBanner(
            key: const Key('home-review-banner'),
            count: dashboard.reviewCount,
            onTap: () => context.go(AppRoutes.transactions),
          ),
          const SizedBox(height: 16),
        ],

        _HomeGmailCard(account: dashboard.emailAccount),
        const SizedBox(height: 20),

        // Portfolio Hero: Combined Credit Limits & Balances.
        const SectionHeader(
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
          const SizedBox(height: 12),
        ],

        const SizedBox(height: 16),

        // This Month / Spending Overview.
        const SectionHeader(
          title: 'This month',
          subtitle: 'Spending by currency, never combined across currencies.',
        ),
        AppCard(
          padding: const EdgeInsets.all(18),
          child: analytics.currentMonth.isEmpty
              ? Text(
                  'No spending recorded this month.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
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
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),

        if (analytics.upcomingPayments.isNotEmpty) ...[
          const SizedBox(height: 20),
          SectionHeader(
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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.event_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
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
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],

        const SizedBox(height: 20),

        // Recent Transactions Section.
        SectionHeader(
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

        const SizedBox(height: 20),

        // Cashback Section.
        SectionHeader(
          title: 'Cashback',
          action: TextButton(
            onPressed: () => context.go(AppRoutes.rewards),
            child: const Text('Rewards'),
          ),
        ),
        AppCard(
          padding: const EdgeInsets.all(18),
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
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
        ),

        if (dashboard.rewardAccounts.isNotEmpty) ...[
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Reward points',
            action: TextButton(
              onPressed: () => context.go(AppRoutes.rewards),
              child: const Text('Manage'),
            ),
          ),
          AppCard(
            padding: const EdgeInsets.all(16),
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
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Cards Section.
        SectionHeader(
          title: 'Cards',
          action: TextButton(
            onPressed: () => context.go(AppRoutes.cards),
            child: const Text('Manage'),
          ),
        ),
        for (final summary in portfolio.cards)
          _CardSummaryCard(summary: summary),
        const SizedBox(height: 8),
        Text(
          'Outstanding is the reconciled balance you entered for each card. '
          'It is not derived from lifetime purchases.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _CurrencySummaryCard extends StatelessWidget {
  const _CurrencySummaryCard({required this.summary});

  final CardPortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final utilisation = summary.utilisationPercent;

    return AppCard(
      key: Key('currency-summary-${summary.currencyCode}'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkPrimaryContainer
                      : AppColors.primaryContainer,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  summary.currencyCode,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surfaceVariant,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  '${summary.cardCount} '
                  '${summary.cardCount == 1 ? 'active card' : 'active cards'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            key: Key('available-${summary.currencyCode}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available credit',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                CurrencyText(
                  amountMinor: summary.availableCreditMinor,
                  currencyCode: summary.currencyCode,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    key: Key('limit-${summary.currencyCode}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total limit',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 1),
                        CurrencyText(
                          amountMinor: summary.creditLimitMinor,
                          currencyCode: summary.currencyCode,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                Expanded(
                  child: Container(
                    key: Key('outstanding-${summary.currencyCode}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Outstanding',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 1),
                        CurrencyText(
                          amountMinor: summary.outstandingMinor,
                          currencyCode: summary.currencyCode,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (utilisation == null)
            Text(
              'Utilisation unavailable (zero limit)',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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

class _CardSummaryCard extends StatelessWidget {
  const _CardSummaryCard({required this.summary});

  final CardSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final card = summary.card;
    final utilisation = summary.utilisationPercent;

    return AppCard(
      key: Key('card-summary-${card.id}'),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      onTap: () => context.go(AppRoutes.cards),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CardNetworkBadge(network: card.network, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.displayName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '•••• ${card.lastFour}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: utilisation == null
                      ? (isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.surfaceVariant)
                      : (utilisation > 90
                            ? theme.colorScheme.errorContainer
                            : (utilisation > 75
                                  ? (isDark
                                        ? AppColors.darkWarning.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.warning.withValues(
                                            alpha: 0.15,
                                          ))
                                  : (isDark
                                        ? AppColors.darkPrimaryContainer
                                        : AppColors.primaryContainer))),
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  utilisation == null ? '—' : formatPercent(utilisation),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: utilisation == null
                        ? theme.colorScheme.onSurfaceVariant
                        : (utilisation > 90
                              ? theme.colorScheme.error
                              : (utilisation > 75
                                    ? (isDark
                                          ? AppColors.darkWarning
                                          : AppColors.warning)
                                    : theme.colorScheme.primary)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
        const SizedBox(height: 2),
        CurrencyText(
          amountMinor: amountMinor,
          currencyCode: currencyCode,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ReviewBanner extends StatelessWidget {
  const _ReviewBanner({super.key, required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark
          ? AppColors.darkWarning.withValues(alpha: 0.12)
          : const Color(0xFFFEF3C7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark
              ? AppColors.darkWarning.withValues(alpha: 0.3)
              : const Color(0xFFFDE68A),
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkWarning.withValues(alpha: 0.2)
                : const Color(0xFFFDE68A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.rule,
            color: isDark ? AppColors.darkWarning : const Color(0xFF92400E),
            size: 20,
          ),
        ),
        title: Text(
          '$count ${count == 1 ? 'item needs' : 'items need'} review',
          style: TextStyle(
            color: isDark ? AppColors.darkWarning : const Color(0xFF92400E),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          'Ambiguous imports are waiting for a decision.',
          style: TextStyle(
            color: isDark
                ? AppColors.darkWarning.withValues(alpha: 0.8)
                : const Color(0xFFB45309),
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? AppColors.darkWarning : const Color(0xFF92400E),
          size: 20,
        ),
        onTap: onTap,
      ),
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

class _HomeGmailCard extends StatelessWidget {
  const _HomeGmailCard({required this.account});

  final EmailAccount? account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connected = account != null;
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  connected
                      ? Icons.mark_email_read_outlined
                      : Icons.mark_email_unread_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connected ? 'Connected Gmail' : 'Gmail statements',
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      connected ? account!.emailAddress : 'No email connected',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            connected
                ? 'Credit-card statements only'
                      '${account!.lastSuccessfulSync == null ? '' : ' · Last sync ${formatDateTime(account!.lastSuccessfulSync)}'}'
                : 'Connect Gmail to import credit-card statements only.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (connected)
                TextButton.icon(
                  onPressed: () => context.push(AppRoutes.statements),
                  icon: const Icon(Icons.menu_book_outlined, size: 18),
                  label: const Text('Read statements'),
                )
              else
                FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.settings),
                  icon: const Icon(Icons.link, size: 18),
                  label: const Text('Connect Gmail'),
                ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(AppRoutes.settings),
                child: Text(connected ? 'Manage' : 'Account'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
