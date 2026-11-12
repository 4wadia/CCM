import 'dart:convert';

import '../../domain/entities/email_account.dart';

/// User-supplied values used to resolve a statement password. These values are
/// held only in memory for the extraction attempt and are never logged.
class StatementPasswordInputs {
  const StatementPasswordInputs({
    this.name,
    this.dateOfBirth,
    this.customerId,
    this.cardLastFour,
    this.statementDate,
    this.userPassword,
  });

  final String? name;
  final DateTime? dateOfBirth;
  final String? customerId;
  final String? cardLastFour;
  final DateTime? statementDate;
  final String? userPassword;
}

/// Constrained, declarative password strategies. Rules come from encrypted
/// bank_rules data; arbitrary expressions or executable code are rejected.
abstract final class PasswordStrategyEngine {
  static const String supportedVersion = '1';

  static List<String> candidates({
    required List<BankRule> rules,
    required StatementPasswordInputs inputs,
  }) {
    final result = <String>{};
    if (inputs.userPassword != null && inputs.userPassword!.isNotEmpty) {
      result.add(inputs.userPassword!);
    }
    for (final rule in rules) {
      if (rule.status != 'active') continue;
      final generated = _fromRule(rule, inputs);
      result.addAll(generated);
    }
    return result.toList(growable: false);
  }

  static List<String> _fromRule(BankRule rule, StatementPasswordInputs inputs) {
    Map<String, Object?> config;
    try {
      final decoded = jsonDecode(rule.configuration);
      if (decoded is! Map<String, Object?>) return const <String>[];
      config = decoded;
    } on FormatException {
      return const <String>[];
    }
    final parameters = config['parameters'] is Map<String, Object?>
        ? config['parameters']! as Map<String, Object?>
        : const <String, Object?>{};
    final strategy = config['strategy']?.toString() ?? rule.ruleType;
    switch (strategy) {
      case 'name_prefix_and_birth_date':
        final name = _namePrefix(
          inputs.name,
          (parameters['nameCharacters'] as num?)?.toInt() ?? 4,
        );
        final date = _formatDate(
          inputs.dateOfBirth,
          parameters['dateFormat']?.toString() ?? 'ddMM',
        );
        return name != null && date != null ? <String>['$name$date'] : const [];
      case 'customer_id_and_date':
        final id = inputs.customerId?.trim();
        final date = _formatDate(
          inputs.statementDate,
          parameters['dateFormat']?.toString() ?? 'MMyy',
        );
        return id != null && id.isNotEmpty && date != null
            ? <String>['$id$date']
            : const [];
      case 'card_suffix_and_date':
        final suffix = inputs.cardLastFour?.replaceAll(RegExp(r'\D'), '');
        final date = _formatDate(
          inputs.statementDate,
          parameters['dateFormat']?.toString() ?? 'MMyy',
        );
        return suffix != null && suffix.length >= 4 && date != null
            ? <String>['${suffix.substring(suffix.length - 4)}$date']
            : const [];
      case 'user_provided':
      case 'none':
      default:
        return const <String>[];
    }
  }

  static String? _namePrefix(String? name, int count) {
    final cleaned = name?.replaceAll(RegExp(r'[^A-Za-z]'), '').trim();
    if (cleaned == null || cleaned.isEmpty) return null;
    return cleaned.substring(0, count.clamp(1, cleaned.length)).toLowerCase();
  }

  static String? _formatDate(DateTime? date, String format) {
    if (date == null) return null;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    const monthNames = <String>[
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    return format
        .replaceAll('dd', day)
        .replaceAll('MMM', monthNames[date.month - 1])
        .replaceAll('MM', month)
        .replaceAll('yyyy', year)
        .replaceAll('yy', year.substring(2));
  }
}
