import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/services/card_matcher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 11, 5);

  Bank bank(String id, String name) => Bank(
    id: id,
    displayName: name,
    countryCode: 'IN',
    region: 'India',
    createdAt: now,
    updatedAt: now,
  );

  CreditCard card({
    required String id,
    required String bankId,
    String lastFour = '4242',
    CardStatus status = CardStatus.active,
  }) {
    return CreditCard(
      id: id,
      bankId: bankId,
      displayName: id,
      network: CardNetwork.visa,
      lastFour: lastFour,
      creditLimitMinor: 100000,
      currencyCode: 'INR',
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  final banks = [bank('bank_a', 'Alpha Bank'), bank('bank_b', 'Beta Bank')];
  final alpha = card(id: 'alpha', bankId: 'bank_a');
  final beta = card(id: 'beta', bankId: 'bank_b', lastFour: '1111');

  test('matches a unique last four and extracts digits from masked input', () {
    final match = CardMatcher.match(
      lastFour: 'xx-4242',
      bankHint: null,
      cards: [alpha, beta],
      banks: banks,
    );

    expect(match.matched, isTrue);
    expect(match.card?.id, 'alpha');
    expect(match.bankId, 'bank_a');
  });

  test('uses the issuer hint to disambiguate the same suffix', () {
    final sameSuffixBeta = card(id: 'beta2', bankId: 'bank_b');
    final match = CardMatcher.match(
      lastFour: '4242',
      bankHint: 'Beta',
      cards: [alpha, sameSuffixBeta],
      banks: banks,
    );

    expect(match.matched, isTrue);
    expect(match.card?.id, 'beta2');
  });

  test('never guesses when more than one card still matches', () {
    final sameSuffixBeta = card(id: 'beta2', bankId: 'bank_b');
    final match = CardMatcher.match(
      lastFour: '4242',
      bankHint: null,
      cards: [alpha, sameSuffixBeta],
      banks: banks,
    );

    expect(match.matched, isFalse);
    expect(match.ambiguous, isTrue);
    expect(match.card, isNull);
  });

  test('keeps suffix candidates when the hint narrows to nothing', () {
    final match = CardMatcher.match(
      lastFour: '4242',
      bankHint: 'Unknown Issuer',
      cards: [alpha, beta],
      banks: banks,
    );

    expect(match.matched, isTrue);
    expect(match.card?.id, 'alpha');
  });

  test('returns unmatched when no card matches', () {
    final match = CardMatcher.match(
      lastFour: '9999',
      bankHint: null,
      cards: [alpha, beta],
      banks: banks,
    );

    expect(match.matched, isFalse);
    expect(match.ambiguous, isFalse);
    expect(match.card, isNull);
    expect(match.reason, contains('No card'));
  });

  test('ignores archived and closed cards', () {
    final archived = card(
      id: 'archived',
      bankId: 'bank_a',
      status: CardStatus.archived,
    );
    final match = CardMatcher.match(
      lastFour: '4242',
      bankHint: null,
      cards: [archived],
      banks: banks,
    );

    expect(match.matched, isFalse);
    expect(match.ambiguous, isFalse);
  });

  test('matches by issuer alone when the suffix is absent', () {
    final match = CardMatcher.match(
      lastFour: null,
      bankHint: 'Alpha',
      cards: [alpha, beta],
      banks: banks,
    );

    expect(match.matched, isTrue);
    expect(match.card?.id, 'alpha');
  });
}
