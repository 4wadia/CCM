import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/services/csv_exporter.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
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
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      8,
                      AppSpacing.pageHorizontal,
                      4,
                    ),
                    child: Material(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkWarning.withValues(alpha: 0.12)
                          : const Color(0xFFFEF3C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkWarning.withValues(alpha: 0.2)
                                : const Color(0xFFFDE68A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.rule,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkWarning
                                : const Color(0xFF92400E),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          '$value ${value == 1 ? 'item needs' : 'items need'} review',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkWarning
                                : const Color(0xFF92400E),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          'Ambiguous imports are waiting for a decision.',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkWarning.withValues(alpha: 0.8)
                                : const Color(0xFFB45309),
                            fontSize: 12,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkWarning
                              : const Color(0xFF92400E),
                          size: 20,
                        ),
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
                            const Divider(height: 1, indent: 70),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final total = count.asData?.value ?? items.length;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.pageHorizontal,
                                12,
                                AppSpacing.pageHorizontal,
                                8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '$total '
                                      '${total == 1 ? 'transaction' : 'transactions'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  if (filter.hasFilters)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: AppRadius.chip,
                                      ),
                                      child: Text(
                                        'Filtered',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
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
