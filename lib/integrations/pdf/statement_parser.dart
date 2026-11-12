import 'dart:math';

import '../../domain/entities/statement.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/services/merchant_normalizer.dart';

abstract interface class StatementParser {
  String get id;

  String get version;

  bool canParse(String text, {String? bankHint});

  ParsedStatement parse({
    required String text,
    required DateTime fallbackDate,
    required String defaultCurrency,
    String? cardLastFour,
    String? bankHint,
  });
}

/// Generic statement parser, intentionally conservative. It extracts metadata
/// and table-like transaction lines, then reconciliation decides whether the
/// result is trustworthy enough to post.
class GenericStatementParser implements StatementParser {
  const GenericStatementParser();

  @override
  String get id => 'generic-statement';

  @override
  String get version => '1';

  @override
  bool canParse(String text, {String? bankHint}) =>
      text.trim().isNotEmpty && _hasAnyAmount(text);

  @override
  ParsedStatement parse({
    required String text,
    required DateTime fallbackDate,
    required String defaultCurrency,
    String? cardLastFour,
    String? bankHint,
  }) {
    final currency = _currency(text) ?? defaultCurrency;
    final statementDate =
        _dateFor(
          text,
          RegExp(
            r'statement\s+date\s*:?\s*([0-9]{1,2}[A-Za-z0-9 /,.-]{5,20})',
            caseSensitive: false,
          ),
        ) ??
        fallbackDate;
    final period = _period(text, statementDate);
    final dueDate = _dateFor(
      text,
      RegExp(
        r'(?:payment\s+)?due\s+date\s*:?\s*([0-9]{1,2}[A-Za-z0-9 /,.-]{5,20})',
        caseSensitive: false,
      ),
    );
    final previous = _amountAfterLabel(
      text,
      RegExp(r'previous\s+balance', caseSensitive: false),
    );
    final total = _amountAfterLabel(
      text,
      RegExp(
        r'(?:total\s+(?:amount\s+)?due|amount\s+due)',
        caseSensitive: false,
      ),
    );
    final minimum = _amountAfterLabel(
      text,
      RegExp(
        r'(?:minimum\s+(?:amount\s+)?due|minimum\s+payment)',
        caseSensitive: false,
      ),
    );
    final parsedCard = _lastFour(text) ?? cardLastFour;
    final transactions = _transactions(
      text: text,
      currency: currency,
      fallbackDate: statementDate,
      cardLastFour: parsedCard,
    );

    return ParsedStatement(
      periodStart: period.$1,
      periodEnd: period.$2,
      statementDate: statementDate,
      paymentDueDate: dueDate,
      previousBalanceMinor: previous,
      totalDueMinor: total,
      minimumDueMinor: minimum,
      currencyCode: currency,
      cardLastFour: parsedCard,
      bankHint: bankHint,
      parserId: id,
      parserVersion: version,
      transactions: transactions,
    );
  }

  bool _hasAnyAmount(String text) => RegExp(r'[\d,]+\.\d{2}').hasMatch(text);

