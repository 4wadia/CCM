import '../entities/credit_card.dart';
import '../entities/transaction.dart';
import 'money_amount.dart';

abstract final class CsvExporter {
  static String export({
    required List<CardTransaction> transactions,
    required Map<String, CreditCard> cards,
  }) {
    final buffer = StringBuffer()
      ..writeln(
        'date,card_last_four,merchant,amount,currency,type,status,category,source,notes',
      );
    for (final tx in transactions) {
      final card = tx.cardId == null ? null : cards[tx.cardId];
      buffer.writeln(
        <String>[
          tx.transactionDate.toIso8601String(),
          card?.lastFour ?? '',
          _quote(tx.displayMerchant),
          _amount(tx.amountMinor, tx.currencyCode),
          tx.currencyCode,
          tx.transactionType.label,
          tx.status.label,
          _quote(tx.categoryId ?? ''),
          tx.sourceConfidence?.name ?? '',
          _quote(tx.notes ?? ''),
        ].join(','),
      );
    }
    return buffer.toString();
  }

  static String _quote(String value) {
    if (!value.contains(RegExp(r'[",\n\r]'))) return value;
    return '"${value.replaceAll('"', '""')}"';
  }

  static String _amount(int amountMinor, String currencyCode) {
    final formatted = MoneyAmount.formatMinorUnits(amountMinor, currencyCode);
    return formatted.substring(currencyCode.length + 1).replaceAll(',', '');
  }
}
