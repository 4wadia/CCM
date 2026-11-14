import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/services/money_amount.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../providers/transaction_providers.dart';

class TransactionFilterSheet extends ConsumerStatefulWidget {
  const TransactionFilterSheet({super.key, required this.current});

  final TransactionFilter current;

  @override
  ConsumerState<TransactionFilterSheet> createState() =>
      _TransactionFilterSheetState();
}

class _TransactionFilterSheetState
    extends ConsumerState<TransactionFilterSheet> {
  late String? _cardId;
  late String? _categoryId;
  late Set<TransactionType> _types;
  late TransactionStatus? _status;
  late TransactionSourceType? _sourceType;
  late DateTimeRange? _range;
  late bool _reviewOnly;
  late bool _unassignedOnly;
  late final TextEditingController _merchant;
  late final TextEditingController _minAmount;
  late final TextEditingController _maxAmount;

  @override
  void initState() {
    super.initState();
    final f = widget.current;
    _cardId = f.cardId;
    _categoryId = f.categoryId;
    _types = {...f.types};
    _status = f.status;
    _sourceType = f.sourceType;
    _range = f.from != null && f.to != null
        ? DateTimeRange(start: f.from!, end: f.to!)
        : null;
    _reviewOnly = f.reviewOnly;
    _unassignedOnly = f.unassignedOnly;
    _merchant = TextEditingController(text: f.merchant ?? '');
    _minAmount = TextEditingController(
      text: f.minAmountMinor == null ? '' : _format(f.minAmountMinor!),
    );
    _maxAmount = TextEditingController(
      text: f.maxAmountMinor == null ? '' : _format(f.maxAmountMinor!),
    );
  }

  @override
  void dispose() {
    _merchant.dispose();
    _minAmount.dispose();
    _maxAmount.dispose();
    super.dispose();
  }

  String _format(int amount) => (amount / 100).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(creditCardsProvider);
    final categories = ref.watch(transactionCategoriesProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 18,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Filter transactions',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              TextButton(onPressed: _clear, child: const Text('Clear all')),
            ],
          ),
          const SizedBox(height: 12),
          cards.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const SizedBox.shrink(),
            data: (items) => DropdownButtonFormField<String>(
              initialValue: _cardId ?? '',
              decoration: const InputDecoration(labelText: 'Card'),
              items: [
                const DropdownMenuItem(value: '', child: Text('All cards')),
                for (final card in items)
                  DropdownMenuItem(
                    value: card.id,
                    child: Text(
                      '${card.displayName} •••• ${card.lastFour}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) => setState(
                () => _cardId = value == null || value.isEmpty ? null : value,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _merchant,
            decoration: const InputDecoration(
              labelText: 'Merchant contains',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          categories.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (items) => DropdownButtonFormField<String>(
              initialValue: _categoryId ?? '',
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('All categories'),
                ),
                for (final category in items)
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
          ),
          const SizedBox(height: 12),
          Text('Types', style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final type in TransactionType.values)
                FilterChip(
                  label: Text(type.label),
                  selected: _types.contains(type),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _types.add(type);
                    } else {
                      _types.remove(type);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _status?.name ?? '',
            decoration: const InputDecoration(labelText: 'Status'),
            items: [
              const DropdownMenuItem(value: '', child: Text('Any status')),
              for (final status in TransactionStatus.values)
                DropdownMenuItem(value: status.name, child: Text(status.label)),
            ],
            onChanged: (value) => setState(
              () => _status = value == null || value.isEmpty
                  ? null
                  : TransactionStatus.fromStorage(value),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _sourceType?.name ?? '',
            decoration: const InputDecoration(labelText: 'Source'),
            items: [
              const DropdownMenuItem(value: '', child: Text('Any source')),
              for (final source in TransactionSourceType.values)
                DropdownMenuItem(value: source.name, child: Text(source.label)),
            ],
            onChanged: (value) => setState(
              () => _sourceType = value == null || value.isEmpty
                  ? null
                  : TransactionSourceType.fromStorage(value),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickRange,
            icon: const Icon(Icons.date_range_outlined),
            label: Text(
              _range == null
                  ? 'Any date'
                  : '${formatShortDate(_range!.start)} – '
                        '${formatShortDate(_range!.end)}',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minAmount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Min amount'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _maxAmount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Max amount'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Needs review only'),
            value: _reviewOnly,
            onChanged: (value) => setState(() => _reviewOnly = value),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Unassigned card only'),
            value: _unassignedOnly,
            onChanged: (value) => setState(() => _unassignedOnly = value),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _apply,
            icon: const Icon(Icons.filter_alt_outlined),
            label: const Text('Apply filters'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: _range,
    );
    if (picked != null) setState(() => _range = picked);
  }

  void _apply() {
    final cards =
        ref.read(creditCardsProvider).asData?.value ?? const <CreditCard>[];
    final currency =
        cards.where((card) => card.id == _cardId).firstOrNull?.currencyCode ??
        'INR';
    final min = _minAmount.text.trim().isEmpty
        ? null
        : MoneyAmount.parseNonNegativeMinorUnits(_minAmount.text, currency);
    final max = _maxAmount.text.trim().isEmpty
        ? null
        : MoneyAmount.parseNonNegativeMinorUnits(_maxAmount.text, currency);
    if ((_minAmount.text.trim().isNotEmpty && min == null) ||
        (_maxAmount.text.trim().isNotEmpty && max == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid amount filters.')),
      );
      return;
    }
    if (min != null && max != null && min > max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Min amount cannot exceed max amount.')),
      );
      return;
    }
    ref
        .read(transactionFilterProvider.notifier)
        .set(
          TransactionFilter(
            cardId: _cardId,
            categoryId: _categoryId,
            merchant: _merchant.text.trim().isEmpty
                ? null
                : _merchant.text.trim(),
            from: _range == null
                ? null
                : DateTime(
                    _range!.start.year,
                    _range!.start.month,
                    _range!.start.day,
                  ),
            to: _range == null
                ? null
                : DateTime(
                    _range!.end.year,
                    _range!.end.month,
                    _range!.end.day,
                  ),
            minAmountMinor: min,
            maxAmountMinor: max,
            types: _types,
            status: _status,
            sourceType: _sourceType,
            reviewOnly: _reviewOnly,
            unassignedOnly: _unassignedOnly,
          ),
        );
    Navigator.pop(context);
  }

  void _clear() {
    ref.read(transactionFilterProvider.notifier).clear();
    Navigator.pop(context);
  }
}
