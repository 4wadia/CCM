import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../domain/entities/import_job.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../../../cards/presentation/widgets/card_picker_dialog.dart';
import '../providers/transaction_providers.dart';

class ReviewQueueSheet extends ConsumerStatefulWidget {
  const ReviewQueueSheet({super.key});

  @override
  ConsumerState<ReviewQueueSheet> createState() => _ReviewQueueSheetState();
}

class _ReviewQueueSheetState extends ConsumerState<ReviewQueueSheet> {
  String? _busyId;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(reviewItemsProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Review queue',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Text(
            'Nothing is silently discarded. Resolve or dismiss each item.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(
                child: Text('The review queue could not be loaded.'),
              ),
              data: (values) => values.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.inbox_outlined,
                      title: 'Nothing to review',
                      subtitle: 'Ambiguous imports will appear here.',
                    )
                  : ListView.builder(
                      itemCount: values.length,
                      itemBuilder: (context, index) {
                        final item = values[index];
                        return _ReviewCard(
                          item: item,
                          busy: _busyId == item.id,
                          onAssign: item.entityId == null
                              ? null
                              : () => _assign(item),
                          onResolve: () => _setStatus(item, resolve: true),
                          onDismiss: () => _setStatus(item, resolve: false),
                          onOpenStatements: item.entityType == 'statement'
                              ? () {
                                  Navigator.pop(context);
                                  context.go(AppRoutes.statements);
                                }
                              : null,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _assign(ReviewItem item) async {
    if (item.entityType != 'transaction' || item.entityId == null) return;
    final cardId = await showCardPickerDialog(context, ref);
    if (cardId == null || !mounted) return;
    setState(() => _busyId = item.id);
    try {
      final cards = await ref.read(creditCardsProvider.future);
      final card = cards.firstWhere((candidate) => candidate.id == cardId);
      final transactions = await ref.read(transactionRepositoryProvider.future);
      await transactions.assignCard(
        id: item.entityId!,
        cardId: card.id,
        bankId: card.bankId,
      );
      final reviews = await ref.read(reviewRepositoryProvider.future);
      await reviews.resolve(item.id);
      _refresh();
    } catch (_) {
      _showError('The card could not be assigned.');
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  Future<void> _setStatus(ReviewItem item, {required bool resolve}) async {
    setState(() => _busyId = item.id);
    try {
      final reviews = await ref.read(reviewRepositoryProvider.future);
      if (resolve) {
        await reviews.resolve(item.id);
      } else {
        await reviews.dismiss(item.id);
      }
      _refresh();
    } catch (_) {
      _showError('The review item could not be updated.');
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  void _refresh() {
    ref.invalidate(reviewItemsProvider);
    ref.invalidate(reviewCountProvider);
    ref.invalidate(transactionsProvider);
    ref.invalidate(transactionCountProvider);
    ref.invalidate(recentTransactionsProvider);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.item,
    required this.busy,
    required this.onAssign,
    required this.onResolve,
    required this.onDismiss,
    this.onOpenStatements,
  });

  final ReviewItem item;
  final bool busy;
  final VoidCallback? onAssign;
  final VoidCallback onResolve;
  final VoidCallback onDismiss;
  final VoidCallback? onOpenStatements;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _reason(item.reasonCode),
                  style: theme.textTheme.titleSmall,
                ),
              ),
              Text(
                formatShortDate(item.createdAt),
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(item.userMessage, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            '${item.entityType} · ${item.sourceType ?? 'unknown source'}',
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (onAssign != null)
                FilledButton.tonal(
                  onPressed: busy ? null : onAssign,
                  child: const Text('Assign card'),
                ),
              if (onOpenStatements != null)
                OutlinedButton(
                  onPressed: busy ? null : onOpenStatements,
                  child: const Text('Open statements'),
                ),
              OutlinedButton(
                onPressed: busy ? null : onResolve,
                child: const Text('Resolve'),
              ),
              TextButton(
                onPressed: busy ? null : onDismiss,
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _reason(String code) {
    return switch (code) {
      'card_unmatched' => 'Card could not be matched',
      'card_ambiguous' => 'More than one card matched',
      'duplicate_ambiguous' => 'Possible duplicate',
      'low_confidence' => 'Low-confidence import',
      'import_failed' => 'Import failed',
      'sms_unparsed' => 'SMS could not be parsed',
      'statement_password' => 'Statement password needed',
      'statement_extraction' => 'Statement text unreadable',
      'statement_card_unmatched' => 'Statement card not matched',
      'statement_card_ambiguous' => 'Statement card ambiguous',
      'statement_total_mismatch' => 'Statement total mismatch',
      'gmail_low_confidence' => 'Low-confidence statement email',
      'gmail_no_pdf' => 'Statement email had no PDF',
      'gmail_attachment_too_large' => 'Statement PDF too large',
      'gmail_attachment_failed' => 'Statement PDF import failed',
      _ => 'Imported record needs review',
    };
  }
}