  String? _currency(String text) {
    final match = RegExp(
      r'\b(INR|USD|EUR|GBP|AED|SGD|CAD|AUD|JPY|CHF)\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) return match.group(1)!.toUpperCase();
    if (text.contains('₹')) return 'INR';
    if (text.contains('\u0024')) return 'USD';
    if (text.contains('€')) return 'EUR';
    if (text.contains('£')) return 'GBP';
    return null;
  }

  DateTime? _dateFor(String text, RegExp pattern) {
    final match = pattern.firstMatch(text);
    if (match == null) return null;
    return _parseDate(match.group(1));
  }

  (DateTime, DateTime) _period(String text, DateTime statementDate) {
    final pattern = RegExp(
      r'(?:statement|billing)\s+period\s*:?\s*'
      r'([0-9]{1,2}[A-Za-z0-9 /,.-]{5,20}?)\s*(?:to|through|until|-|–)\s*'
      r'([0-9]{1,2}[A-Za-z0-9 /,.-]{5,20}?)(?:\n|$)',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(text);
    final start = match == null ? null : _parseDate(match.group(1));
    final end = match == null ? null : _parseDate(match.group(2));
    if (start != null && end != null && !end.isBefore(start)) {
      return (start, end);
    }
    final endDate = DateTime(
      statementDate.year,
      statementDate.month,
      statementDate.day,
    );
    return (endDate.subtract(const Duration(days: 30)), endDate);
  }

  int _amountAfterLabel(String text, RegExp label) {
    final match = label.firstMatch(text);
    if (match == null) return 0;
    final tail = text.substring(match.end, min(match.end + 80, text.length));
    final amount = RegExp(r'([\d,]+\.\d{2})').firstMatch(tail);
    return amount == null
        ? 0
        : _toMinor(amount.group(1)!, 'USD', forceTwo: true);
  }

  List<ParsedTransaction> _transactions({
    required String text,
    required String currency,
    required DateTime fallbackDate,
    required String? cardLastFour,
  }) {
    final result = <ParsedTransaction>[];
    final lines = text.split(RegExp(r'\r?\n'));
    final dateAtStart = RegExp(
      r'^\s*([0-9]{1,2}[/-][0-9]{1,2}[/-][0-9]{2,4}|[0-9]{1,2}\s+[A-Za-z]{3,9}\s+[0-9]{2,4})\s+(.+?)\s+([\d,]+\.\d{2})(?:\s*(Cr|DR|CR))?\s*$',
    );
    final dateAtEnd = RegExp(
      r'^\s*(.+?)\s+([0-9]{1,2}[/-][0-9]{1,2}[/-][0-9]{2,4})\s+([\d,]+\.\d{2})(?:\s*(Cr|DR|CR))?\s*$',
    );
    final amountAtEnd = RegExp(
      r"^\s*([A-Za-z][A-Za-z0-9 &.,/_'-]{2,}?)\s+([\d,]+\.\d{2})(?:\s*(Cr|DR|CR))?\s*$",
    );
    final skip = RegExp(
      r'\b(?:opening|closing|previous|total|minimum|payment due|statement date|'
      r'credit limit|available|reward|points|summary|balance)\b',
      caseSensitive: false,
    );

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.length < 8 || skip.hasMatch(line)) continue;
      String? dateText;
      String? description;
      String? amountText;
      String? creditMarker;

      final startMatch = dateAtStart.firstMatch(line);
      final endMatch = dateAtEnd.firstMatch(line);
      final bareMatch = amountAtEnd.firstMatch(line);
      if (startMatch != null) {
        dateText = startMatch.group(1);
        description = startMatch.group(2);
        amountText = startMatch.group(3);
        creditMarker = startMatch.group(4);
      } else if (endMatch != null) {
        description = endMatch.group(1);
        dateText = endMatch.group(2);
        amountText = endMatch.group(3);
        creditMarker = endMatch.group(4);
      } else if (bareMatch != null) {
        description = bareMatch.group(1);
        amountText = bareMatch.group(2);
        creditMarker = bareMatch.group(3);
      }
      if (description == null || amountText == null) continue;
      final cleanedDescription = description.trim();
      if (cleanedDescription.length < 3) continue;
      final type = _type(cleanedDescription, creditMarker);
      final amount = _toMinor(amountText, currency);
      if (amount == 0) continue;
      final date = _parseDate(dateText) ?? fallbackDate;
      result.add(
        ParsedTransaction(
          description: cleanedDescription,
          amountMinor: amount,
          currencyCode: currency,
          transactionDate: date,
          transactionType: type,
          confidence: SourceConfidence.high,
          merchant: MerchantNormalizer.normalize(cleanedDescription),
          cardLastFour: cardLastFour,
          parserId: id,
          parserVersion: version,
        ),
      );
    }
    return result;
  }

