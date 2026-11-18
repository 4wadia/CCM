import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../domain/entities/bank.dart';
import '../../../../domain/entities/card_portfolio_summary.dart';
import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/formatting/percent.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/card_network_badge.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../rewards/presentation/providers/reward_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
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
          data: (knownBanks) {
            final bankMap = {for (final bank in knownBanks) bank.id: bank};
            return _CardList(
              cards: items,
              banks: bankMap,
              onAdd: () => _editCard(context, ref),
              onOpen: (card) => _openCard(
                context,
                ref,
                card,
                bankMap[card.bankId]?.displayName ?? 'Issuer',
              ),
              onEdit: (card) => _editCard(context, ref, card: card),
              onArchive: (card) => _confirmArchive(context, ref, card),
              onRestore: (card) =>
                  _setStatus(context, ref, card, CardStatus.active),
              onClose: (card) => _confirmClose(context, ref, card),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openCard(
    BuildContext context,
    WidgetRef ref,
    CreditCard card,
    String bankName,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CardDetailSheet(card: card, bankName: bankName),
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
    required this.onOpen,
    required this.onEdit,
    required this.onArchive,
    required this.onRestore,
    required this.onClose,
  });

  final List<CreditCard> cards;
  final Map<String, Bank> banks;
  final VoidCallback onAdd;
  final ValueChanged<CreditCard> onOpen;
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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        12,
        AppSpacing.pageHorizontal,
        32,
      ),
      children: [
        if (active.isNotEmpty) ...[
          SectionHeader(title: 'Active', count: active.length),
          for (final card in active)
            _CardTile(
              card: card,
              bankName: banks[card.bankId]?.displayName ?? 'Issuer',
              onOpen: () => onOpen(card),
              onEdit: () => onEdit(card),
              onArchive: () => onArchive(card),
              onClose: () => onClose(card),
            ),
        ],
        if (inactive.isNotEmpty) ...[
          const SizedBox(height: 16),
          SectionHeader(title: 'Archived and closed', count: inactive.length),
          for (final card in inactive)
            _CardTile(
              card: card,
              bankName: banks[card.bankId]?.displayName ?? 'Issuer',
              onOpen: () => onOpen(card),
              onRestore: card.status == CardStatus.archived
                  ? () => onRestore(card)
                  : null,
            ),
        ],
      ],
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.card,
    required this.bankName,
    this.onOpen,
    this.onEdit,
    this.onArchive,
    this.onRestore,
    this.onClose,
  });

  final CreditCard card;
  final String bankName;
  final VoidCallback? onOpen;
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

    final isDark = theme.brightness == Brightness.dark;
    final gradientColors = _gradientFor(card.network);

    return AppCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.zero,
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardNetworkBadge(network: card.network, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.displayName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
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
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: card.isActive
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
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
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                        child: _Metric(
                          label: 'Limit',
                          amountMinor: summary.creditLimitMinor,
                          currencyCode: card.currencyCode,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Expanded(
                        child: _Metric(
                          label: 'Outstanding',
                          amountMinor: summary.outstandingMinor,
                          currencyCode: card.currencyCode,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
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
        ],
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

List<Color> _gradientFor(CardNetwork network) {
  return switch (network) {
    CardNetwork.visa => const [Color(0xFF1A1F71), Color(0xFF0056B3)],
    CardNetwork.mastercard => const [Color(0xFFEB001B), Color(0xFFF79E1B)],
    CardNetwork.americanExpress => const [Color(0xFF006FCF), Color(0xFF00A3E0)],
    CardNetwork.rupay => const [Color(0xFFFF6600), Color(0xFF008080)],
    CardNetwork.discover => const [Color(0xFFFF6000), Color(0xFFFFA500)],
    CardNetwork.other => const [Color(0xFF475569), Color(0xFF1E293B)],
  };
}

class _CardDetailSheet extends ConsumerWidget {
  const _CardDetailSheet({required this.card, required this.bankName});

  final CreditCard card;
  final String bankName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summary = CardSummary(card);
    final recent = ref.watch(cardRecentTransactionsProvider(card.id));
    final reward = ref.watch(rewardAccountForCardProvider(card.id));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientFor(card.network),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CardNetworkBadge(network: card.network, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$bankName  •••• ${card.lastFour}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ManageCardGrid(card: card, summary: summary),
          const SizedBox(height: 12),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    summary.utilisationPercent == null
                        ? 'Utilisation unavailable (zero limit)'
                        : 'Utilisation ${formatPercent(summary.utilisationPercent!)}',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () {
                  ref
                      .read(transactionFilterProvider.notifier)
                      .set(TransactionFilter(cardId: card.id));
                  Navigator.pop(context);
                  context.go(AppRoutes.transactions);
                },
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: const Text('Transactions'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.statements);
                },
                icon: const Icon(Icons.description_outlined, size: 18),
                label: const Text('Statements'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.go(AppRoutes.rewards);
                },
                icon: const Icon(Icons.stars_outlined, size: 18),
                label: const Text('Rewards'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Statement day: ${card.statementDay ?? '—'} · '
            'Due day: ${card.dueDay ?? '—'}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Text('Recent transactions', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          recent.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('Recent transactions are unavailable.'),
            data: (items) => items.isEmpty
                ? const Text('No transactions for this card yet.')
                : AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final tx in items)
                          TransactionTile(
                            transaction: tx,
                            card: card,
                            onTap: () {
                              ref
                                  .read(transactionFilterProvider.notifier)
                                  .set(TransactionFilter(cardId: card.id));
                              Navigator.pop(context);
                              context.go(AppRoutes.transactions);
                            },
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          reward.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (account) => account == null
                ? const SizedBox.shrink()
                : AppCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${account.programmeName}: '
                            '${account.currentPoints} points',
                          ),
                        ),
                        if (account.estimatedValueMinor != null &&
                            account.currencyCode != null)
                          CurrencyText(
                            amountMinor: account.estimatedValueMinor!,
                            currencyCode: account.currencyCode!,
                            style: theme.textTheme.labelMedium,
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          if (card.rewardProgramme != null)
            Text(
              'Reward programme: ${card.rewardProgramme}',
              style: theme.textTheme.bodySmall,
            ),
          Text(
            'Updated ${formatShortDate(card.updatedAt)}',
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
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
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ManageCardGrid extends StatefulWidget {
  const _ManageCardGrid({required this.card, required this.summary});

  final CreditCard card;
  final CardSummary summary;

  @override
  State<_ManageCardGrid> createState() => _ManageCardGridState();
}

class _ManageCardGridState extends State<_ManageCardGrid> {
  bool _balanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final card = widget.card;
    final summary = widget.summary;
    final goldColor = isDark ? AppColors.gold : AppColors.lightGold;

    return Row(
      children: [
        Expanded(
          child: AppCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AVAILABLE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        letterSpacing: 1.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        _balanceVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 14,
                        color: goldColor,
                      ),
                      onPressed: () =>
                          setState(() => _balanceVisible = !_balanceVisible),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (_balanceVisible)
                  CurrencyText(
                    amountMinor: summary.availableCreditMinor,
                    currencyCode: card.currencyCode,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  Text(
                    '••••••••',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  'of ${card.currencyCode} ${(summary.creditLimitMinor / 100).round()}',
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PAYMENT DUE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        letterSpacing: 1.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Due ${card.dueDay ?? '—'}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: goldColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                CurrencyText(
                  amountMinor: summary.outstandingMinor,
                  currencyCode: card.currencyCode,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Reconciled balance',
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
