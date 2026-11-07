import 'package:flutter/material.dart';

/// Design tokens for typography.
///
/// Uses the platform font stack. No font is fetched at runtime: the app is
/// local-first and must render correctly offline.
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
      displayLarge: style(
        base.displayLarge,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      displayMedium: style(
        base.displayMedium,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      displaySmall: style(
        base.displaySmall,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineLarge: style(
        base.headlineLarge,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineMedium: style(
        base.headlineMedium,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineSmall: style(
        base.headlineSmall,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleLarge: style(
        base.titleLarge,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: style(
        base.titleMedium,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleSmall: style(
        base.titleSmall,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
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
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.4,
      ),
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
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
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
