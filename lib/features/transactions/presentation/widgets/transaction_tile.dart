import 'package:flutter/material.dart';

import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/widgets/currency_text.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.card,
    this.onTap,
  });

  final CardTransaction transaction;
  final CreditCard? card;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final credit = transaction.isCredit;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: transaction.needsReview
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.secondaryContainer,
        child: Icon(
          _iconFor(transaction.transactionType),
          size: 20,
          color: transaction.needsReview
              ? theme.colorScheme.onErrorContainer
              : theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        transaction.displayMerchant,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        [
          formatShortDate(transaction.transactionDate),
          if (card != null) '•••• ${card!.lastFour}',
          transaction.transactionType.label,
          if (transaction.needsReview) 'Needs review',
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: CurrencyText(
        amountMinor: transaction.amountMinor,
        currencyCode: transaction.currencyCode,
        style: theme.textTheme.labelLarge?.copyWith(
          color: credit ? theme.colorScheme.tertiary : null,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _iconFor(TransactionType type) {
    return switch (type) {
      TransactionType.purchase => Icons.shopping_bag_outlined,
      TransactionType.refund => Icons.undo,
      TransactionType.reversal => Icons.replay,
      TransactionType.payment => Icons.payments_outlined,
      TransactionType.fee => Icons.receipt_long_outlined,
      TransactionType.interest => Icons.percent,
      TransactionType.cashAdvance => Icons.atm_outlined,
      TransactionType.emiConversion => Icons.calendar_month_outlined,
      TransactionType.adjustment => Icons.tune,
      TransactionType.unknown => Icons.help_outline,
    };
  }
}
