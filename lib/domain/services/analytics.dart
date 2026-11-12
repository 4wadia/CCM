import '../entities/credit_card.dart';
import '../entities/transaction.dart';

class CurrencySpending {
  const CurrencySpending({
    required this.currencyCode,
    required this.amountMinor,
    required this.transactionCount,
  });

  final String currencyCode;
  final int amountMinor;
  final int transactionCount;
}

class CategorySpending {
  const CategorySpending({
    required this.currencyCode,
    required this.categoryId,
    required this.amountMinor,
  });

  final String currencyCode;
  final String? categoryId;
  final int amountMinor;
}

class UpcomingPayment {
  const UpcomingPayment({
    required this.cardId,
    required this.displayName,
    required this.dueDate,
    required this.amountMinor,
    required this.currencyCode,
    required this.lastFour,
  });

  final String cardId;
  final String displayName;
  final DateTime dueDate;
  final int amountMinor;
  final String currencyCode;
  final String lastFour;
}

class MonthSpending {
  const MonthSpending({required this.month, required this.byCurrency});

  final DateTime month;
  final List<CurrencySpending> byCurrency;
}

class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    required this.currentMonth,
    required this.previousMonths,
    required this.categories,
    required this.upcomingPayments,
  });

  final List<CurrencySpending> currentMonth;
  final List<MonthSpending> previousMonths;
  final List<CategorySpending> categories;
  final List<UpcomingPayment> upcomingPayments;

  bool get hasSpending => currentMonth.any((item) => item.amountMinor != 0);
}

abstract final class AnalyticsService {
  static const Set<TransactionType> _spendingTypes = <TransactionType>{
    TransactionType.purchase,
    TransactionType.fee,
    TransactionType.interest,
    TransactionType.cashAdvance,
    TransactionType.emiConversion,
    TransactionType.refund,
    TransactionType.reversal,
  };

  static AnalyticsSnapshot build({
    required List<CardTransaction> transactions,
    required List<CreditCard> cards,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final monthStart = DateTime(current.year, current.month);
    final nextMonth = DateTime(current.year, current.month + 1);
    final relevant = transactions.where(
      (tx) => _spendingTypes.contains(tx.transactionType),
    );

    final currentMonth = _group(
      relevant.where(
        (tx) =>
            !tx.transactionDate.isBefore(monthStart) &&
            tx.transactionDate.isBefore(nextMonth),
      ),
    );
    final previous = <MonthSpending>[];
    for (var offset = 1; offset <= 3; offset++) {
      final start = DateTime(current.year, current.month - offset);
      final end = DateTime(current.year, current.month - offset + 1);
      previous.add(
        MonthSpending(
          month: start,
          byCurrency: _group(
            relevant.where(
              (tx) =>
                  !tx.transactionDate.isBefore(start) &&
                  tx.transactionDate.isBefore(end),
            ),
          ),
        ),
      );
    }

    final categoryMap = <String, int>{};
    for (final tx in relevant) {
      if (tx.transactionDate.isBefore(monthStart) ||
          !tx.transactionDate.isBefore(nextMonth)) {
        continue;
      }
      final key = '${tx.currencyCode}|${tx.categoryId ?? ''}';
      categoryMap[key] = (categoryMap[key] ?? 0) + tx.amountMinor;
    }
    final categories = categoryMap.entries
        .map((entry) {
          final parts = entry.key.split('|');
          return CategorySpending(
            currencyCode: parts.first,
            categoryId: parts.length > 1 && parts[1].isNotEmpty
                ? parts[1]
                : null,
            amountMinor: entry.value,
          );
        })
        .toList(growable: false);

    final payments = <UpcomingPayment>[];
    for (final card in cards.where((card) => card.isActive)) {
      final dueDay = card.dueDay;
      if (dueDay == null) continue;
      final due = _nextDay(current, dueDay);
      payments.add(
        UpcomingPayment(
          cardId: card.id,
          displayName: card.displayName,
          dueDate: due,
          amountMinor: card.currentOutstandingMinor,
          currencyCode: card.currencyCode,
          lastFour: card.lastFour,
        ),
      );
    }
    payments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return AnalyticsSnapshot(
      currentMonth: currentMonth,
      previousMonths: previous,
      categories: categories,
      upcomingPayments: payments,
    );
  }

  static List<CurrencySpending> _group(Iterable<CardTransaction> txs) {
    final amounts = <String, int>{};
    final counts = <String, int>{};
    for (final tx in txs) {
      amounts[tx.currencyCode] =
          (amounts[tx.currencyCode] ?? 0) + tx.amountMinor;
      counts[tx.currencyCode] = (counts[tx.currencyCode] ?? 0) + 1;
    }
    final result = amounts.entries
        .map(
          (entry) => CurrencySpending(
            currencyCode: entry.key,
            amountMinor: entry.value,
            transactionCount: counts[entry.key] ?? 0,
          ),
        )
        .toList(growable: false);
    result.sort((a, b) => a.currencyCode.compareTo(b.currencyCode));
    return result;
  }

  static DateTime _nextDay(DateTime now, int day) {
    final clamped = day.clamp(1, 28);
    var candidate = DateTime(now.year, now.month, clamped);
    if (candidate.isBefore(DateTime(now.year, now.month, now.day))) {
      candidate = DateTime(now.year, now.month + 1, clamped);
    }
    return candidate;
  }
}
