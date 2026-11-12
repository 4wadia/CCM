import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/integrations/pdf/statement_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = GenericStatementParser();
  final fallbackDate = DateTime(2026, 11, 5);

  const statement = '''
HDFC Bank Credit Card Statement
Statement Date: 05/11/2026
Payment Due Date: 25/11/2026
Statement Period: 06/10/2026 to 05/11/2026
Card ending 4242
Currency: INR
Previous Balance 10,000.00
Total Amount Due 15,250.50
Minimum Amount Due 1,525.05
05/10/2026 Coffee House 1,250.50
07/10/2026 Amazon Purchase 2,000.00
10/10/2026 Refund 500.00 Cr
12/10/2026 Annual Fee 750.00 DR
''';

  test('detects parseable statement text', () {
    expect(parser.canParse(statement), isTrue);
    expect(parser.canParse(''), isFalse);
    expect(parser.canParse('No amounts here'), isFalse);
  });

  test('extracts metadata and table-like transaction lines', () {
    final parsed = parser.parse(
      text: statement,
      fallbackDate: fallbackDate,
      defaultCurrency: 'INR',
    );

    expect(parsed.currencyCode, 'INR');
    expect(parsed.cardLastFour, '4242');
    expect(parsed.statementDate, DateTime(2026, 11, 5));
    expect(parsed.paymentDueDate, DateTime(2026, 11, 25));
    expect(parsed.periodStart, DateTime(2026, 10, 6));
    expect(parsed.periodEnd, DateTime(2026, 11, 5));
    expect(parsed.previousBalanceMinor, 1000000);
    expect(parsed.totalDueMinor, 1525050);
    expect(parsed.minimumDueMinor, 152505);
    expect(parsed.parserId, 'generic-statement');
    expect(parsed.parserVersion, '1');

    expect(parsed.transactions, hasLength(4));
    final coffee = parsed.transactions.first;
    expect(coffee.description, 'Coffee House');
    expect(coffee.amountMinor, 125050);
    expect(coffee.transactionDate, DateTime(2026, 10, 5));
    expect(coffee.transactionType, TransactionType.purchase);
    expect(coffee.merchant, 'coffee house');

    expect(parsed.transactions[2].transactionType, TransactionType.refund);
    expect(parsed.transactions[3].transactionType, TransactionType.fee);
  });

  test('falls back to the supplied date for undated rows', () {
    final parsed = parser.parse(
      text: 'Currency: INR\nCorner Cafe 450.00\n',
      fallbackDate: fallbackDate,
      defaultCurrency: 'INR',
    );

    expect(parsed.transactions, hasLength(1));
    expect(parsed.transactions.single.description, 'Corner Cafe');
    expect(parsed.transactions.single.transactionDate, fallbackDate);
  });

  test('uses the supplied card suffix and currency defaults', () {
    final parsed = parser.parse(
      text: 'Total Amount Due 1,000.00\n05/11/2026 Merchant 100.00\n',
      fallbackDate: fallbackDate,
      defaultCurrency: 'USD',
      cardLastFour: '9999',
    );

    expect(parsed.currencyCode, 'USD');
    expect(parsed.cardLastFour, '9999');
  });

  test('skips summary lines and zero amounts', () {
    final parsed = parser.parse(
      text: '''
Currency: INR
Opening Balance 1,000.00
Available Credit 50,000.00
Reward Points 120
05/11/2026 Valid Merchant 0.00
05/11/2026 Real Merchant 125.00
''',
      fallbackDate: fallbackDate,
      defaultCurrency: 'INR',
    );

    expect(parsed.transactions, hasLength(1));
    expect(parsed.transactions.single.description, 'Real Merchant');
  });
}
