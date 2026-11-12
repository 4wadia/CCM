import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/cashback.dart';
import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/reward.dart';
import '../../../../domain/entities/transaction_category.dart';
import '../../../../domain/services/ids.dart';
import '../../../../domain/services/money_amount.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/formatting/percent.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../providers/reward_providers.dart';

class RewardsPage extends ConsumerStatefulWidget {
  const RewardsPage({super.key});

  @override
  ConsumerState<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends ConsumerState<RewardsPage> {
  bool _applying = false;

  @override
  Widget build(BuildContext context) {
    final cashback = ref.watch(cashbackEntriesProvider);
    final accounts = ref.watch(rewardsOverviewProvider);
    final rules = ref.watch(cashbackRulesProvider);
    final cards = ref.watch(creditCardsProvider);
    final cardMap = <String, CreditCard>{
      for (final card in cards.asData?.value ?? const <CreditCard>[])
        card.id: card,
    };

    return Scaffold(
      key: const Key('rewards-page'),
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          IconButton(
            key: const Key('apply-cashback-rules'),
            tooltip: 'Apply cashback rules',
            onPressed: _applying ? null : _applyRules,
            icon: _applying
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.calculate_outlined),
          ),
          PopupMenuButton<_RewardAction>(
            key: const Key('rewards-add-menu'),
            onSelected: (action) {
              switch (action) {
                case _RewardAction.cashback:
                  _openAddCashback();
                case _RewardAction.rule:
                  _openAddRule();
                case _RewardAction.account:
                  _openAddAccount();
                case _RewardAction.adjust:
                  _openAdjustPoints(accounts.asData?.value ?? const []);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _RewardAction.cashback,
                child: Text('Add cashback'),
              ),
              PopupMenuItem(
                value: _RewardAction.rule,
                child: Text('Add cashback rule'),
              ),
              PopupMenuItem(
                value: _RewardAction.account,
                child: Text('Add reward account'),
              ),
              PopupMenuItem(
                value: _RewardAction.adjust,
                child: Text('Adjust reward points'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(cashbackEntriesProvider);
          ref.invalidate(rewardsOverviewProvider);
          ref.invalidate(cashbackRulesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _SectionHeader(
              title: 'Cashback',
              subtitle:
                  'Integer minor units only. Values are never converted '
                  'between currencies.',
              action: TextButton.icon(
                onPressed: _openAddCashback,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ),
            cashback.when(
              loading: () =>
                  const AppLoadingState(message: 'Loading cashback…'),
              error: (_, _) => AppErrorState(
                message: 'Cashback could not be loaded.',
                onRetry: () => ref.invalidate(cashbackEntriesProvider),
              ),
              data: (entries) =>
                  _CashbackSection(entries: entries, cardMap: cardMap),
            ),
            const SizedBox(height: 20),
            _SectionHeader(
              title: 'Reward points',
              subtitle:
                  'Points are tracked per programme and are never assumed '
                  'from purchases.',
              action: TextButton.icon(
                onPressed: () =>
                    _openAdjustPoints(accounts.asData?.value ?? const []),
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Adjust'),
              ),
            ),
            accounts.when(
              loading: () =>
                  const AppLoadingState(message: 'Loading reward accounts…'),
              error: (_, _) => AppErrorState(
                message: 'Reward accounts could not be loaded.',
                onRetry: () => ref.invalidate(rewardsOverviewProvider),
              ),
              data: (items) => items.isEmpty
                  ? AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'No reward accounts yet. Add a programme to '
                              'track points and estimates.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          TextButton(
                            onPressed: _openAddAccount,
                            child: const Text('Add account'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        for (final account in items)
                          _RewardAccountCard(
                            account: account,
                            card: cardMap[account.cardId],
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            _SectionHeader(
              title: 'Cashback rules',
              subtitle:
                  'Rules are declarative and applied locally to matching '
                  'purchases.',
              action: TextButton.icon(
                onPressed: _openAddRule,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add rule'),
              ),
            ),
            rules.when(
              loading: () =>
                  const AppLoadingState(message: 'Loading cashback rules…'),
              error: (_, _) => AppErrorState(
                message: 'Cashback rules could not be loaded.',
                onRetry: () => ref.invalidate(cashbackRulesProvider),
              ),
              data: (items) => items.isEmpty
                  ? const AppCard(
                      child: Text(
                        'No cashback rules. Add a flat or percentage rule to '
                        'calculate cashback for matching purchases.',
                      ),
                    )
                  : Column(
                      children: [
                        for (final rule in items)
                          _CashbackRuleCard(
                            rule: rule,
                            card: cardMap[rule.cardId],
                            onDelete: () => _deleteRule(rule),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            const _SectionHeader(
              title: 'Recent cashback entries',
              subtitle: 'Credited, pending, and reversed cashback.',
            ),
            cashback.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (entries) => entries.isEmpty
                  ? const AppCard(
                      child: Text('No cashback entries have been recorded.'),
                    )
                  : Column(
                      children: [
                        for (final entry in entries.take(20))
                          _CashbackEntryTile(
                            entry: entry,
                            card: cardMap[entry.cardId],
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applyRules() async {
    setState(() => _applying = true);
    try {
      final service = await ref.read(cashbackApplicationServiceProvider.future);
      final created = await service.applyRules();
      ref.invalidate(cashbackEntriesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              created == 0
                  ? 'No new cashback entries matched the active rules.'
                  : '$created cashback ${created == 1 ? 'entry' : 'entries'} '
                        'created.',
            ),
          ),
        );
      }
    } catch (_) {
      _showError('Cashback rules could not be applied.');
    } finally {
      if (mounted) setState(() => _applying = false);
    }
  }

  Future<void> _openAddCashback() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _AddCashbackSheet(),
    );
    if (saved == true) ref.invalidate(cashbackEntriesProvider);
  }

  Future<void> _openAddRule() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _AddRuleSheet(),
    );
    if (saved == true) ref.invalidate(cashbackRulesProvider);
  }

  Future<void> _openAddAccount() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _AddRewardAccountSheet(),
    );
    if (saved == true) ref.invalidate(rewardsOverviewProvider);
  }

  Future<void> _openAdjustPoints(List<RewardAccount> accounts) async {
    if (accounts.isEmpty) {
      _showError('Add a reward account before adjusting points.');
      return;
    }
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _AdjustPointsSheet(accounts: accounts),
    );
    if (saved == true) {
      ref.invalidate(rewardsOverviewProvider);
      for (final account in accounts) {
        ref.invalidate(rewardEntriesProvider(account.id));
      }
    }
  }

  Future<void> _deleteRule(CashbackRule rule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete cashback rule?'),
        content: const Text(
          'Existing cashback entries are kept. Future calculations will not '
          'use this rule.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final repository = await ref.read(cashbackRepositoryProvider.future);
      await repository.deleteRule(rule.id);
      ref.invalidate(cashbackRulesProvider);
    } catch (_) {
      _showError('The rule could not be deleted.');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

enum _RewardAction { cashback, rule, account, adjust }

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle, this.action});

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

class _CashbackSection extends StatelessWidget {
  const _CashbackSection({required this.entries, required this.cardMap});

  final List<CashbackEntry> entries;
  final Map<String, CreditCard> cardMap;

  @override
  Widget build(BuildContext context) {
    final totals = <String, int>{};
    for (final entry in entries.where(
      (entry) => entry.status != CashbackStatus.reversed,
    )) {
      totals.update(
        entry.currencyCode,
        (value) => value + entry.amountMinor,
        ifAbsent: () => entry.amountMinor,
      );
    }
    final pending = <String, int>{};
    for (final entry in entries.where(
      (entry) => entry.status == CashbackStatus.pending,
    )) {
      pending.update(
        entry.currencyCode,
        (value) => value + entry.amountMinor,
        ifAbsent: () => entry.amountMinor,
      );
    }

    if (entries.isEmpty) {
      return const AppCard(
        child: Text(
          'No cashback yet. Add an entry manually or apply cashback rules.',
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: [
              for (final currency in totals.keys)
                _CurrencyTotal(
                  label: 'Total',
                  amountMinor: totals[currency]!,
                  currencyCode: currency,
                ),
              for (final currency in pending.keys)
                _CurrencyTotal(
                  label: 'Pending',
                  amountMinor: pending[currency]!,
                  currencyCode: currency,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${entries.length} ${entries.length == 1 ? 'entry' : 'entries'} '
            'across ${totals.length} ${totals.length == 1 ? 'currency' : 'currencies'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          for (final entry in entries.take(5))
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      cardMap[entry.cardId] == null
                          ? entry.cardId
                          : '${cardMap[entry.cardId]!.displayName} •••• '
                                '${cardMap[entry.cardId]!.lastFour}',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    entry.status.name,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(width: 10),
                  CurrencyText(
                    amountMinor: entry.amountMinor,
                    currencyCode: entry.currencyCode,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CurrencyTotal extends StatelessWidget {
  const _CurrencyTotal({
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
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RewardAccountCard extends StatelessWidget {
  const _RewardAccountCard({required this.account, required this.card});

  final RewardAccount account;
  final CreditCard? card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.stars_outlined, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.programmeName, style: theme.textTheme.titleSmall),
                Text(
                  card == null
                      ? account.cardId
                      : '${card!.displayName} •••• ${card!.lastFour}',
                  style: theme.textTheme.bodySmall,
                ),
                if (account.estimatedValueMinor != null &&
                    account.currencyCode != null)
                  Text(
                    'Estimated value: '
                    '${MoneyAmount.formatMinorUnits(account.estimatedValueMinor!, account.currencyCode!)}',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${account.currentPoints}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('points', style: theme.textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashbackRuleCard extends StatelessWidget {
  const _CashbackRuleCard({
    required this.rule,
    required this.card,
    required this.onDelete,
  });

  final CashbackRule rule;
  final CreditCard? card;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = switch (rule.kind) {
      CashbackRuleKind.percentage =>
        '${formatPercent((rule.rateBasisPoints ?? 0) / 100)} cashback',
      CashbackRuleKind.flat =>
        rule.flatAmountMinor == null
            ? 'Flat cashback'
            : '${MoneyAmount.formatMinorUnits(rule.flatAmountMinor!, rule.currencyCode ?? card?.currencyCode ?? 'INR')} flat',
    };
    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card == null
                      ? rule.cardId
                      : '${card!.displayName} •••• ${card!.lastFour}',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(description, style: theme.textTheme.bodySmall),
                if (rule.categoryId != null)
                  Text('Category-specific', style: theme.textTheme.labelSmall),
                if (rule.merchantContains != null)
                  Text(
                    'Merchant contains "${rule.merchantContains}"',
                    style: theme.textTheme.labelSmall,
                  ),
                if (rule.monthlyCapMinor != null)
                  Text(
                    'Monthly cap '
                    '${MoneyAmount.formatMinorUnits(rule.monthlyCapMinor!, rule.currencyCode ?? card?.currencyCode ?? 'INR')}',
                    style: theme.textTheme.labelSmall,
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Delete rule',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

class _CashbackEntryTile extends StatelessWidget {
  const _CashbackEntryTile({required this.entry, required this.card});

  final CashbackEntry entry;
  final CreditCard? card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card == null
                      ? entry.cardId
                      : '${card!.displayName} •••• ${card!.lastFour}',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  '${entry.status.name} · ${formatShortDate(entry.earnedAt)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          CurrencyText(
            amountMinor: entry.amountMinor,
            currencyCode: entry.currencyCode,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _AddCashbackSheet extends ConsumerStatefulWidget {
  const _AddCashbackSheet();

  @override
  ConsumerState<_AddCashbackSheet> createState() => _AddCashbackSheetState();
}

class _AddCashbackSheetState extends ConsumerState<_AddCashbackSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _notes = TextEditingController();
  String? _cardId;
  bool _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(creditCardsProvider);
    return _SheetScaffold(
      title: 'Add cashback',
      child: cards.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Text('Cards could not be loaded.'),
        data: (items) => Form(
          key: _formKey,
          child: Column(
            children: [
              _CardDropdown(
                cards: items,
                value: _cardId,
                onChanged: (value) => setState(() => _cardId = value),
              ),
              TextFormField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Cashback amount'),
                validator: (value) {
                  final card = _selectedCard(items);
                  if (card == null) return 'Choose a card first.';
                  final parsed = MoneyAmount.parseMinorUnits(
                    value ?? '',
                    card.currencyCode,
                  );
                  return parsed == null || parsed == 0
                      ? 'Enter a valid positive amount.'
                      : null;
                },
              ),
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _saving ? null : () => _save(items),
                icon: const Icon(Icons.save_outlined),
                label: Text(_saving ? 'Saving…' : 'Save cashback'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CreditCard? _selectedCard(List<CreditCard> cards) =>
      cards.where((card) => card.id == _cardId).firstOrNull;

  Future<void> _save(List<CreditCard> cards) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final card = _selectedCard(cards);
    if (card == null) return;
    final amount = MoneyAmount.parseMinorUnits(_amount.text, card.currencyCode);
    if (amount == null) return;
    setState(() => _saving = true);
    try {
      final repository = await ref.read(cashbackRepositoryProvider.future);
      await repository.save(
        CashbackEntry(
          id: Ids.next('cashback'),
          cardId: card.id,
          amountMinor: amount,
          currencyCode: card.currencyCode,
          status: CashbackStatus.credited,
          earnedAt: DateTime.now(),
          creditedAt: DateTime.now(),
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      _showError('The cashback entry could not be saved.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AddRuleSheet extends ConsumerStatefulWidget {
  const _AddRuleSheet();

  @override
  ConsumerState<_AddRuleSheet> createState() => _AddRuleSheetState();
}

class _AddRuleSheetState extends ConsumerState<_AddRuleSheet> {
  final _formKey = GlobalKey<FormState>();
  final _rate = TextEditingController();
  final _flat = TextEditingController();
  final _cap = TextEditingController();
  final _merchant = TextEditingController();
  String? _cardId;
  String? _categoryId;
  CashbackRuleKind _kind = CashbackRuleKind.percentage;
  bool _saving = false;

  @override
  void dispose() {
    _rate.dispose();
    _flat.dispose();
    _cap.dispose();
    _merchant.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(creditCardsProvider);
    final categories = ref.watch(transactionCategoriesProvider);
    final cardItems = cards.asData?.value ?? const <CreditCard>[];
    final categoryItems =
        categories.asData?.value ?? const <TransactionCategory>[];
    final selected = _selectedCard(cardItems);
    return _SheetScaffold(
      title: 'Add cashback rule',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _CardDropdown(
              cards: cardItems,
              value: _cardId,
              onChanged: (value) => setState(() => _cardId = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<CashbackRuleKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rule type'),
              items: const [
                DropdownMenuItem(
                  value: CashbackRuleKind.percentage,
                  child: Text('Percentage of purchase'),
                ),
                DropdownMenuItem(
                  value: CashbackRuleKind.flat,
                  child: Text('Flat amount per purchase'),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _kind = value ?? CashbackRuleKind.percentage),
            ),
            const SizedBox(height: 12),
            if (_kind == CashbackRuleKind.percentage)
              TextFormField(
                controller: _rate,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Rate',
                  suffixText: '%',
                ),
                validator: (value) => _parseBasisPoints(value ?? '') == null
                    ? 'Enter a rate such as 1.5.'
                    : null,
              )
            else
              TextFormField(
                controller: _flat,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Flat cashback',
                  prefixText: selected == null
                      ? null
                      : '${selected.currencyCode} ',
                ),
                validator: (value) {
                  if (selected == null) return 'Choose a card first.';
                  return MoneyAmount.parseMinorUnits(
                            value ?? '',
                            selected.currencyCode,
                          ) ==
                          null
                      ? 'Enter a valid positive amount.'
                      : null;
                },
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cap,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monthly cap (optional)',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                if (selected == null) return 'Choose a card first.';
                return MoneyAmount.parseNonNegativeMinorUnits(
                          value,
                          selected.currencyCode,
                        ) ==
                        null
                    ? 'Enter a valid cap.'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoryId ?? '',
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
              ),
              items: [
                const DropdownMenuItem(value: '', child: Text('Any category')),
                for (final category in categoryItems)
                  DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  ),
              ],
              onChanged: (value) => setState(
                () =>
                    _categoryId = value == null || value.isEmpty ? null : value,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _merchant,
              decoration: const InputDecoration(
                labelText: 'Merchant contains (optional)',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _saving ? null : () => _save(cardItems),
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving…' : 'Save rule'),
            ),
          ],
        ),
      ),
    );
  }

  CreditCard? _selectedCard(List<CreditCard> cards) =>
      cards.where((card) => card.id == _cardId).firstOrNull;

  int? _parseBasisPoints(String text) {
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(text.trim());
    if (match == null) return null;
    final whole = int.tryParse(match.group(1)!);
    if (whole == null) return null;
    final fraction = (match.group(2) ?? '').padRight(2, '0');
    return whole * 100 + int.parse(fraction.isEmpty ? '0' : fraction);
  }

  Future<void> _save(List<CreditCard> cards) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final card = _selectedCard(cards);
    if (card == null) return;
    setState(() => _saving = true);
    try {
      final repository = await ref.read(cashbackRepositoryProvider.future);
      final now = DateTime.now().toUtc();
      final basisPoints = _parseBasisPoints(_rate.text);
      final flat = _kind == CashbackRuleKind.flat
          ? MoneyAmount.parseMinorUnits(_flat.text, card.currencyCode)
          : null;
      final cap = _cap.text.trim().isEmpty
          ? null
          : MoneyAmount.parseNonNegativeMinorUnits(
              _cap.text,
              card.currencyCode,
            );
      await repository.saveRule(
        CashbackRule(
          id: Ids.next('cashback_rule'),
          cardId: card.id,
          kind: _kind,
          isActive: true,
          rateBasisPoints: _kind == CashbackRuleKind.percentage
              ? basisPoints
              : null,
          flatAmountMinor: flat,
          categoryId: _categoryId,
          merchantContains: _merchant.text.trim().isEmpty
              ? null
              : _merchant.text.trim(),
          monthlyCapMinor: cap,
          currencyCode: card.currencyCode,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      _showError('The cashback rule could not be saved.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AddRewardAccountSheet extends ConsumerStatefulWidget {
  const _AddRewardAccountSheet();

  @override
  ConsumerState<_AddRewardAccountSheet> createState() =>
      _AddRewardAccountSheetState();
}

class _AddRewardAccountSheetState
    extends ConsumerState<_AddRewardAccountSheet> {
  final _formKey = GlobalKey<FormState>();
  final _programme = TextEditingController();
  final _points = TextEditingController(text: '0');
  final _value = TextEditingController();
  String? _cardId;
  bool _saving = false;

  @override
  void dispose() {
    _programme.dispose();
    _points.dispose();
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(creditCardsProvider);
    final cardItems = cards.asData?.value ?? const <CreditCard>[];
    final selected = _selectedCard(cardItems);
    return _SheetScaffold(
      title: 'Add reward account',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _CardDropdown(
              cards: cardItems,
              value: _cardId,
              onChanged: (value) => setState(() => _cardId = value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _programme,
              decoration: const InputDecoration(labelText: 'Programme name'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter the programme name.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _points,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Current points'),
              validator: (value) {
                final parsed = int.tryParse((value ?? '').trim());
                return parsed == null || parsed < 0
                    ? 'Enter a whole number of points.'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _value,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Estimated value (optional)',
                prefixText: selected == null
                    ? null
                    : '${selected.currencyCode} ',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                if (selected == null) return 'Choose a card first.';
                return MoneyAmount.parseNonNegativeMinorUnits(
                          value,
                          selected.currencyCode,
                        ) ==
                        null
                    ? 'Enter a valid estimated value.'
                    : null;
              },
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _saving ? null : () => _save(cardItems),
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving…' : 'Save account'),
            ),
          ],
        ),
      ),
    );
  }

  CreditCard? _selectedCard(List<CreditCard> cards) =>
      cards.where((card) => card.id == _cardId).firstOrNull;

  Future<void> _save(List<CreditCard> cards) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final card = _selectedCard(cards);
    if (card == null) return;
    setState(() => _saving = true);
    try {
      final repository = await ref.read(rewardRepositoryProvider.future);
      final existing = await repository.accountForCard(card.id);
      if (existing != null) {
        _showError(
          'This card already has a reward account. Adjust its points instead.',
        );
        return;
      }
      final points = int.parse(_points.text.trim());
      final estimated = _value.text.trim().isEmpty
          ? null
          : MoneyAmount.parseNonNegativeMinorUnits(
              _value.text,
              card.currencyCode,
            );
      await repository.saveAccount(
        RewardAccount(
          id: Ids.next('reward_account'),
          cardId: card.id,
          programmeName: _programme.text.trim(),
          currentPoints: points,
          estimatedValueMinor: estimated,
          currencyCode: estimated == null ? null : card.currencyCode,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      _showError('The reward account could not be saved.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AdjustPointsSheet extends ConsumerStatefulWidget {
  const _AdjustPointsSheet({required this.accounts});

  final List<RewardAccount> accounts;

  @override
  ConsumerState<_AdjustPointsSheet> createState() => _AdjustPointsSheetState();
}

class _AdjustPointsSheetState extends ConsumerState<_AdjustPointsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _points = TextEditingController();
  final _description = TextEditingController();
  late String _accountId;
  RewardEntryType _type = RewardEntryType.adjustment;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _accountId = widget.accounts.first.id;
  }

  @override
  void dispose() {
    _points.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: 'Adjust reward points',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _accountId,
              decoration: const InputDecoration(labelText: 'Reward account'),
              items: [
                for (final account in widget.accounts)
                  DropdownMenuItem(
                    value: account.id,
                    child: Text(
                      '${account.programmeName} (${account.currentPoints} pts)',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) =>
                  setState(() => _accountId = value ?? _accountId),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RewardEntryType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Adjustment type'),
              items: const [
                DropdownMenuItem(
                  value: RewardEntryType.earned,
                  child: Text('Points earned'),
                ),
                DropdownMenuItem(
                  value: RewardEntryType.redeemed,
                  child: Text('Points redeemed'),
                ),
                DropdownMenuItem(
                  value: RewardEntryType.adjustment,
                  child: Text('Manual adjustment'),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _type = value ?? RewardEntryType.adjustment),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _points,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Points',
                helperText: 'Enter a positive whole number.',
              ),
              validator: (value) {
                final parsed = int.tryParse((value ?? '').trim());
                return parsed == null || parsed <= 0
                    ? 'Enter a positive whole number.'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving…' : 'Save adjustment'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final account = widget.accounts.firstWhere(
        (item) => item.id == _accountId,
      );
      final points = int.parse(_points.text.trim());
      final delta = _type == RewardEntryType.redeemed ? -points : points;
      final updated = account.currentPoints + delta;
      if (updated < 0) {
        _showError('The account does not have enough points.');
        return;
      }
      final repository = await ref.read(rewardRepositoryProvider.future);
      await repository.saveAccount(
        RewardAccount(
          id: account.id,
          cardId: account.cardId,
          programmeName: account.programmeName,
          currentPoints: max(0, updated),
          estimatedValueMinor: account.estimatedValueMinor,
          currencyCode: account.currencyCode,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await repository.saveEntry(
        RewardEntry(
          id: Ids.next('reward_entry'),
          rewardAccountId: account.id,
          points: delta,
          entryType: _type,
          description: _description.text.trim().isEmpty
              ? null
              : _description.text.trim(),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      _showError('The points adjustment could not be saved.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CardDropdown extends StatelessWidget {
  const _CardDropdown({
    required this.cards,
    required this.value,
    required this.onChanged,
  });

  final List<CreditCard> cards;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = cards.where((card) => card.isActive).toList(growable: false);
    return DropdownButtonFormField<String>(
      initialValue: active.any((card) => card.id == value) ? value : null,
      decoration: const InputDecoration(labelText: 'Card'),
      items: [
        for (final card in active)
          DropdownMenuItem(
            value: card.id,
            child: Text(
              '${card.displayName} •••• ${card.lastFour}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: onChanged,
      validator: (value) => value == null ? 'Choose a card.' : null,
    );
  }
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 18,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
