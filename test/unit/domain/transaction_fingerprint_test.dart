import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/domain/services/transaction_fingerprint.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final day = DateTime.utc(2026, 11, 5);

  String? fingerprint({
    String? cardId = 'card_1',
    int amountMinor = 125050,
    String currencyCode = 'INR',
    DateTime? transactionDate,
    String? merchant = 'Coffee House',
    TransactionType type = TransactionType.purchase,
    int version = TransactionFingerprint.currentVersion,
  }) {
    return TransactionFingerprint.compute(
      cardId: cardId,
      amountMinor: amountMinor,
      currencyCode: currencyCode,
      transactionDate: transactionDate ?? day,
      merchant: merchant,
      type: type,
      version: version,
    );
  }

  test('is deterministic for identical canonical fields', () {
    expect(fingerprint(), fingerprint());
    expect(fingerprint(), hasLength(64));
  });

  test('ignores the time of day but not the date', () {
    expect(
      fingerprint(transactionDate: DateTime.utc(2026, 11, 5, 23, 59)),
      fingerprint(transactionDate: DateTime.utc(2026, 11, 5, 0, 1)),
    );
    expect(
      fingerprint(transactionDate: DateTime.utc(2026, 11, 6)),
      isNot(fingerprint()),
    );
  });

  test('normalizes payment-channel noise in the merchant', () {
    expect(
      fingerprint(merchant: 'COFFEE HOUSE POS 1234'),
      fingerprint(merchant: 'Coffee House'),
    );
  });

  test('changes with the fingerprint version', () {
    expect(fingerprint(version: 1), isNot(fingerprint(version: 2)));
  });

  test('changes with card, amount, currency, or type', () {
    final base = fingerprint();
    expect(fingerprint(cardId: 'card_2'), isNot(base));
    expect(fingerprint(amountMinor: 125051), isNot(base));
    expect(fingerprint(currencyCode: 'USD'), isNot(base));
    expect(fingerprint(type: TransactionType.refund), isNot(base));
  });

  test('returns null without a matched card', () {
    expect(fingerprint(cardId: null), isNull);
    expect(fingerprint(cardId: '  '), isNull);
  });
}
