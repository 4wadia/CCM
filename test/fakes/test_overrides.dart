import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/card_portfolio_summary.dart';
import 'package:credit_card_manager/domain/entities/cashback.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/domain/entities/import_job.dart';
import 'package:credit_card_manager/domain/entities/reward.dart';
import 'package:credit_card_manager/domain/entities/statement.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/domain/entities/transaction_category.dart';
import 'package:credit_card_manager/domain/services/analytics.dart';
import 'package:credit_card_manager/features/cards/presentation/providers/card_providers.dart';
import 'package:credit_card_manager/features/home/presentation/providers/home_providers.dart';
import 'package:credit_card_manager/features/rewards/presentation/providers/reward_providers.dart';
import 'package:credit_card_manager/features/settings/presentation/providers/settings_providers.dart';
import 'package:credit_card_manager/features/statements/presentation/providers/statement_providers.dart';
import 'package:credit_card_manager/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Provider scope that keeps widget tests off the encrypted database and
/// platform channels.
ProviderScope testProviderScope({
  required Widget child,
  List<CreditCard> cards = const <CreditCard>[],
  List<Bank> banks = const <Bank>[],
  List<CardTransaction> transactions = const <CardTransaction>[],
  List<TransactionCategory> categories = const <TransactionCategory>[],
  List<CashbackEntry> cashbackEntries = const <CashbackEntry>[],
  List<CashbackRule> cashbackRules = const <CashbackRule>[],
  List<RewardAccount> rewardAccounts = const <RewardAccount>[],
  List<Statement> statements = const <Statement>[],
  Map<String, List<StatementTransaction>> statementTransactions =
      const <String, List<StatementTransaction>>{},
  List<CardTransaction> cardRecentTransactions = const <CardTransaction>[],
  List<TransactionSource> transactionSources = const <TransactionSource>[],
  Map<String, RewardAccount?> rewardAccountForCard =
      const <String, RewardAccount?>{},
  List<ReviewItem> reviewItems = const <ReviewItem>[],
  List<ImportJob> importJobs = const <ImportJob>[],
  int reviewCount = 0,
  EmailAccount? emailAccount,
  bool gmailConfigured = false,
  bool smsSupported = false,
  bool smsPermission = false,
}) {
  final recent = transactions.take(5).toList(growable: false);
  final dashboard = HomeDashboard(
    portfolio: CardPortfolio.fromCards(cards),
    analytics: AnalyticsService.build(transactions: transactions, cards: cards),
    recentTransactions: recent,
    cashbackByCurrency: const <String, int>{},
    rewardAccounts: rewardAccounts,
    emailAccount: emailAccount,
    reviewCount: reviewCount,
  );
  return ProviderScope(
    overrides: [
      creditCardsProvider.overrideWith((ref) async => cards),
      knownBanksProvider.overrideWith((ref) async => banks),
      homeDashboardProvider.overrideWith((ref) async => dashboard),
      transactionsProvider.overrideWith((ref) async => transactions),
      transactionCountProvider.overrideWith((ref) async => transactions.length),
      recentTransactionsProvider.overrideWith((ref) async => recent),
      cardRecentTransactionsProvider.overrideWith(
        (ref, cardId) async =>
            cardRecentTransactions.where((tx) => tx.cardId == cardId).toList(),
      ),
      transactionSourcesProvider.overrideWith(
        (ref, transactionId) async => transactionSources
            .where((source) => source.transactionId == transactionId)
            .toList(),
      ),
      transactionCategoriesProvider.overrideWith((ref) async => categories),
      reviewItemsProvider.overrideWith((ref) async => reviewItems),
      reviewCountProvider.overrideWith((ref) async => reviewCount),
      cashbackEntriesProvider.overrideWith((ref) async => cashbackEntries),
      cashbackRulesProvider.overrideWith((ref) async => cashbackRules),
      rewardsOverviewProvider.overrideWith((ref) async => rewardAccounts),
      rewardAccountForCardProvider.overrideWith(
        (ref, cardId) async => rewardAccountForCard[cardId],
      ),
      statementsProvider.overrideWith((ref) async => statements),
      statementTransactionsProvider.overrideWith(
        (ref, statementId) async =>
            statementTransactions[statementId] ??
            const <StatementTransaction>[],
      ),
      importJobsProvider.overrideWith((ref) async => importJobs),
      gmailStatusProvider.overrideWith((ref) async => emailAccount),
      syncCheckpointProvider.overrideWith((ref) async => null),
      gmailConfiguredProvider.overrideWithValue(gmailConfigured),
      smsSupportedProvider.overrideWithValue(smsSupported),
      smsPermissionProvider.overrideWith((ref) async => smsPermission),
    ],
    child: child,
  );
}
