import 'package:credit_card_manager/app/providers.dart';
import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/features/cards/presentation/pages/cards_page.dart';
import 'package:credit_card_manager/features/cards/presentation/providers/card_providers.dart';
import 'package:credit_card_manager/features/home/presentation/pages/home_page.dart';
import 'package:credit_card_manager/shared/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../fakes/fake_repositories.dart';
import '../../fakes/test_overrides.dart';

void main() {
  final now = DateTime.utc(2026, 11, 5);

  CreditCard card({
    required String id,
    required String currencyCode,
    required int limitMinor,
    int outstandingMinor = 0,
    CardStatus status = CardStatus.active,
    String? displayName,
  }) {
    return CreditCard(
      id: id,
      bankId: 'bank_$id',
      displayName: displayName ?? 'Card $id',
      network: CardNetwork.visa,
      lastFour: '4242',
      creditLimitMinor: limitMinor,
      currentOutstandingMinor: outstandingMinor,
      currencyCode: currencyCode,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  Bank bank({String id = 'bank_test'}) => Bank(
    id: id,
    displayName: 'Test Bank',
    countryCode: 'US',
    region: 'US',
    createdAt: now,
    updatedAt: now,
  );

  Widget home(List<CreditCard> cards, {EmailAccount? emailAccount}) {
    return testProviderScope(
      cards: cards,
      emailAccount: emailAccount,
      child: MaterialApp(theme: AppTheme.light(), home: const HomePage()),
    );
  }

  EmailAccount connectedEmail() => EmailAccount(
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

  Widget cardsPage({
    required List<CreditCard> cards,
    required FakeCreditCardRepository cardRepository,
    required FakeBankRepository bankRepository,
  }) {
    return ProviderScope(
      overrides: [
        creditCardRepositoryProvider.overrideWith(
          (ref) async => cardRepository,
        ),
        bankRepositoryProvider.overrideWith((ref) async => bankRepository),
        creditCardsProvider.overrideWith(
          (ref) async => cardRepository.getAll(includeArchived: true),
        ),
        knownBanksProvider.overrideWith((ref) async => bankRepository.getAll()),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: const CardsPage()),
    );
  }

  Finder amountIn(String key, String amount) {
    return find.descendant(
      of: find.byKey(Key(key)),
      matching: find.text(amount),
    );
  }

  testWidgets('home shows separate currency totals and per-card summaries', (
    tester,
  ) async {
    await tester.pumpWidget(
      home([
        card(
          id: 'usd1',
          currencyCode: 'USD',
          limitMinor: 125050,
          outstandingMinor: 25000,
        ),
        card(
          id: 'usd2',
          currencyCode: 'USD',
          limitMinor: 50000,
          outstandingMinor: 0,
        ),
        card(
          id: 'jpy',
          currencyCode: 'JPY',
          limitMinor: 200000,
          outstandingMinor: 20000,
        ),
        card(
          id: 'archived',
          currencyCode: 'USD',
          limitMinor: 90000,
          status: CardStatus.archived,
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(amountIn('limit-USD', 'USD 1,750.50'), findsOneWidget);
    expect(amountIn('outstanding-USD', 'USD 250.00'), findsOneWidget);
    expect(amountIn('available-USD', 'USD 1,500.50'), findsOneWidget);
    expect(amountIn('limit-JPY', 'JPY 200,000'), findsOneWidget);
    expect(amountIn('outstanding-JPY', 'JPY 20,000'), findsOneWidget);
    expect(amountIn('available-JPY', 'JPY 180,000'), findsOneWidget);
    expect(find.text('2 active cards'), findsOneWidget);
    expect(find.text('Credit limits'), findsOneWidget);
    expect(find.text('Utilisation 14.3%'), findsOneWidget);
    expect(find.text('Utilisation 10%'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('more than one currency'),
      300,
    );
    expect(find.textContaining('more than one currency'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('card-summary-usd1')),
      200,
    );
    expect(find.byKey(const Key('card-summary-usd1')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('card-summary-jpy')),
      200,
    );
    expect(find.byKey(const Key('card-summary-jpy')), findsOneWidget);
  });

  testWidgets('home omits utilisation when a currency limit is zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      home([card(id: 'zero', currencyCode: 'USD', limitMinor: 0)]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Utilisation unavailable (zero limit)'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('card-summary-zero')),
      300,
    );
    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('home shows the connected Gmail address without Account', (
    tester,
  ) async {
    final account = connectedEmail();
    await tester.pumpWidget(
      home([
        card(id: 'usd1', currencyCode: 'USD', limitMinor: 100000),
      ], emailAccount: account),
    );
    await tester.pumpAndSettle();

    expect(find.text('Connected Gmail'), findsOneWidget);
    expect(find.text(account.emailAddress), findsOneWidget);
    expect(find.text('Read statements'), findsOneWidget);
    expect(find.text('Credit-card statements only'), findsNothing);
    expect(find.textContaining('Credit-card statements only'), findsOneWidget);
  });

  testWidgets('cards page exposes only last-four identity fields', (
    tester,
  ) async {
    final cardRepository = FakeCreditCardRepository();
    final bankRepository = FakeBankRepository();

    await tester.pumpWidget(
      cardsPage(
        cards: [],
        cardRepository: cardRepository,
        bankRepository: bankRepository,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('empty-add-card')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('card-last-four')), findsOneWidget);
    expect(find.byKey(const Key('card-limit')), findsOneWidget);
    expect(find.byKey(const Key('card-outstanding')), findsOneWidget);
    expect(find.text('Full card number'), findsNothing);
    expect(find.text('CVV'), findsNothing);
    expect(find.text('PIN'), findsNothing);
  });

  testWidgets('add form validates required fields before saving', (
    tester,
  ) async {
    final cardRepository = FakeCreditCardRepository();
    final bankRepository = FakeBankRepository();

    await tester.pumpWidget(
      cardsPage(
        cards: [],
        cardRepository: cardRepository,
        bankRepository: bankRepository,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('empty-add-card')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('save-card')));
    await tester.tap(find.byKey(const Key('save-card')));
    await tester.pumpAndSettle();

    expect(cardRepository.cards, isEmpty);
    expect(find.text('Required'), findsNWidgets(2));
    expect(find.text('Enter exactly four digits'), findsOneWidget);
    expect(
      find.text('Enter a positive amount with valid currency precision'),
      findsOneWidget,
    );
  });

  testWidgets('add form saves a card with an outstanding balance', (
    tester,
  ) async {
    final cardRepository = FakeCreditCardRepository();
    final bankRepository = FakeBankRepository();

    await tester.pumpWidget(
      cardsPage(
        cards: [],
        cardRepository: cardRepository,
        bankRepository: bankRepository,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('empty-add-card')));
    await tester.pumpAndSettle();

    Future<void> enter(String key, String value) async {
      final finder = find.byKey(Key(key));
      await tester.ensureVisible(finder);
      await tester.enterText(finder, value);
    }

    await enter('card-issuer', 'Test Bank');
    await enter('card-name', 'Everyday card');
    await enter('card-last-four', '4242');
    await enter('card-limit', '1250.50');
    await enter('card-outstanding', '250.00');
    await tester.ensureVisible(find.byKey(const Key('save-card')));
    await tester.tap(find.byKey(const Key('save-card')));
    await tester.pumpAndSettle();

    expect(cardRepository.cards, hasLength(1));
    final saved = cardRepository.cards.values.single;
    expect(saved.displayName, 'Everyday card');
    expect(saved.lastFour, '4242');
    expect(saved.creditLimitMinor, 125050);
    expect(saved.currentOutstandingMinor, 25000);
    expect(saved.currencyCode, 'USD');
    expect(find.text('USD 1,250.50'), findsOneWidget);
    expect(find.text('USD 250.00'), findsOneWidget);
    expect(find.text('USD 1,000.50'), findsOneWidget);
  });

  testWidgets('edit form prefills and updates the reconciled balance', (
    tester,
  ) async {
    final cardRepository = FakeCreditCardRepository();
    final bankRepository = FakeBankRepository();
    final existing = card(
      id: 'existing',
      currencyCode: 'USD',
      limitMinor: 125050,
      outstandingMinor: 25000,
      displayName: 'Everyday card',
    );
    await bankRepository.upsert(bank(id: existing.bankId));
    await cardRepository.upsert(existing);

    await tester.pumpWidget(
      cardsPage(
        cards: [existing],
        cardRepository: cardRepository,
        bankRepository: bankRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Card actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('1250.50'), findsOneWidget);
    expect(find.text('250.00'), findsOneWidget);

    final nameFinder = find.byKey(const Key('card-name'));
    await tester.ensureVisible(nameFinder);
    await tester.enterText(nameFinder, 'Renamed card');
    final outstandingFinder = find.byKey(const Key('card-outstanding'));
    await tester.ensureVisible(outstandingFinder);
    await tester.enterText(outstandingFinder, '300.00');
    await tester.ensureVisible(find.byKey(const Key('save-card')));
    await tester.tap(find.byKey(const Key('save-card')));
    await tester.pumpAndSettle();

    final updated = cardRepository.cards['existing']!;
    expect(updated.displayName, 'Renamed card');
    expect(updated.currentOutstandingMinor, 30000);
    expect(updated.creditLimitMinor, 125050);
    expect(cardRepository.cards, hasLength(1));
  });

  testWidgets('archive asks for confirmation and keeps the history', (
    tester,
  ) async {
    final cardRepository = FakeCreditCardRepository();
    final bankRepository = FakeBankRepository();
    final existing = card(
      id: 'existing',
      currencyCode: 'USD',
      limitMinor: 125050,
      displayName: 'Everyday card',
    );
    await bankRepository.upsert(bank(id: existing.bankId));
    await cardRepository.upsert(existing);

    await tester.pumpWidget(
      cardsPage(
        cards: [existing],
        cardRepository: cardRepository,
        bankRepository: bankRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Card actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archive'));
    await tester.pumpAndSettle();
    expect(find.text('Archive this card?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(cardRepository.archiveCalls, 0);
    expect(cardRepository.cards['existing']!.status, CardStatus.active);

    await tester.tap(find.byTooltip('Card actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archive'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-archive')));
    await tester.pumpAndSettle();

    expect(cardRepository.archiveCalls, 1);
    expect(cardRepository.cards['existing']!.status, CardStatus.archived);
    expect(find.text('Archived and closed'), findsOneWidget);
  });
}
