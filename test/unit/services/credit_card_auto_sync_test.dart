import 'package:credit_card_manager/models/financial_models.dart';
import 'package:credit_card_manager/services/auto_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutoSyncService Credit Card Payment Filter & Deduplication', () {
    test('strictly identifies credit card payment/spend messages', () {
      const validCcSpend =
          'INR 1,280.00 spent on your HDFC Bank Credit Card ending 5168 at Swiggy Instamart on 17-Nov-2026.';
      expect(
        AutoSyncService.isCreditCardPaymentMessage(
          validCcSpend,
          sender: 'VM-HDFCBK',
        ),
        isTrue,
      );

      const validCcPurchase =
          'Dear Customer, your ICICI Bank Credit Card ending 8824 has been used for purchase of INR 2,499.00 at Amazon India.';
      expect(
        AutoSyncService.isCreditCardPaymentMessage(
          validCcPurchase,
          sender: 'AD-ICICIB',
        ),
        isTrue,
      );

      const validSbiCc =
          'Txn of INR 649.00 on SBI Credit Card ending 3011 at Netflix India on 15-Nov-2026.';
      expect(
        AutoSyncService.isCreditCardPaymentMessage(
          validSbiCc,
          sender: 'CP-SBICRD',
        ),
        isTrue,
      );
    });

    test('filters out bill payment reminders (no need to read that)', () {
      const reminder1 =
          'Payment Due Reminder: Total amount due on your HDFC Bank Credit Card ending 5168 is Rs 68,450.00. Due date is 01-Dec-2026. Please pay your bill to avoid late fee.';
      expect(AutoSyncService.isBillPaymentReminder(reminder1), isTrue);
      expect(
        AutoSyncService.isCreditCardPaymentMessage(
          reminder1,
          sender: 'VM-HDFCBK',
        ),
        isFalse,
      );

      const reminder2 =
          'Bill generated for ICICI Bank Credit Card xx8824. Minimum amount due: INR 1,200.00, Total due: INR 24,150.00. Due date: 28-Nov-2026.';
      expect(AutoSyncService.isBillPaymentReminder(reminder2), isTrue);
      expect(
        AutoSyncService.isCreditCardPaymentMessage(
          reminder2,
          sender: 'AD-ICICIB',
        ),
        isFalse,
      );

      const reminder3 =
          'Reminder: Your SBI Card statement generated. Min amount due Rs 500 is due on 25-Nov-2026. Please pay.';
      expect(AutoSyncService.isBillPaymentReminder(reminder3), isTrue);
      expect(
        AutoSyncService.isCreditCardPaymentMessage(
          reminder3,
          sender: 'CP-SBICRD',
        ),
        isFalse,
      );
    });

    test('filters out debit cards, ATM cash withdrawals, and OTP messages', () {
      const debitCardMsg =
          'INR 2,500.00 debited from A/c xx9102 using Debit Card at HDFC ATM Bandra on 14-Nov-2026.';
      expect(
        AutoSyncService.isCreditCardPaymentMessage(
          debitCardMsg,
          sender: 'VM-HDFCBK',
        ),
        isFalse,
      );

      const otpMsg =
          '492019 is your One Time Password (OTP) for online payment. Do not share OTP with anyone.';
      expect(
        AutoSyncService.isCreditCardPaymentMessage(otpMsg, sender: 'VM-HDFCBK'),
        isFalse,
      );
    });

    test('deduplicates identical and duplicate messages', () {
      final now = DateTime.now();
      const body =
          'Alert: INR 1,280.00 spent on HDFC Bank Credit Card ending 5168 at Swiggy Instamart on 17-Nov-2026. Ref: SWIG-8842.';
      final fp1 = AutoSyncService.computeMessageFingerprint(
        body,
        'VM-HDFCBK',
        now,
      );
      final fp2 = AutoSyncService.computeMessageFingerprint(
        body,
        'VM-HDFCBK',
        now,
      );
      expect(fp1, equals(fp2));
    });

    test('autoDetectCardsAndSync adds detected cards with isNeedsCompletion = true', () async {
      final service = AutoSyncService();
      const profile = UserProfileModel(name: 'Arjun Sharma');

      final result = await service.autoDetectCardsAndSync(
        userProfile: profile,
        currentCards: const [],
      );

      expect(result.addedCards, isNotEmpty);
      expect(result.transactions, isNotEmpty);
      expect(result.billRemindersIgnored, greaterThan(0));
      expect(result.duplicatesIgnored, greaterThan(0));

      for (final card in result.addedCards) {
        expect(card.isNeedsCompletion, isTrue);
      }

      // Complete card setup
      final incompleteCard = result.addedCards.first;
      final completedCard = incompleteCard.copyWith(
        cardTier: 'HDFC Infinia Metal',
        cardNumber: '4532 8920 4421 5168',
        maskedNumber: '•••• 5168',
        isNeedsCompletion: false,
      );

      expect(completedCard.isNeedsCompletion, isFalse);
      expect(completedCard.cardTier, 'HDFC Infinia Metal');
      expect(completedCard.cardNumber, '4532 8920 4421 5168');
    });
  });
}
