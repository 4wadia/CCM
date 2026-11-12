import 'dart:convert';

import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/integrations/pdf/password_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 11, 5);

  BankRule rule({
    required String strategy,
    Map<String, Object?> parameters = const {},
    String status = 'active',
    String? rawConfiguration,
  }) {
    return BankRule(
      id: 'rule_$strategy',
      bankId: 'bank_1',
      ruleType: strategy,
      configurationVersion: '1',
      configuration:
          rawConfiguration ??
          jsonEncode(<String, Object?>{
            'strategy': strategy,
            'parameters': parameters,
          }),
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('includes a user-provided password first', () {
    final candidates = PasswordStrategyEngine.candidates(
      rules: const [],
      inputs: const StatementPasswordInputs(userPassword: 'my-secret-pass'),
    );

    expect(candidates, ['my-secret-pass']);
  });

  test('generates name prefix and birth date candidates', () {
    final candidates = PasswordStrategyEngine.candidates(
      rules: [
        rule(
          strategy: 'name_prefix_and_birth_date',
          parameters: {'nameCharacters': 4, 'dateFormat': 'ddMM'},
        ),
      ],
      inputs: StatementPasswordInputs(
        name: 'Alice Smith',
        dateOfBirth: DateTime(1985, 3, 7),
      ),
    );

    expect(candidates, contains('alic0703'));
  });

  test('supports month-name date formats', () {
    final candidates = PasswordStrategyEngine.candidates(
      rules: [
        rule(
          strategy: 'name_prefix_and_birth_date',
          parameters: {'nameCharacters': 2, 'dateFormat': 'ddMMMyyyy'},
        ),
      ],
      inputs: StatementPasswordInputs(
        name: 'Alice',
        dateOfBirth: DateTime(1985, 3, 7),
      ),
    );

    expect(candidates, contains('al07mar1985'));
  });

  test('generates customer id and statement date candidates', () {
    final candidates = PasswordStrategyEngine.candidates(
      rules: [
        rule(
          strategy: 'customer_id_and_date',
          parameters: {'dateFormat': 'MMyy'},
        ),
      ],
      inputs: StatementPasswordInputs(
        customerId: 'CUST123',
        statementDate: DateTime(2026, 11, 5),
      ),
    );

    expect(candidates, contains('CUST1231126'));
  });

  test('generates card suffix and statement date candidates', () {
    final candidates = PasswordStrategyEngine.candidates(
      rules: [
        rule(
          strategy: 'card_suffix_and_date',
          parameters: {'dateFormat': 'MMyy'},
        ),
      ],
      inputs: StatementPasswordInputs(
        cardLastFour: 'xx-4242',
        statementDate: DateTime(2026, 11, 5),
      ),
    );

    expect(candidates, contains('42421126'));
  });

  test('skips inactive rules and invalid configuration', () {
    final candidates = PasswordStrategyEngine.candidates(
      rules: [
        rule(
          strategy: 'name_prefix_and_birth_date',
          status: 'inactive',
          parameters: {'dateFormat': 'ddMM'},
        ),
        rule(strategy: 'customer_id_and_date', rawConfiguration: '{not-json'),
        rule(strategy: 'unsupported'),
      ],
      inputs: StatementPasswordInputs(
        name: 'Alice',
        dateOfBirth: DateTime(1985, 3, 7),
        customerId: 'CUST123',
        statementDate: DateTime(2026, 11, 5),
      ),
    );

    expect(candidates, isEmpty);
  });

  test('omits candidates when required inputs are missing', () {
    final candidates = PasswordStrategyEngine.candidates(
      rules: [
        rule(strategy: 'name_prefix_and_birth_date'),
        rule(strategy: 'customer_id_and_date'),
        rule(strategy: 'card_suffix_and_date'),
      ],
      inputs: const StatementPasswordInputs(),
    );

    expect(candidates, isEmpty);
  });

  test('deduplicates identical candidates', () {
    final candidates = PasswordStrategyEngine.candidates(
      rules: [
        rule(
          strategy: 'customer_id_and_date',
          parameters: {'dateFormat': 'MMyy'},
        ),
        rule(
          strategy: 'customer_id_and_date',
          parameters: {'dateFormat': 'MMyy'},
        ),
      ],
      inputs: StatementPasswordInputs(
        customerId: 'CUST123',
        statementDate: DateTime(2026, 11, 5),
      ),
    );

    expect(candidates, ['CUST1231126']);
  });
}
