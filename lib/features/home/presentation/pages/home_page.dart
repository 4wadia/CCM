import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../domain/entities/card_portfolio_summary.dart';
import '../../../../shared/formatting/percent.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/app_progress_indicator.dart';
import '../../../../shared/widgets/card_network_badge.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../../../cards/presentation/providers/card_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(cardPortfolioProvider);

    return Scaffold(
      key: const Key('home-page'),
      appBar: AppBar(title: const Text('Home')),
      body: portfolio.when(
        loading: () =>
            const AppLoadingState(message: 'Loading your card overview…'),
        error: (_, _) => AppErrorState(
          message: 'Your card summary could not be loaded.',
          onRetry: () => ref.invalidate(cardPortfolioProvider),
        ),
        data: (value) => value.isEmpty
            ? _EmptyPortfolio(onAddCard: () => context.go(AppRoutes.cards))
            : _Dashboard(portfolio: value),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.portfolio});

  final CardPortfolio portfolio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text('Credit limits', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Active cards, shown separately by currency',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 20),
        Text('Cards', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final summary in portfolio.cards)
          _CardSummaryCard(summary: summary),
        const SizedBox(height: 16),
        Text(
          'Outstanding is the reconciled balance you entered for each card. '
          'Transaction-derived balances arrive in a later milestone.',
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
