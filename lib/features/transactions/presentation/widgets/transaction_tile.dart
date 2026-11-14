import 'package:material_ui/material_ui.dart';

import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/theme/app_colors.dart';
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
    final isDark = theme.brightness == Brightness.dark;
    final credit = transaction.isCredit;

    final iconBg = transaction.needsReview
        ? theme.colorScheme.errorContainer
        : (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant);

    final iconColor = transaction.needsReview
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Icon bubble.
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _iconFor(transaction.transactionType),
                  size: 20,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Merchant and metadata.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.displayMerchant,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      formatShortDate(transaction.transactionDate),
                      if (card != null) '•••• ${card!.lastFour}',
                      transaction.transactionType.label,
                      if (transaction.needsReview) 'Needs review',
                    ].join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: transaction.needsReview
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Amount.
            CurrencyText(
              amountMinor: transaction.amountMinor,
              currencyCode: transaction.currencyCode,
              style: theme.textTheme.titleSmall?.copyWith(
                color: credit
                    ? (isDark ? AppColors.darkSuccess : AppColors.success)
                    : null,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(TransactionType type) {
    return switch (type) {
      TransactionType.purchase => Icons.shopping_bag_outlined,
      TransactionType.refund => Icons.undo_rounded,
      TransactionType.reversal => Icons.replay_rounded,
      TransactionType.payment => Icons.payments_outlined,
      TransactionType.fee => Icons.receipt_long_outlined,
      TransactionType.interest => Icons.percent_rounded,
      TransactionType.cashAdvance => Icons.atm_outlined,
      TransactionType.emiConversion => Icons.calendar_month_outlined,
      TransactionType.adjustment => Icons.tune_rounded,
      TransactionType.unknown => Icons.help_outline_rounded,
    };
  }
}
