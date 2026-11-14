import 'package:flutter/painting.dart';

/// Design tokens for consistent spacing.
///
/// Generous whitespace creates a premium, breathable layout.
final class AppSpacing {
  const AppSpacing._();

  // ---------------------------------------------------------------------------
  // Spacing scale
  // ---------------------------------------------------------------------------

  /// 2 logical pixels.
  static const double xxs = 2;

  /// 4 logical pixels.
  static const double xs = 4;

  /// 8 logical pixels.
  static const double sm = 8;

  /// 12 logical pixels.
  static const double md = 12;

  /// 16 logical pixels.
  static const double lg = 16;

  /// 20 logical pixels.
  static const double xl = 20;

  /// 24 logical pixels.
  static const double xxl = 24;

  /// 32 logical pixels.
  static const double xxxl = 32;

  /// 48 logical pixels.
  static const double xxxxl = 48;

  // ---------------------------------------------------------------------------
  // Page padding — generous horizontal padding for premium feel
  // ---------------------------------------------------------------------------

  /// Standard horizontal page padding.
  static const double pageHorizontal = 20;

  /// Standard page padding.
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: pageHorizontal,
    vertical: sm,
  );

  /// Standard card padding: all 16.
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// Standard list-item padding: horizontal 16, vertical 12.
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Section spacing: vertical 24.
  static const EdgeInsets sectionSpacing = EdgeInsets.symmetric(vertical: xxl);

  /// Small horizontal gap: 8.
  static const EdgeInsets smallGap = EdgeInsets.symmetric(horizontal: sm);

  /// Medium horizontal gap: 16.
  static const EdgeInsets mediumGap = EdgeInsets.symmetric(horizontal: lg);
}
