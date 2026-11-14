import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/cashback.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/domain/entities/import_job.dart';
import 'package:credit_card_manager/domain/entities/reward.dart';
import 'package:credit_card_manager/domain/entities/statement.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/domain/entities/transaction_category.dart';
import 'package:credit_card_manager/features/cards/presentation/pages/cards_page.dart';
import 'package:credit_card_manager/features/rewards/presentation/pages/rewards_page.dart';
import 'package:credit_card_manager/features/settings/presentation/pages/settings_page.dart';
import 'package:credit_card_manager/features/statements/presentation/pages/statements_page.dart';
import 'package:credit_card_manager/features/transactions/presentation/pages/transactions_page.dart';
import 'package:credit_card_manager/shared/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../fakes/test_overrides.dart';

void main() {
  final now = DateTime.utc(2026, 11, 5);

  Bank bank() => Bank(
    id: 'bank_1',
    displayName: 'Alpha Bank',
    countryCode: 'IN',
    region: 'India',
    createdAt: now,
    updatedAt: now,
  );

  CreditCard card({int outstandingMinor = 100000, int limitMinor = 1000000}) {
    return CreditCard(
      id: 'card_1',
      bankId: 'bank_1',
      displayName: 'Everyday card',
      network: CardNetwork.visa,
      lastFour: '4242',
      creditLimitMinor: limitMinor,
      currentOutstandingMinor: outstandingMinor,
      currencyCode: 'INR',
      statementDay: 5,
      dueDay: 25,
      rewardProgramme: 'Points',
      status: CardStatus.active,
      createdAt: now,
      updatedAt: now,
    );
  }

  EmailAccount emailAccount() => EmailAccount(
    id: 'email_1',
    provider: 'gmail',
    emailAddress: 'reader@example.com',
    secureTokenReference: 'secure_ref',
    status: 'connected',
    syncEnabled: true,
    connectedAt: now,
    lastSuccessfulSync: now,
    createdAt: now,
    updatedAt: now,
  );

  CardTransaction transaction({
    String id = 'tx_1',
    TransactionStatus status = TransactionStatus.posted,
    int amountMinor = 125050,
    String merchant = 'Coffee House',
  }) {
    return CardTransaction(
      id: id,
      cardId: 'card_1',
      bankId: 'bank_1',
      merchantOriginal: merchant,
      merchantNormalized: merchant.toLowerCase(),
      amountMinor: amountMinor,
      currencyCode: 'INR',
      transactionDate: now,
      transactionType: TransactionType.purchase,
      categoryId: 'cat_dining',
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  const categories = <TransactionCategory>[
    TransactionCategory(
      id: 'cat_dining',
      name: 'Dining',
      isSystemCategory: false,
    ),
  ];

  Widget page(Widget child, {Widget Function(Widget)? scope}) {
    return (scope ?? (widget) => widget)(
      MaterialApp(theme: AppTheme.light(), home: child),
    );
  }

  testWidgets(
    'transactions page shows review banner, list, filters, and detail',
    (tester) async {
      final tx = transaction();
      final review = ReviewItem(
        id: 'review_1',
        entityType: 'transaction',
        entityId: tx.id,
        reasonCode: 'card_ambiguous',
        userMessage: 'Assign a card.',
        sourceType: 'sms',
        sourceReference: 'sms:1',
        status: ReviewStatus.open,
        createdAt: now,
      );
      final source = TransactionSource(
        id: 'source_1',
        transactionId: tx.id,
        sourceType: TransactionSourceType.sms,
        sourceReference: 'sms:1',
        sourceDate: now,
        originalDescription: 'Coffee House',
        matchStatus: SourceMatchStatus.created,
        createdAt: now,
      );

      await tester.pumpWidget(
        page(
          const TransactionsPage(),
          scope: (child) => testProviderScope(
            cards: [card()],
            transactions: [tx],
            categories: categories,
            reviewCount: 1,
            reviewItems: [review],
            transactionSources: [source],
            child: child,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('transactions-page')), findsOneWidget);
      expect(find.text('1 item needs review'), findsOneWidget);
      expect(find.text('Coffee House'), findsOneWidget);
      expect(find.text('INR 1,250.50'), findsOneWidget);
      expect(find.text('1 transaction'), findsOneWidget);

      await tester.tap(find.byKey(const Key('transaction-filter')));
      await tester.pumpAndSettle();
      expect(find.text('Filter transactions'), findsOneWidget);
      await tester.drag(
        find.text('Filter transactions'),
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();
      expect(find.text('Needs review only'), findsOneWidget);
      expect(find.text('Unassigned card only'), findsOneWidget);
      expect(find.text('Apply filters'), findsOneWidget);
      await tester.tap(find.text('Apply filters'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Coffee House'));
      await tester.pumpAndSettle();
      expect(find.text('Sources'), findsOneWidget);
      expect(find.text('SMS'), findsOneWidget);
      expect(find.text('Coffee House'), findsWidgets);
      expect(find.text('Assign card'), findsOneWidget);
      expect(find.text('Needs review'), findsOneWidget);
    },
  );

  testWidgets('review banner opens the review queue', (tester) async {
    final tx = transaction(status: TransactionStatus.needsReview);
    final review = ReviewItem(
      id: 'review_1',
      entityType: 'transaction',
      entityId: tx.id,
      reasonCode: 'card_unmatched',
      userMessage: 'No card could be matched to this record.',
      sourceType: 'sms',
      status: ReviewStatus.open,
      createdAt: now,
    );

    await tester.pumpWidget(
      page(
        const TransactionsPage(),
        scope: (child) => testProviderScope(
          cards: [card()],
          transactions: [tx],
          categories: categories,
          reviewCount: 1,
          reviewItems: [review],
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('1 item needs review'));
    await tester.pumpAndSettle();

    expect(find.text('Review queue'), findsOneWidget);
    expect(find.text('Card could not be matched'), findsOneWidget);
    expect(find.text('Assign card'), findsOneWidget);
    expect(find.text('Resolve'), findsOneWidget);
    expect(find.text('Dismiss'), findsOneWidget);
  });

  testWidgets('statements page lists statements and opens extracted rows', (
    tester,
  ) async {
    final statement = Statement(
      id: 'statement_1',
      cardId: 'card_1',
      bankId: 'bank_1',
      statementPeriodStart: DateTime(2026, 10, 6),
      statementPeriodEnd: DateTime(2026, 11, 5),
      statementDate: now,
      paymentDueDate: DateTime(2026, 11, 25),
      previousBalanceMinor: 100000,
      totalDueMinor: 250000,
      minimumDueMinor: 25000,
      currencyCode: 'INR',
      encryptedFilePath: 'opaque.ccmenc',
      fileHash: 'hash',
      processingStatus: StatementProcessingStatus.needsReview,
      parserId: 'generic-statement',
      parserVersion: '1',
      createdAt: now,
      updatedAt: now,
    );
    final extracted = StatementTransaction(
      id: 'stx_1',
      statementId: statement.id,
      description: 'Coffee House',
      amountMinor: 125050,
      currencyCode: 'INR',
      transactionDate: now,
      transactionType: TransactionType.purchase,
      matchStatus: StatementMatchStatus.matched,
      createdAt: now,
    );

    await tester.pumpWidget(
      page(
        const StatementsPage(),
        scope: (child) => testProviderScope(
          cards: [card()],
          banks: [bank()],
          statements: [statement],
          statementTransactions: {
            statement.id: [extracted],
          },
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('statements-page')), findsOneWidget);
    expect(find.text('Everyday card •••• 4242'), findsOneWidget);
    expect(find.text('Needs review'), findsOneWidget);
    expect(find.text('INR 2,500.00'), findsOneWidget);
    expect(find.text('INR 250.00'), findsOneWidget);

    await tester.tap(find.text('Everyday card •••• 4242'));
    await tester.pumpAndSettle();

    expect(find.text('Statement details'), findsOneWidget);
    expect(find.text('Statement transactions'), findsOneWidget);
    expect(find.text('Coffee House'), findsOneWidget);
    expect(find.text('INR 1,250.50'), findsOneWidget);
    expect(
      find.textContaining('This statement has unresolved review items'),
      findsOneWidget,
    );
  });

  testWidgets('rewards page shows cashback, accounts, and declarative rules', (
    tester,
  ) async {
    final entry = CashbackEntry(
      id: 'cashback_1',
      cardId: 'card_1',
      amountMinor: 2500,
      currencyCode: 'INR',
      status: CashbackStatus.pending,
      earnedAt: now,
      createdAt: now,
    );
    final rule = CashbackRule(
      id: 'rule_1',
      cardId: 'card_1',
      kind: CashbackRuleKind.percentage,
      rateBasisPoints: 200,
      monthlyCapMinor: 5000,
      currencyCode: 'INR',
      createdAt: now,
      updatedAt: now,
    );
    final account = RewardAccount(
      id: 'account_1',
      cardId: 'card_1',
      programmeName: 'Points',
      currentPoints: 1500,
      estimatedValueMinor: 37500,
      currencyCode: 'INR',
      updatedAt: now,
    );

    await tester.pumpWidget(
      page(
        const RewardsPage(),
        scope: (child) => testProviderScope(
          cards: [card()],
          cashbackEntries: [entry],
          cashbackRules: [rule],
          rewardAccounts: [account],
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('rewards-page')), findsOneWidget);
    expect(find.text('Cashback'), findsOneWidget);
    expect(find.text('INR 25.00'), findsWidgets);
    expect(find.text('1 entry across 1 currency'), findsOneWidget);
    expect(find.text('Points'), findsWidgets);
    expect(find.text('1500'), findsOneWidget);
    expect(find.text('Estimated value: INR 375.00'), findsOneWidget);
    expect(find.text('2% cashback'), findsOneWidget);
    expect(find.text('Monthly cap INR 50.00'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Recent cashback entries'), 300);
    expect(find.text('Recent cashback entries'), findsOneWidget);
  });

  testWidgets('account page is compact and explains platform limits', (
    tester,
  ) async {
    await tester.pumpWidget(
      page(
        const SettingsPage(),
        scope: (child) => testProviderScope(
          gmailConfigured: false,
          smsSupported: false,
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings-page')), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Gmail is not configured in this build.'), findsOneWidget);
    expect(
      find.textContaining('SMS import is unavailable on this platform'),
      findsOneWidget,
    );
    expect(find.text('Import PDF statement'), findsOneWidget);
    expect(find.text('Backup, restore & export'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('Encrypted on this device'),
      300,
    );
    expect(find.textContaining('Encrypted on this device'), findsOneWidget);
    expect(find.text('Local-first by design'), findsNothing);
    expect(find.text('Import history'), findsNothing);
    expect(find.text('Danger zone'), findsNothing);
  });

  testWidgets('data options sheet keeps backup and wipe behind one row', (
    tester,
  ) async {
    await tester.pumpWidget(
      page(
        const SettingsPage(),
        scope: (child) => testProviderScope(
          gmailConfigured: false,
          smsSupported: false,
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Backup, restore & export'));
    await tester.pumpAndSettle();

    expect(find.text('Create encrypted backup'), findsOneWidget);
    expect(find.textContaining('Argon2id'), findsOneWidget);
    expect(find.text('Restore from backup'), findsOneWidget);
    expect(find.text('Export transactions as CSV'), findsOneWidget);
    expect(find.text('Delete all local data'), findsOneWidget);
  });

  testWidgets('account page shows the connected Gmail address', (tester) async {
    final account = emailAccount();
    await tester.pumpWidget(
      page(
        const SettingsPage(),
        scope: (child) => testProviderScope(
          gmailConfigured: true,
          emailAccount: account,
          cards: [card()],
          smsSupported: false,
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Connected Gmail'), findsOneWidget);
    expect(find.text(account.emailAddress), findsOneWidget);
    expect(find.text('Fetch card emails'), findsOneWidget);
    expect(find.text('Read statements'), findsOneWidget);
  });

  testWidgets('fetch card SMS shows an error when no cards exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      page(
        const SettingsPage(),
        scope: (child) => testProviderScope(
          gmailConfigured: false,
          smsSupported: true,
          smsPermission: true,
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fetch card SMS'));
    await tester.pumpAndSettle();

    expect(
      find.text('Add a credit card before fetching messages.'),
      findsOneWidget,
    );
  });

  testWidgets('account page shows Android SMS controls when supported', (
    tester,
  ) async {
    await tester.pumpWidget(
      page(
        const SettingsPage(),
        scope: (child) => testProviderScope(
          gmailConfigured: false,
          smsSupported: true,
          smsPermission: false,
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Android SMS alerts'), findsOneWidget);
    expect(find.text('Grant permission'), findsOneWidget);
    expect(find.text('Fetch card SMS'), findsOneWidget);
    expect(find.text('Read transactions'), findsOneWidget);
    expect(find.text('Clear imported SMS'), findsOneWidget);
    expect(
      find.textContaining('Permission is required before any message'),
      findsOneWidget,
    );
  });

  testWidgets('card detail shows metrics, recent activity, and navigation', (
    tester,
  ) async {
    final tx = transaction();
    final account = RewardAccount(
      id: 'account_1',
      cardId: 'card_1',
      programmeName: 'Points',
      currentPoints: 500,
      updatedAt: now,
    );

    await tester.pumpWidget(
      page(
        const CardsPage(),
        scope: (child) => testProviderScope(
          cards: [card()],
          banks: [bank()],
          cardRecentTransactions: [tx],
          rewardAccountForCard: {'card_1': account},
          child: child,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Everyday card'));
    await tester.pumpAndSettle();

    expect(find.text('Limit'), findsWidgets);
    expect(find.text('INR 10,000.00'), findsWidgets);
    expect(find.text('Outstanding'), findsWidgets);
    expect(find.text('INR 1,000.00'), findsWidgets);
    expect(find.text('Available'), findsWidgets);
    expect(find.text('INR 9,000.00'), findsWidgets);
    expect(find.text('Utilisation 10%'), findsWidgets);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Statements'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Recent transactions'), findsOneWidget);
    expect(find.text('Coffee House'), findsOneWidget);
    expect(find.text('Points: 500 points'), findsOneWidget);
    expect(find.text('Statement day: 5 · Due day: 25'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Reward programme: Points'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Reward programme: Points'), findsOneWidget);
  });
}
