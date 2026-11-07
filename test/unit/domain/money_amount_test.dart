import 'package:credit_card_manager/domain/entities/currency.dart';
import 'package:credit_card_manager/domain/entities/money.dart';
import 'package:credit_card_manager/domain/services/money_amount.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maintains ISO currency fraction digits', () {
    expect(CurrencyMetadata.minorDigitsFor('USD'), 2);
    expect(CurrencyMetadata.minorDigitsFor('INR'), 2);
    expect(CurrencyMetadata.minorDigitsFor('JPY'), 0);
    expect(CurrencyMetadata.minorDigitsFor('BHD'), 3);
    expect(CurrencyMetadata.minorDigitsFor('CLF'), 4);
    expect(CurrencyMetadata.minorDigitsFor('US'), isNull);
    expect(CurrencyMetadata.minorDigitsFor('usd'), isNull);
  });

  test('parses currencies with zero, two, three, and four fraction digits', () {
    expect(MoneyAmount.parseMinorUnits('1200', 'JPY'), 1200);
    expect(MoneyAmount.parseMinorUnits('1250.75', 'INR'), 125075);
    expect(MoneyAmount.parseMinorUnits('12.345', 'BHD'), 12345);
    expect(MoneyAmount.parseMinorUnits('1.2345', 'CLF'), 12345);
  });

  test('rejects invalid precision, malformed values, and zero limits', () {
    expect(MoneyAmount.parseMinorUnits('1200.1', 'JPY'), isNull);
    expect(MoneyAmount.parseMinorUnits('1.001', 'USD'), isNull);
    expect(MoneyAmount.parseMinorUnits('-1.00', 'USD'), isNull);
    expect(MoneyAmount.parseMinorUnits('0.00', 'USD'), isNull);
    expect(MoneyAmount.parseMinorUnits('1,000.00', 'USD'), isNull);
    expect(MoneyAmount.parseMinorUnits('100', 'US'), isNull);
  });

  test('parses non-negative outstanding balances', () {
    expect(MoneyAmount.parseNonNegativeMinorUnits('0', 'USD'), 0);
    expect(MoneyAmount.parseNonNegativeMinorUnits('0.00', 'USD'), 0);
    expect(MoneyAmount.parseNonNegativeMinorUnits('12.30', 'USD'), 1230);
    expect(MoneyAmount.parseNonNegativeMinorUnits('-0.01', 'USD'), isNull);
    expect(MoneyAmount.parseNonNegativeMinorUnits('1.001', 'USD'), isNull);
  });

  test('formats minor units without floating-point conversion', () {
    expect(MoneyAmount.formatMinorUnits(125075, 'INR'), 'INR 1,250.75');
    expect(MoneyAmount.formatMinorUnits(1200, 'JPY'), 'JPY 1,200');
    expect(MoneyAmount.formatMinorUnits(12345, 'BHD'), 'BHD 12.345');
    expect(MoneyAmount.formatMinorUnits(12345, 'CLF'), 'CLF 1.2345');
    expect(MoneyAmount.formatMinorUnits(-15, 'USD'), 'USD -0.15');
    expect(MoneyAmount.formatMinorUnits(0, 'USD'), 'USD 0.00');
  });

  test('Money never combines unlike currencies', () {
    const usd = Money(amountMinor: 1000, currencyCode: 'USD');
    const usdAgain = Money(amountMinor: 250, currencyCode: 'USD');
    const inr = Money(amountMinor: 1000, currencyCode: 'INR');

    expect((usd + usdAgain).amountMinor, 1250);
    expect((usd - usdAgain).amountMinor, 750);
    expect(usd, const Money(amountMinor: 1000, currencyCode: 'USD'));
    expect(() => usd + inr, throwsArgumentError);
    expect(() => usd - inr, throwsArgumentError);
  });
}
