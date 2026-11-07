import 'package:credit_card_manager/domain/services/card_form_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validates identity fields', () {
    expect(CardFormValidation.requiredText('Everyday'), isNull);
    expect(CardFormValidation.requiredText('  '), isNotNull);
    expect(CardFormValidation.countryCode('US'), isNull);
    expect(CardFormValidation.countryCode('USA'), isNotNull);
    expect(CardFormValidation.lastFour('4242'), isNull);
    expect(CardFormValidation.lastFour('424'), isNotNull);
    expect(CardFormValidation.lastFour('42a2'), isNotNull);
    expect(CardFormValidation.currency('usd'), isNull);
    expect(CardFormValidation.currency('US'), isNotNull);
  });

  test('validates credit limits against currency precision', () {
    expect(CardFormValidation.creditLimit('1000', 'USD'), isNull);
    expect(CardFormValidation.creditLimit('1000.50', 'USD'), isNull);
    expect(CardFormValidation.creditLimit('1000.5', 'JPY'), isNotNull);
    expect(CardFormValidation.creditLimit('0', 'USD'), isNotNull);
    expect(CardFormValidation.creditLimit('1000', 'US'), isNotNull);
  });

  test('allows an empty outstanding balance and rejects negatives', () {
    expect(CardFormValidation.outstanding('', 'USD'), isNull);
    expect(CardFormValidation.outstanding('0.00', 'USD'), isNull);
    expect(CardFormValidation.outstanding('12.30', 'USD'), isNull);
    expect(CardFormValidation.outstanding('-1.00', 'USD'), isNotNull);
    expect(CardFormValidation.outstanding('1.001', 'USD'), isNotNull);
  });

  test('validates optional billing days', () {
    expect(CardFormValidation.dayOfMonth(''), isNull);
    expect(CardFormValidation.dayOfMonth('1'), isNull);
    expect(CardFormValidation.dayOfMonth('31'), isNull);
    expect(CardFormValidation.dayOfMonth('0'), isNotNull);
    expect(CardFormValidation.dayOfMonth('32'), isNotNull);
  });
}
