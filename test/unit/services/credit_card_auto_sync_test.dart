import 'package:credit_card_manager/domain/entities/sms_message.dart';
import 'package:credit_card_manager/integrations/sms/sms_platform.dart';
import 'package:credit_card_manager/models/financial_models.dart';
import 'package:credit_card_manager/services/auto_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSmsPlatform implements SmsPlatform {
  _FakeSmsPlatform(this.messages);

  final List<SmsMessage> messages;

  @override
  bool get isSupported => true;

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<bool> hasNotificationPermission() async => true;

  @override
  Future<bool> requestNotificationPermission() async => true;

  @override
  Future<List<SmsMessage>> readMessages({
    required DateTime from,
    DateTime? to,
    int limit = 500,
  }) async => messages;
}

List<SmsMessage> _inboxMessages() {
  final now = DateTime.now();
  return [
    SmsMessage(
      id: 'sms-1',
      sender: 'VM-HDFCBK',
      body: 'INR 480.00 spent on your HDFC Bank Credit Card ending 5168 at Starbucks Reserve on 18-Nov-2026.',
      receivedAt: now.subtract(const Duration(hours: 3)),
    ),
    SmsMessage(
      id: 'sms-2',
      sender: 'VM-HDFCBK',
      body: 'Alert: INR 1,280.00 spent on HDFC Bank Credit Card ending 5168 at Swiggy Instamart on 17-Nov-2026. Ref: SWIG-8842.',
      receivedAt: now.subtract(const Duration(days: 1)),
    ),
    // Exact duplicate of sms-2; must be deduplicated.
    SmsMessage(
      id: 'sms-3',
      sender: 'VM-HDFCBK',
      body: 'Alert: INR 1,280.00 spent on HDFC Bank Credit Card ending 5168 at Swiggy Instamart on 17-Nov-2026. Ref: SWIG-8842.',
      receivedAt: now.subtract(const Duration(days: 1)),
    ),
    // Bill reminder; must be filtered out.
    SmsMessage(
      id: 'sms-4',
      sender: 'VM-HDFCBK',
      body: 'Payment Due Reminder: Total amount due on your HDFC Bank Credit Card ending 5168 is Rs 68,450.00. Due date is 01-Dec-2026. Please pay your bill to avoid late fee.',
      receivedAt: now.subtract(const Duration(days: 2)),
    ),
    SmsMessage(
      id: 'sms-5',
      sender: 'AD-ICICIB',
      body: 'Dear Customer, your ICICI Bank Credit Card ending 8824 has been used for purchase of INR 2,499.00 at Amazon India on 16-Nov-2026.',
      receivedAt: now.subtract(const Duration(days: 2)),
    ),
    // Bill generated reminder; must be filtered out.
    SmsMessage(
      id: 'sms-6',
      sender: 'AD-ICICIB',
      body: 'Bill generated for ICICI Bank Credit Card xx8824. Minimum amount due: INR 1,200.00, Total due: INR 24,150.00. Due date: 28-Nov-2026.',
      receivedAt: now.subtract(const Duration(days: 3)),
    ),
    SmsMessage(
      id: 'sms-7',
      sender: 'CP-SBICRD',
      body: 'Txn of INR 649.00 on SBI Credit Card ending 3011 at Netflix India on 15-Nov-2026. Info: NFLX-6610.',
      receivedAt: now.subtract(const Duration(days: 3)),
    ),
    // Debit card message; must be filtered out.
    SmsMessage(
      id: 'sms-8',
      sender: 'VM-HDFCBK',
      body: 'INR 2,500.00 debited from A/c xx9102 using Debit Card at HDFC ATM Bandra on 14-Nov-2026.',
      receivedAt: now.subtract(const Duration(days: 4)),
    ),
    // OTP message; must be filtered out.
    SmsMessage(
      id: 'sms-9',
      sender: 'VM-HDFCBK',
      body: '492019 is your One Time Password (OTP) for online payment. Do not share OTP with anyone.',
      receivedAt: now.subtract(const Duration(days: 5)),
    ),
    SmsMessage(
      id: 'sms-10',
      sender: 'AXISBK',
      body: 'INR 950.00 spent on your Axis Bank Credit Card ending 1928 at Apollo Pharmacy on 13-Nov-2026.',
      receivedAt: now.subtract(const Duration(days: 5)),
    ),
  ];
}

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

    test('starts empty when the inbox has no matching messages', () async {
      final service = AutoSyncService(smsPlatform: _FakeSmsPlatform(const []));
      const profile = UserProfileModel(name: '');

      final result = await service.autoDetectCardsAndSync(
        userProfile: profile,
        currentCards: const [],
      );

      expect(result.addedCards, isEmpty);
      expect(result.transactions, isEmpty);
      expect(result.totalScanned, 0);
      expect(result.readFromNativeSms, isFalse);
    });

    test(
      'detects only real SMS cards and never stores full numbers or CVV',
      () async {
        final service = AutoSyncService(
          smsPlatform: _FakeSmsPlatform(_inboxMessages()),
        );
        const profile = UserProfileModel(name: 'Test User');

        final result = await service.autoDetectCardsAndSync(
          userProfile: profile,
          currentCards: const [],
        );

        expect(result.addedCards, hasLength(4));
        expect(result.transactions, isNotEmpty);
        expect(result.billRemindersIgnored, greaterThan(0));
        expect(result.duplicatesIgnored, greaterThan(0));

        final banks = result.addedCards.map((card) => card.bankName).toSet();
        expect(
          banks,
          containsAll(<IndianBank>{
            IndianBank.hdfc,
            IndianBank.icici,
            IndianBank.sbi,
            IndianBank.axis,
          }),
        );

        for (final card in result.addedCards) {
          expect(card.isNeedsCompletion, isTrue);
          expect(card.limit, 0);
          expect(card.expiry, isEmpty);
          expect(card.maskedNumber, startsWith('•••• '));
          expect(card.maskedNumber.length, 9);
        }

        final hdfc = result.addedCards.firstWhere(
          (card) => card.bankName == IndianBank.hdfc,
        );
        expect(hdfc.lastFour, '5168');
        expect(hdfc.balance, closeTo(1760, 0.01));

        final completedCard = hdfc.copyWith(
          cardTier: 'HDFC Infinia Metal',
          maskedNumber: '•••• 5168',
          isNeedsCompletion: false,
        );

        expect(completedCard.isNeedsCompletion, isFalse);
        expect(completedCard.cardTier, 'HDFC Infinia Metal');
        expect(completedCard.lastFour, '5168');
      },
    );

    test('unknown bank messages fall back to the Other bank option', () async {
      final service = AutoSyncService(
        smsPlatform: _FakeSmsPlatform([
          SmsMessage(
            id: 'sms-unknown',
            sender: 'VM-NEWBANK',
            body: 'INR 100.00 spent on your Credit Card ending 1234 at Test Merchant on 18-Nov-2026.',
            receivedAt: DateTime.now(),
          ),
        ]),
      );

      final result = await service.autoDetectCardsAndSync(
        userProfile: const UserProfileModel(name: ''),
        currentCards: const [],
      );

      expect(result.addedCards, hasLength(1));
      expect(result.addedCards.single.bankName, IndianBank.other);
      expect(result.addedCards.single.lastFour, '1234');
    });
  });
}
