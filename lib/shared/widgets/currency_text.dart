import 'package:credit_card_manager/domain/services/money_amount.dart';
import 'package:flutter/material.dart';

/// Renders a formatted currency amount using [MoneyAmount.formatMinorUnits].
///
/// The text is rendered with tabular figures so that digits are mono-spaced for
/// alignment in lists and tables.
class CurrencyText extends StatelessWidget {
  const CurrencyText({
    super.key,
    required this.amountMinor,
    required this.currencyCode,
    this.style,
    this.compact = false,
  });

  /// Amount in integer minor units (e.g. cents).
  final int amountMinor;

  /// ISO 4217 currency code (e.g. `'INR'`, `'USD'`).
  final String currencyCode;

  /// Optional text style override. Tabular-figure font features are always
  /// appended.
  final TextStyle? style;

  /// Reserved for a future compact formatting mode.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = MoneyAmount.formatMinorUnits(amountMinor, currencyCode);

    final baseStyle = style ?? theme.textTheme.bodyMedium ?? const TextStyle();
    final tabulatedStyle = baseStyle.copyWith(
      fontFeatures: <FontFeature>[
        ...?baseStyle.fontFeatures,
        const FontFeature.tabularFigures(),
      ],
    );

    return Text(formatted, style: tabulatedStyle);
  }
}
