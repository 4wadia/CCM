import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/cashback.dart';
import '../../../../domain/entities/reward.dart';

final cashbackEntriesProvider = FutureProvider<List<CashbackEntry>>((
  ref,
) async {
  final repository = await ref.watch(cashbackRepositoryProvider.future);
  return repository.getAll();
});

final cashbackRulesProvider = FutureProvider<List<CashbackRule>>((ref) async {
  final repository = await ref.watch(cashbackRepositoryProvider.future);
  return repository.allRules();
});

final rewardsOverviewProvider = FutureProvider<List<RewardAccount>>((
  ref,
) async {
  final repository = await ref.watch(rewardRepositoryProvider.future);
  return repository.accounts();
});

final rewardEntriesProvider = FutureProvider.family<List<RewardEntry>, String>((
  ref,
  accountId,
) async {
  final repository = await ref.watch(rewardRepositoryProvider.future);
  return repository.entriesForAccount(accountId);
});

final rewardAccountForCardProvider =
    FutureProvider.family<RewardAccount?, String>((ref, cardId) async {
      final repository = await ref.watch(rewardRepositoryProvider.future);
      return repository.accountForCard(cardId);
    });
