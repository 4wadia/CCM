import 'package:credit_card_manager/integrations/gmail/gmail_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Gmail search is limited to credit-card statement PDFs', () {
    final query = GmailQueryBuilder.build(after: DateTime.utc(2026, 11, 1));

    expect(query, contains('has:attachment filename:pdf'));
    expect(query, contains('subject:"credit card"'));
    expect(query, contains('subject:"card statement"'));
    expect(query, contains('subject:"credit card statement"'));
    expect(query, contains('from:(amex OR americanexpress)'));
    expect(query, contains('-subject:(debit'));
    expect(query, contains('"account statement"'));
    expect(query, contains('"bank statement"'));
    expect(query, contains('savings'));
    expect(query, contains('UPI'));
    expect(query, contains('ATM'));
    expect(query, contains('wallet'));
    expect(query, contains('after:2026/11/01'));
  });

  test('Gmail search no longer asks for every bank statement', () {
    final query = GmailQueryBuilder.build(after: DateTime.utc(2026, 11, 1));

    expect(query, isNot(contains('from:(hdfcbank OR icicibank')));
    expect(query, isNot(contains('subject:(statement OR bill OR')));
  });
}
