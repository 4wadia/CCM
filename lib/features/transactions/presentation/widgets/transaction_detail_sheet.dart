import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../../../cards/presentation/widgets/card_picker_dialog.dart';
import '../providers/transaction_providers.dart';
import 'transaction_editor_sheet.dart';

class TransactionDetailSheet extends ConsumerStatefulWidget {
  const TransactionDetailSheet({super.key, required this.transaction});

  final CardTransaction transaction;

  @override
  ConsumerState<TransactionDetailSheet> createState() =>
      _TransactionDetailSheetState();
}

class _TransactionDetailSheetState
    extends ConsumerState<TransactionDetailSheet> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final tx = widget.transaction;
    final cards = ref.watch(creditCardsProvider);
    final categories = ref.watch(transactionCategoriesProvider);
    final sources = ref.watch(transactionSourcesProvider(tx.id));
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tx.displayMerchant,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 4),
          CurrencyText(
            amountMinor: tx.amountMinor,
            currencyCode: tx.currencyCode,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: tx.isCredit ? theme.colorScheme.tertiary : null,
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                _row('Date', formatShortDate(tx.transactionDate)),
                if (tx.postingDate != null)
                  _row('Posted', formatShortDate(tx.postingDate)),
                _row('Type', tx.transactionType.label),
                _row('Status', tx.status.label),
                cards.when(
                  loading: () => _row('Card', 'Loading…'),
                  error: (_, _) => _row('Card', 'Unavailable'),
                  data: (items) {
                    final card = items
                        .where((card) => card.id == tx.cardId)
                        .firstOrNull;
                    return _row('Card', cardLabel(card));
                  },
                ),
                categories.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (items) {
                    final category = items
                        .where((category) => category.id == tx.categoryId)
                        .firstOrNull;
                    return _row('Category', category?.name ?? 'Uncategorised');
                  },
                ),
                if (tx.notes != null && tx.notes!.isNotEmpty)
                  _row('Notes', tx.notes!),
              ],
            ),
          ),
          if (tx.needsReview) ...[
            const SizedBox(height: 8),
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'This transaction is in the review queue. Correct the card or '
                  'merchant, then resolve it.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _busy ? null : _edit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _assignCard,
                icon: const Icon(Icons.credit_card),
                label: const Text('Assign card'),
              ),
              if (tx.needsReview)
                FilledButton.icon(
                  onPressed: _busy ? null : () => _setStatus(posted: true),
                  icon: const Icon(Icons.check),
                  label: const Text('Mark posted'),
                )
              else
                TextButton.icon(
                  onPressed: _busy ? null : () => _setStatus(posted: false),
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Needs review'),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Sources', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          sources.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('Sources could not be loaded.'),
            data: (items) => items.isEmpty
                ? const Text('No source record.')
                : Column(
                    children: [
                      for (final source in items)
                        AppCard(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(source.sourceType.label),
                              const SizedBox(height: 2),
                              Text(
                                '${source.matchStatus.name} · '
                                '${formatShortDate(source.createdAt)}',
                                style: theme.textTheme.bodySmall,
                              ),
                              if (source.originalDescription.isNotEmpty)
                                Text(
                                  source.originalDescription,
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _edit() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => TransactionEditorSheet(transaction: widget.transaction),
    );
    if (saved == true && mounted) {
      _refresh();
      Navigator.pop(context);
    }
  }

  Future<void> _assignCard() async {
    final cardId = await showCardPickerDialog(
      context,
      ref,
      selectedId: widget.transaction.cardId,
    );
    if (cardId == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final cards = await ref.read(creditCardsProvider.future);
      final card = cards.firstWhere((candidate) => candidate.id == cardId);
      final repository = await ref.read(transactionRepositoryProvider.future);
      await repository.assignCard(
        id: widget.transaction.id,
        cardId: card.id,
        bankId: card.bankId,
      );
      final reviews = await ref.read(reviewRepositoryProvider.future);
      await reviews.resolveForEntity(
        entityType: 'transaction',
        entityId: widget.transaction.id,
      );
      _refresh();
      if (mounted) Navigator.pop(context);
    } on AppFailure catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('The card could not be assigned.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setStatus({required bool posted}) async {
    setState(() => _busy = true);
    try {
      final repository = await ref.read(transactionRepositoryProvider.future);
      await repository.setStatus(
        widget.transaction.id,
        posted ? TransactionStatus.posted : TransactionStatus.needsReview,
      );
      if (posted) {
        final reviews = await ref.read(reviewRepositoryProvider.future);
        await reviews.resolveForEntity(
          entityType: 'transaction',
          entityId: widget.transaction.id,
        );
      }
      _refresh();
      if (mounted) Navigator.pop(context);
    } catch (_) {
      _showError('The transaction status could not be changed.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _refresh() {
    ref.invalidate(transactionsProvider);
    ref.invalidate(transactionCountProvider);
    ref.invalidate(recentTransactionsProvider);
    ref.invalidate(reviewItemsProvider);
    ref.invalidate(reviewCountProvider);
    ref.invalidate(transactionSourcesProvider(widget.transaction.id));
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
