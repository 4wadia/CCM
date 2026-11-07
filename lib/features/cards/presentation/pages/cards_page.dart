import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/bank.dart';
import '../../../../domain/entities/card_portfolio_summary.dart';
import '../../../../domain/entities/credit_card.dart';
import '../../../../shared/formatting/percent.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/card_network_badge.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../providers/card_providers.dart';
import '../widgets/card_editor_sheet.dart';

class CardsPage extends ConsumerWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(creditCardsProvider);
    final banks = ref.watch(knownBanksProvider);

    return Scaffold(
      key: const Key('cards-page'),
      appBar: AppBar(
        title: const Text('Cards'),
        actions: [
          IconButton(
            key: const Key('add-card'),
            tooltip: 'Add card',
            onPressed: () => _editCard(context, ref),
            icon: const Icon(Icons.add_card),
          ),
        ],
      ),
      body: cards.when(
        loading: () => const AppLoadingState(message: 'Loading cards…'),
        error: (_, _) => AppErrorState(
          message: 'Cards could not be loaded.',
          onRetry: () {
            ref.invalidate(creditCardsProvider);
            ref.invalidate(knownBanksProvider);
          },
        ),
        data: (items) => banks.when(
          loading: () => const AppLoadingState(message: 'Loading issuers…'),
          error: (_, _) => AppErrorState(
            message: 'Issuers could not be loaded.',
            onRetry: () => ref.invalidate(knownBanksProvider),
          ),
          data: (knownBanks) => _CardList(
            cards: items,
            banks: {for (final bank in knownBanks) bank.id: bank},
            onAdd: () => _editCard(context, ref),
            onEdit: (card) => _editCard(context, ref, card: card),
            onArchive: (card) => _confirmArchive(context, ref, card),
            onRestore: (card) =>
                _setStatus(context, ref, card, CardStatus.active),
            onClose: (card) => _confirmClose(context, ref, card),
          ),
        ),
      ),
    );
  }

  Future<void> _editCard(
    BuildContext context,
    WidgetRef ref, {
    CreditCard? card,
  }) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => CardEditorSheet(card: card),
    );
    if (saved == true) {
      ref.invalidate(creditCardsProvider);
      ref.invalidate(knownBanksProvider);
    }
  }

  Future<void> _setStatus(
    BuildContext context,
    WidgetRef ref,
    CreditCard card,
    CardStatus status,
  ) async {
    try {
      final repository = await ref.read(creditCardRepositoryProvider.future);
      switch (status) {
        case CardStatus.active:
          await repository.restore(card.id);
        case CardStatus.archived:
          await repository.archive(card.id);
        case CardStatus.closed:
          await repository.close(card.id);
      }
      ref.invalidate(creditCardsProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The card could not be updated.')),
        );
      }
    }
  }

  Future<void> _confirmArchive(
    BuildContext context,
    WidgetRef ref,
    CreditCard card,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive this card?'),
        content: const Text(
          'The card will be hidden from your active overview. Its history '
          'stays on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirm-archive'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await _setStatus(context, ref, card, CardStatus.archived);
    }
  }

  Future<void> _confirmClose(
    BuildContext context,
    WidgetRef ref,
    CreditCard card,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close this card?'),
        content: const Text(
          'The card and its history will remain on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirm-close'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Close card'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await _setStatus(context, ref, card, CardStatus.closed);
    }
  }
}

class _CardList extends StatelessWidget {
  const _CardList({
    required this.cards,
    required this.banks,
    required this.onAdd,
    required this.onEdit,
    required this.onArchive,
    required this.onRestore,
    required this.onClose,
  });

  final List<CreditCard> cards;
  final Map<String, Bank> banks;
  final VoidCallback onAdd;
  final ValueChanged<CreditCard> onEdit;
  final ValueChanged<CreditCard> onArchive;
  final ValueChanged<CreditCard> onRestore;
  final ValueChanged<CreditCard> onClose;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return AppEmptyState(
        icon: Icons.credit_card_outlined,
        title: 'No cards yet',
        subtitle: 'Add a card to start tracking its credit limit and balance.',
        actionLabel: 'Add card',
        onAction: onAdd,
        actionKey: const Key('empty-add-card'),
      );
    }

    final active = cards.where((card) => card.status == CardStatus.active);
    final inactive = cards.where((card) => !card.isActive);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (active.isNotEmpty) ...[
          _SectionHeading(title: 'Active', count: active.length),
          for (final card in active)
            _CardTile(
              card: card,
              bankName: banks[card.bankId]?.displayName ?? 'Issuer',
              onEdit: () => onEdit(card),
              onArchive: () => onArchive(card),
              onClose: () => onClose(card),
            ),
        ],
        if (inactive.isNotEmpty) ...[
          _SectionHeading(title: 'Archived and closed', count: inactive.length),
          for (final card in inactive)
            _CardTile(
              card: card,
              bankName: banks[card.bankId]?.displayName ?? 'Issuer',
              onRestore: card.status == CardStatus.archived
                  ? () => onRestore(card)
                  : null,
            ),
        ],
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 8),
          Text('$count', style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.card,
    required this.bankName,
    this.onEdit,
    this.onArchive,
    this.onRestore,
    this.onClose,
  });

  final CreditCard card;
  final String bankName;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onRestore;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = CardSummary(card);
    final actions = <PopupMenuEntry<String>>[];
    if (onEdit != null) {
      actions.add(const PopupMenuItem(value: 'edit', child: Text('Edit')));
    }
    if (onArchive != null) {
      actions.add(
        const PopupMenuItem(value: 'archive', child: Text('Archive')),
      );
    }
    if (onRestore != null) {
      actions.add(
        const PopupMenuItem(value: 'restore', child: Text('Restore')),
      );
    }
    if (onClose != null) {
      actions.add(
        const PopupMenuItem(value: 'close', child: Text('Close card')),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardNetworkBadge(network: card.network),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.displayName,
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$bankName  •••• ${card.lastFour}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _statusLabel(card.status),
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                if (actions.isNotEmpty)
                  PopupMenuButton<String>(
                    tooltip: 'Card actions',
                    onSelected: (action) {
                      switch (action) {
                        case 'edit':
                          onEdit?.call();
                        case 'archive':
                          onArchive?.call();
                        case 'restore':
                          onRestore?.call();
                        case 'close':
                          onClose?.call();
                      }
                    },
                    itemBuilder: (context) => actions,
                  ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'Limit',
                    amountMinor: summary.creditLimitMinor,
                    currencyCode: card.currencyCode,
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'Outstanding',
                    amountMinor: summary.outstandingMinor,
                    currencyCode: card.currencyCode,
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'Available',
                    amountMinor: summary.availableCreditMinor,
                    currencyCode: card.currencyCode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              summary.utilisationPercent == null
                  ? 'Utilisation unavailable (zero limit)'
                  : 'Utilisation ${formatPercent(summary.utilisationPercent!)}',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(CardStatus status) {
    return switch (status) {
      CardStatus.active => 'Active',
      CardStatus.archived => 'Archived',
      CardStatus.closed => 'Closed',
    };
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
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
          style: theme.textTheme.labelLarge,
        ),
      ],
    );
  }
}
