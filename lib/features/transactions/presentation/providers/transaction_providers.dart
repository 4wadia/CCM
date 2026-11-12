import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/import_job.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/transaction_category.dart';

class TransactionFilterNotifier extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => const TransactionFilter();

  void set(TransactionFilter filter) => state = filter;

  void clear() => state = const TransactionFilter();

  void toggleReviewOnly() {
    state = TransactionFilter(
      cardId: state.cardId,
      bankId: state.bankId,
      categoryId: state.categoryId,
      merchant: state.merchant,
      from: state.from,
      to: state.to,
      minAmountMinor: state.minAmountMinor,
      maxAmountMinor: state.maxAmountMinor,
      types: state.types,
      status: state.status,
      sourceType: state.sourceType,
      reviewOnly: !state.reviewOnly,
      unassignedOnly: state.unassignedOnly,
    );
  }
}

final transactionFilterProvider =
    NotifierProvider<TransactionFilterNotifier, TransactionFilter>(
      TransactionFilterNotifier.new,
    );

final transactionsProvider = FutureProvider<List<CardTransaction>>((ref) async {
  final filter = ref.watch(transactionFilterProvider);
  final repository = await ref.watch(transactionRepositoryProvider.future);
  return repository.search(filter: filter, limit: 300);
});

final transactionCountProvider = FutureProvider<int>((ref) async {
  final filter = ref.watch(transactionFilterProvider);
  final repository = await ref.watch(transactionRepositoryProvider.future);
  return repository.count(filter);
});

final recentTransactionsProvider = FutureProvider<List<CardTransaction>>((
  ref,
) async {
  final repository = await ref.watch(transactionRepositoryProvider.future);
  return repository.recentForCard(limit: 5);
});

final cardRecentTransactionsProvider =
    FutureProvider.family<List<CardTransaction>, String>((ref, cardId) async {
      final repository = await ref.watch(transactionRepositoryProvider.future);
      return repository.recentForCard(cardId: cardId, limit: 5);
    });

final transactionCategoriesProvider = FutureProvider<List<TransactionCategory>>(
  (ref) async {
    final repository = await ref.watch(categoryRepositoryProvider.future);
    return repository.getAll();
  },
);

final reviewItemsProvider = FutureProvider<List<ReviewItem>>((ref) async {
  final repository = await ref.watch(reviewRepositoryProvider.future);
  return repository.listOpen();
});

final reviewCountProvider = FutureProvider<int>((ref) async {
  final repository = await ref.watch(reviewRepositoryProvider.future);
  return repository.countOpen();
});

final transactionSourcesProvider =
    FutureProvider.family<List<TransactionSource>, String>((ref, txId) async {
      final repository = await ref.watch(transactionRepositoryProvider.future);
      return repository.sourcesFor(txId);
    });
