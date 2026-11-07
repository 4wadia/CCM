import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/bank.dart';
import '../../../../domain/entities/card_portfolio_summary.dart';
import '../../../../domain/entities/credit_card.dart';

final creditCardsProvider = FutureProvider<List<CreditCard>>((ref) async {
  final repository = await ref.watch(creditCardRepositoryProvider.future);
  return repository.getAll(includeArchived: true);
});

final knownBanksProvider = FutureProvider<List<Bank>>((ref) async {
  final repository = await ref.watch(bankRepositoryProvider.future);
  return repository.getAll();
});

/// Active cards and their currency-grouped financial totals.
final cardPortfolioProvider = FutureProvider<CardPortfolio>((ref) async {
  final cards = await ref.watch(creditCardsProvider.future);
  return CardPortfolio.fromCards(cards);
});
