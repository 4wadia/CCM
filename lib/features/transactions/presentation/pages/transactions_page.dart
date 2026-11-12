import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/services/csv_exporter.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../providers/transaction_providers.dart';
import '../widgets/review_queue_sheet.dart';
import '../widgets/transaction_detail_sheet.dart';
import '../widgets/transaction_editor_sheet.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_tile.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(transactionFilterProvider);
    final transactions = ref.watch(transactionsProvider);
    final count = ref.watch(transactionCountProvider);
    final reviews = ref.watch(reviewCountProvider);
    final cards = ref.watch(creditCardsProvider);
    final cardMap = <String, CreditCard>{
      for (final card in cards.asData?.value ?? const <CreditCard>[])
        card.id: card,
    };

    return Scaffold(
      key: const Key('transactions-page'),
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            key: const Key('transaction-filter'),
            tooltip: 'Filter transactions',
            onPressed: _openFilter,
            icon: Badge(
              isLabelVisible: filter.hasFilters,
              child: const Icon(Icons.filter_list),
            ),
          ),
          IconButton(
            key: const Key('export-transactions'),
            tooltip: 'Export CSV',
            onPressed: _exporting ? null : _export,
            icon: _exporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ios_share_outlined),
          ),
          IconButton(
            key: const Key('add-transaction'),
            tooltip: 'Add transaction',
            onPressed: _openEditor,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          reviews.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (value) => value == 0
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: ListTile(
                        leading: Icon(
                          Icons.rule,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        title: Text(
                          '$value ${value == 1 ? 'item needs' : 'items need'} review',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onErrorContainer,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _openReview,
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: transactions.when(
              loading: () =>
                  const AppLoadingState(message: 'Loading transactions…'),
              error: (_, _) => AppErrorState(
                message: 'Transactions could not be loaded.',
                onRetry: _refresh,
              ),
              data: (items) => RefreshIndicator(
                onRefresh: () async => _refresh(),
                child: items.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(
                            height: 420,
                            child: AppEmptyState(
                              icon: Icons.receipt_long_outlined,
                              title: filter.hasFilters
                                  ? 'No matching transactions'
                                  : 'No transactions yet',
                              subtitle: filter.hasFilters
                                  ? 'Clear or adjust the filters to see more.'
                                  : 'Add a transaction manually or import SMS, '
                                        'Gmail statements, or a PDF statement.',
                              actionLabel: filter.hasFilters
                                  ? 'Clear filters'
                                  : 'Add transaction',
                              onAction: filter.hasFilters
                                  ? () => ref
                                        .read(
                                          transactionFilterProvider.notifier,
                                        )
                                        .clear()
                                  : _openEditor,
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: items.length + 1,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, indent: 72),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final total = count.asData?.value ?? items.length;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '$total '
                                      '${total == 1 ? 'transaction' : 'transactions'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  if (filter.hasFilters)
                                    Text(
                                      'Filtered',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                ],
                              ),
                            );
                          }
                          final tx = items[index - 1];
                          return TransactionTile(
                            transaction: tx,
                            card: tx.cardId == null ? null : cardMap[tx.cardId],
                            onTap: () => _openDetails(tx),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditor() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const TransactionEditorSheet(),
    );
    if (saved == true) _refresh();
  }

  Future<void> _openDetails(CardTransaction transaction) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => TransactionDetailSheet(transaction: transaction),
    );
    _refresh();
  }

  Future<void> _openFilter() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          TransactionFilterSheet(current: ref.read(transactionFilterProvider)),
    );
  }

  Future<void> _openReview() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ReviewQueueSheet(),
    );
    _refresh();
  }

  void _refresh() {
    ref.invalidate(transactionsProvider);
    ref.invalidate(transactionCountProvider);
    ref.invalidate(reviewItemsProvider);
    ref.invalidate(reviewCountProvider);
    ref.invalidate(recentTransactionsProvider);
  }

  Future<void> _export() async {
    final items = ref.read(transactionsProvider).asData?.value;
    if (items == null || items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There are no transactions to export.')),
      );
      return;
    }
    setState(() => _exporting = true);
    try {
      final cards = ref.read(creditCardsProvider).asData?.value ?? const [];
      final csv = CsvExporter.export(
        transactions: items,
        cards: {for (final card in cards) card.id: card},
      );
      await FilePicker.saveFile(
        fileName: 'transactions-${formatFileDate(DateTime.now())}.csv',
        bytes: Uint8List.fromList(utf8.encode(csv)),
        mimeType: 'text/csv',
        dialogTitle: 'Save transaction export',
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The CSV export could not be saved.')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}