  TransactionType _type(String description, String? marker) {
    final text = description.toLowerCase();
    if (marker != null &&
        (marker.toLowerCase() == 'cr' || marker.toUpperCase() == 'DR')) {
      if (marker.toLowerCase() == 'cr' || marker.toUpperCase() == 'CR') {
        return TransactionType.refund;
      }
    }
    if (RegExp(r'\b(?:refund|reversal|credit)\b').hasMatch(text)) {
      return TransactionType.refund;
    }
    if (RegExp(r'\bpayment\b').hasMatch(text)) return TransactionType.payment;
    if (RegExp(r'\b(?:fee|charge)\b').hasMatch(text)) {
      return TransactionType.fee;
    }
    if (RegExp(r'\binterest\b').hasMatch(text)) return TransactionType.interest;
    if (RegExp(r'\b(?:cash advance|atm)\b').hasMatch(text)) {
      return TransactionType.cashAdvance;
    }
    if (RegExp(r'\bemi\b').hasMatch(text)) return TransactionType.emiConversion;
    return TransactionType.purchase;
  }

  int _toMinor(String value, String currency, {bool forceTwo = false}) {
    final cleaned = value.replaceAll(',', '').trim();
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(cleaned);
    if (match == null) return 0;
    final whole = int.tryParse(match.group(1)!) ?? 0;
    final fraction = (match.group(2) ?? '').padRight(2, '0');
    return whole * 100 + (int.tryParse(fraction) ?? 0);
  }

  String? _lastFour(String text) {
    final match = RegExp(
      r'(?:ending(?:\s+with)?|xx+|\*+|••+)\s*(\d{4})\b',
      caseSensitive: false,
    ).firstMatch(text);
    return match?.group(1);
  }

  DateTime? _parseDate(String? value) {
    if (value == null) return null;
    final cleaned = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    final numeric = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})$')
        .firstMatch(cleaned);
    if (numeric != null) {
      final first = int.tryParse(numeric.group(1)!);
      final second = int.tryParse(numeric.group(2)!);
      var year = int.tryParse(numeric.group(3)!);
      if (first == null || second == null || year == null) return null;
      if (year < 100) year += 2000;
      // Statement fixtures use day/month/year unless the first component is
      // unambiguously a month in a year-first format.
      return DateTime(year, second, first);
    }
    final words = RegExp(r'^(\d{1,2})[\s-]+([A-Za-z]{3,9})[\s,-]+(\d{2,4})$')
        .firstMatch(cleaned);
    if (words != null) {
      final day = int.tryParse(words.group(1)!);
      final month = _month(words.group(2)!);
      var year = int.tryParse(words.group(3)!);
      if (day == null || month == null || year == null) return null;
      if (year < 100) year += 2000;
      return DateTime(year, month, day);
    }
    final monthFirst = RegExp(r'^([A-Za-z]{3,9})\s+(\d{1,2}),?\s+(\d{2,4})$')
        .firstMatch(cleaned);
    if (monthFirst != null) {
      final month = _month(monthFirst.group(1)!);
      final day = int.tryParse(monthFirst.group(2)!);
      var year = int.tryParse(monthFirst.group(3)!);
      if (day == null || month == null || year == null) return null;
      if (year < 100) year += 2000;
      return DateTime(year, month, day);
    }
    return null;
  }

  int? _month(String value) {
    const months = <String, int>{
      'jan': 1,
      'january': 1,
      'feb': 2,
      'february': 2,
      'mar': 3,
      'march': 3,
      'apr': 4,
      'april': 4,
      'may': 5,
      'jun': 6,
      'june': 6,
      'jul': 7,
      'july': 7,
      'aug': 8,
      'august': 8,
      'sep': 9,
      'sept': 9,
      'september': 9,
      'oct': 10,
      'october': 10,
      'nov': 11,
      'november': 11,
      'dec': 12,
      'december': 12,
    };
    return months[value.toLowerCase()];
  }
}
