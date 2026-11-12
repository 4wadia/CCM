import 'package:credit_card_manager/domain/entities/sms_message.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/integrations/sms/sms_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = GenericSmsParser();
  final receivedAt = DateTime.utc(2026, 11, 5, 12);

  SmsMessage sms(String body) => SmsMessage(
    id: 'sms_1',
    sender: 'HDFCBK',
    body: body,
    receivedAt: receivedAt,
  );

  test('parses a purchase alert with amount, merchant, date, and card', () {
    final records = parser.parse(
      sms(
        'INR 1,250.50 spent at Coffee House on 05/11/2026 using card ending '
        '4242.',
      ),
      bankHint: 'HDFC Bank',
    );

    expect(records, hasLength(1));
    final record = records.single;
    expect(record.amountMinor, 125050);
    expect(record.currencyCode, 'INR');
    expect(record.transactionType, TransactionType.purchase);
    expect(record.transactionDate, DateTime(2026, 11, 5));
    expect(record.merchant, 'Coffee House');
    expect(record.cardLastFour, '4242');
    expect(record.bankHint, 'HDFC Bank');
    expect(record.confidence, SourceConfidence.high);
    expect(record.sourceReference, 'sms:sms_1');
    expect(record.signedAmountMinor, 125050);
  });

  test('parses an amount that appears before the currency code', () {
    final records = parser.parse(
      sms('Spent 2,000.00 INR at Book Store on 05-11-2026.'),
    );

    expect(records.single.amountMinor, 200000);
    expect(records.single.transactionDate, DateTime(2026, 11, 5));
    expect(records.single.cardLastFour, isNull);
    expect(records.single.confidence, SourceConfidence.medium);
  });

  test('uses the message timestamp when the body has no date', () {
    final records = parser.parse(
      sms('INR 99.00 spent at Corner Cafe using card xx4242.'),
    );

    expect(records.single.transactionDate, DateTime(2026, 11, 5));
    expect(records.single.merchant, 'Corner Cafe');
  });

  test('ignores one-time passwords and non-transactional messages', () {
    expect(
      parser.parse(sms('123456 is your OTP. Do not share it with anyone.')),
      isEmpty,
    );
    expect(
      parser.parse(sms('Your statement is ready. Log in to view it.')),
      isEmpty,
    );
  });

  test('keeps a declined alert but marks it failed', () {
    final records = parser.parse(
      sms('INR 500.00 spent at Fuel Station was declined on 05/11/2026.'),
    );

    final record = records.single;
    expect(record.transactionType, TransactionType.purchase);
    expect(record.status, TransactionStatus.failed);
    expect(record.notes, contains('failed or declined'));
  });

  test('marks refunds, payments, cash advances, and fees', () {
    final refund = parser.parse(
      sms('INR 500.00 refunded at Coffee House on 05/11/2026.'),
    );
    expect(refund.single.transactionType, TransactionType.refund);
    expect(refund.single.signedAmountMinor, -50000);

    final payment = parser.parse(
      sms('Payment of INR 2,000.00 received on 05/11/2026.'),
    );
    expect(payment.single.transactionType, TransactionType.payment);
    expect(payment.single.signedAmountMinor, -200000);

    final cash = parser.parse(
      sms('INR 5,000.00 withdrawn at ATM on 05/11/2026.'),
    );
    expect(cash.single.transactionType, TransactionType.cashAdvance);

    final fee = parser.parse(
      sms('INR 500.00 annual fee charged on 05/11/2026.'),
    );
    expect(fee.single.transactionType, TransactionType.fee);
  });

  test('ignores alerts without a positive amount', () {
    expect(
      parser.parse(sms('INR 0.00 spent at Test Merchant on 05/11/2026.')),
      isEmpty,
    );
    expect(parser.parse(sms('A purchase was made at Test Merchant.')), isEmpty);
    expect(parser.parse(sms('   ')), isEmpty);
  });
}
