import 'dart:ui';

import 'package:credit_card_manager/models/financial_models.dart';
import 'package:credit_card_manager/screens/manage_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _card = CreditCardModel(
  id: 'card-1',
  bankName: IndianBank.hdfc,
  holderName: 'TEST USER',
  maskedNumber: '•••• 1234',
  balance: 25000,
  limit: 100000,
  brand: CardSupplier.visa,
  cardTier: 'HDFC Infinia Metal',
  dailyLimit: 25000,
);

TransactionModel _tx({
  required String id,
  required String title,
  required double amount,
  required String last4,
  required IndianBank bank,
  TransactionType type = TransactionType.expense,
}) {
  return TransactionModel(
    id: id,
    title: title,
    category: 'General',
    amount: amount,
    type: type,
    date: 'Nov 18, 2026',
    time: '10:30',
    cardLast4: last4,
    cardBank: bank,
    cardBrand: CardSupplier.visa,
    merchant: title,
    referenceId: 'REF-$id',
  );
}

void main() {
  testWidgets('shows only real transactions for the managed card', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 892));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ManageCardScreen(
            card: _card,
            transactions: [
              _tx(
                id: 'tx-1',
                title: 'Amazon India',
                amount: 1500,
                last4: '1234',
                bank: IndianBank.hdfc,
              ),
              _tx(
                id: 'tx-2',
                title: 'Other card purchase',
                amount: 480,
                last4: '9999',
                bank: IndianBank.hdfc,
              ),
              _tx(
                id: 'tx-3',
                title: 'Wrong bank purchase',
                amount: 999,
                last4: '1234',
                bank: IndianBank.icici,
              ),
            ],
            onBack: () {},
            isDarkMode: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Amazon India'), findsOneWidget);
    expect(find.text('Other card purchase'), findsNothing);
    expect(find.text('Wrong bank purchase'), findsNothing);

    // The old screen fabricated these values for every card.
    expect(find.text('Starbucks Reserve'), findsNothing);
    expect(find.text('Swiggy Instamart'), findsNothing);
    expect(find.text('Netflix India'), findsNothing);
    expect(find.textContaining('CASHBACK'), findsNothing);
    expect(find.textContaining('REWARDS'), findsNothing);
    expect(find.text('25%'), findsOneWidget);
  });

  testWidgets('shows an honest empty state when a card has no transactions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 892));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ManageCardScreen(card: _card, onBack: () {}, isDarkMode: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No transactions for this card yet'), findsOneWidget);
    expect(find.text('Starbucks Reserve'), findsNothing);
  });

  testWidgets('confirms deletion and invokes the callback', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 892));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    CreditCardModel? deleted;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ManageCardScreen(
            card: _card,
            transactions: [
              _tx(
                id: 'tx-1',
                title: 'Amazon India',
                amount: 1500,
                last4: '1234',
                bank: IndianBank.hdfc,
              ),
            ],
            onBack: () {},
            onDeleteCard: (card) => deleted = card,
            isDarkMode: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('delete-card-button')));
    await tester.pumpAndSettle();
    expect(find.text('Remove HDFC Infinia Metal?'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('confirm-delete-card')));
    await tester.pumpAndSettle();

    expect(deleted?.id, 'card-1');
  });
}
