import '../../domain/entities/sms_message.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/services/merchant_normalizer.dart';
import '../../domain/services/money_amount.dart';

abstract interface class SmsParser {
  List<ParsedTransaction> parse(SmsMessage message, {String? bankHint});
}

/// Conservative generic parser. Bank-specific adapters can add sender mapping
/// and stricter merchant extraction without changing the import pipeline.
class GenericSmsParser implements SmsParser {
  const GenericSmsParser({this.defaultCurrency = 'INR'});

  final String defaultCurrency;

  static final RegExp _otp = RegExp(
    r'\b(?:otp|one[\s-]?time|verification code|do not share)\b',
    caseSensitive: false,
  );
  static final RegExp _failed = RegExp(
    r'\b(?:failed|declined|not successful|unsuccessful)\b',
    caseSensitive: false,
  );
  static final RegExp _amountBefore = RegExp(
    r'(?:(?:INR|USD|Rs\.?|₹|\$)\s*)([\d,]+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );
  static final RegExp _amountAfter = RegExp(
    r'([\d,]+(?:\.\d{1,2})?)\s*(?:INR|USD|Rs\.?|₹|\$)',
    caseSensitive: false,
  );
  static final RegExp _lastFour = RegExp(
    r'(?:ending(?:\s+with)?|card\s*(?:no\.?\s*)?(?:xx+|\*+)?|xx+|\*+)[\s:.-]*(\d{4})\b',
    caseSensitive: false,
  );
  static final RegExp _merchant = RegExp(
    r"\b(?:at|to|from|merchant[:\s])\s+([A-Za-z0-9][A-Za-z0-9 &._'-]{2,}?)"
    r'(?=\s+(?:on|for|ref|dated|via|at|using|with)\b|[.,]|$)',

    caseSensitive: false,
  );
  static final RegExp _date = RegExp(
    r'\b(?:on|dated)\s+(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
    caseSensitive: false,
  );

  @override
  List<ParsedTransaction> parse(SmsMessage message, {String? bankHint}) {
    final body = message.body;
    if (body.trim().isEmpty) return const <ParsedTransaction>[];
    if (_otp.hasMatch(body)) return const <ParsedTransaction>[];
    if (!_looksTransactional(body)) return const <ParsedTransaction>[];

    final amountText =
        _amountBefore.firstMatch(body)?.group(1) ??
        _amountAfter.firstMatch(body)?.group(1);
    if (amountText == null) return const <ParsedTransaction>[];

    final currency = _currency(body) ?? defaultCurrency;
    final amountMinor = MoneyAmount.parseNonNegativeMinorUnits(
      amountText.replaceAll(',', ''),
      currency,
    );
    if (amountMinor == null || amountMinor == 0) {
      return const <ParsedTransaction>[];
    }

    final type = _type(body);
    final date =
        _parseDate(_date.firstMatch(body)?.group(1)) ?? message.receivedAt;
    final merchant = _cleanMerchant(_merchant.firstMatch(body)?.group(1));
    final lastFour = _lastFour.firstMatch(body)?.group(1);
    final failed = _failed.hasMatch(body);

    return <ParsedTransaction>[
      ParsedTransaction(
        description: merchant ?? _safeDescription(type, body),
        amountMinor: amountMinor,
        currencyCode: currency,
        transactionDate: DateTime(date.year, date.month, date.day),
        transactionType: type,
        confidence: lastFour == null
            ? SourceConfidence.medium
            : SourceConfidence.high,
        merchant: merchant,
        cardLastFour: lastFour,
        bankHint: bankHint,
        sourceReference: 'sms:${message.id}',
        parserId: 'generic-sms',
        parserVersion: '1',
        notes: failed
            ? 'The SMS indicated a failed or declined transaction.'
            : null,
        status: failed ? TransactionStatus.failed : null,
      ),
    ];
  }

  bool _looksTransactional(String body) {
    final hasAmount =
        _amountBefore.hasMatch(body) || _amountAfter.hasMatch(body);
    if (!hasAmount) return false;
    return RegExp(
      r'\b(?:spent|spend|purchase|debited|debit|charged|paid|payment|'
      r'refund(?:ed)?|credited|credit|withdrawn|revers(?:al|ed)|fee|'
      r'interest|emi)\b',
      caseSensitive: false,
    ).hasMatch(body);
  }

  String? _currency(String body) {
    if (RegExp(r'₹|\bINR\b|\bRs\.?\b', caseSensitive: false).hasMatch(body)) {
      return 'INR';
    }
    if (RegExp(r'\$|\bUSD\b', caseSensitive: false).hasMatch(body)) {
      return 'USD';
    }
    return null;
  }

  TransactionType _type(String body) {
    final text = body.toLowerCase();
    if (RegExp(r'\b(?:refund(?:ed)?|revers(?:al|ed))\b').hasMatch(text)) {
      return TransactionType.refund;
    }
    if (RegExp(r'\b(?:cash advance|atm withdrawal|withdrawn)\b')
        .hasMatch(text)) {
      return TransactionType.cashAdvance;
    }
    if (RegExp(r'\b(?:payment received|payment of|paid|payment)\b')
        .hasMatch(text)) {
      return TransactionType.payment;
    }
    if (RegExp(r'\b(?:annual fee|late fee|\bfee\b)\b').hasMatch(text)) {
      return TransactionType.fee;
    }
    if (RegExp(r'\binterest\b').hasMatch(text)) {
      return TransactionType.interest;
    }
    if (RegExp(r'\bemi\b').hasMatch(text)) {
      return TransactionType.emiConversion;
    }
    return TransactionType.purchase;
  }

  DateTime? _parseDate(String? value) {
    if (value == null) return null;
    final parts = value.split(RegExp(r'[/-]'));
    if (parts.length != 3) return null;
    final first = int.tryParse(parts[0]);
    final second = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (first == null || second == null || year == null) return null;
    if (year < 100) {
      return DateTime(2000 + year, second, first);
    }
    // Prefer day/month/year for the supported bank formats.
    return DateTime(year, second, first);
  }

  String? _cleanMerchant(String? value) {
    if (value == null) return null;
    final normalized = MerchantNormalizer.normalize(value);
    if (normalized.isEmpty) return null;
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String _safeDescription(TransactionType type, String body) {
    final digits = body.replaceAll(RegExp(r'\D'), '');
    return digits.isEmpty ? type.label : '${type.label} transaction';
  }
}
