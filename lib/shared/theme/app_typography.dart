import 'package:material_ui/material_ui.dart';

/// Premium typography system.
///
/// Uses the system font stack with carefully tuned sizes, weights, and spacing
/// to create clear visual hierarchy and a refined reading experience.
abstract final class AppTypography {
  static TextTheme textTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    final base = Typography.material2021().black;

    TextStyle? style(
      TextStyle? source, {
      required double fontSize,
      required FontWeight fontWeight,
      required Color color,
      double? height,
      double? letterSpacing,
    }) {
      return source?.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    return TextTheme(
      // Hero amounts — dashboard totals.
      displayLarge: style(
        base.displayLarge,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -1.0,
        height: 1.1,
      ),
      // Section headings.
      displayMedium: style(
        base.displayMedium,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.5,
        height: 1.15,
      ),
      // Sub-heading.
      displaySmall: style(
        base.displaySmall,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.3,
        height: 1.2,
      ),
      // Page titles.
      headlineLarge: style(
        base.headlineLarge,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.3,
      ),
      headlineMedium: style(
        base.headlineMedium,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.2,
      ),
      headlineSmall: style(
        base.headlineSmall,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      // Card / section titles.
      titleLarge: style(
        base.titleLarge,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.2,
      ),
      titleMedium: style(
        base.titleMedium,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.1,
      ),
      titleSmall: style(
        base.titleSmall,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      // Body.
      bodyLarge: style(
        base.bodyLarge,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        height: 1.5,
      ),
      bodyMedium: style(
        base.bodyMedium,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        height: 1.5,
      ),
      bodySmall: style(
        base.bodySmall,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.4,
      ),
      // Labels & captions.
      labelLarge: style(
        base.labelLarge,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      labelMedium: style(
        base.labelMedium,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      labelSmall: style(
        base.labelSmall,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.3,
      ),
    );
  }

  /// Numeric text with tabular figures so amounts align in lists.
  static TextStyle numericDisplay({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
