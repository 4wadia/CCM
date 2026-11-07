import 'dart:ui';

/// Design tokens for all color values used across the application.
///
/// Defines both light and dark palettes plus semantic card-network colors.
final class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------------
  // Light palette
  // ---------------------------------------------------------------------------

  /// Off-white background.
  static const Color background = Color(0xFFFAFAF8);

  /// White surface.
  static const Color surface = Color(0xFFFFFFFF);

  /// Slight warm gray surface variant.
  static const Color surfaceVariant = Color(0xFFF5F5F3);

  /// Muted emerald primary.
  static const Color primary = Color(0xFF4A9E7E);

  /// Light emerald tint container.
  static const Color primaryContainer = Color(0xFFE0F2EC);

  /// White on-primary.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Near-black text.
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Medium gray text.
  static const Color textSecondary = Color(0xFF6B6B6B);

  /// Light gray text.
  static const Color textTertiary = Color(0xFF9E9E9E);

  /// Subtle border.
  static const Color border = Color(0xFFE5E5E5);

  /// Very subtle border.
  static const Color borderLight = Color(0xFFF0F0F0);

  /// Divider.
  static const Color divider = Color(0xFFEEEEEE);

  /// Error red.
  static const Color error = Color(0xFFDC3545);

  /// Warning amber.
  static const Color warning = Color(0xFFF5A623);

  /// Success emerald (same as primary).
  static const Color success = Color(0xFF4A9E7E);

  /// Info blue.
  static const Color info = Color(0xFF5B9BD5);

  // ---------------------------------------------------------------------------
  // Dark palette
  // ---------------------------------------------------------------------------

  /// Near-black background.
  static const Color darkBackground = Color(0xFF1A1A1A);

  /// Dark gray surface.
  static const Color darkSurface = Color(0xFF242424);

  /// Slightly lighter surface variant.
  static const Color darkSurfaceVariant = Color(0xFF2E2E2E);

  /// Lighter emerald for dark mode.
  static const Color darkPrimary = Color(0xFF5FB896);

  /// Dark emerald container.
  static const Color darkPrimaryContainer = Color(0xFF1E3A2F);

  /// White on-primary for dark mode.
  static const Color darkOnPrimary = Color(0xFFFFFFFF);

  /// Off-white primary text for dark mode.
  static const Color darkTextPrimary = Color(0xFFF0F0F0);

  /// Medium gray secondary text for dark mode.
  static const Color darkTextSecondary = Color(0xFFA0A0A0);

  /// Darker gray tertiary text for dark mode.
  static const Color darkTextTertiary = Color(0xFF6B6B6B);

  /// Subtle dark border.
  static const Color darkBorder = Color(0xFF3A3A3A);

  /// Very subtle dark border.
  static const Color darkBorderLight = Color(0xFF333333);

  /// Dark divider.
  static const Color darkDivider = Color(0xFF353535);

  /// Lighter red for dark mode.
  static const Color darkError = Color(0xFFE5646E);

  /// Lighter amber for dark mode.
  static const Color darkWarning = Color(0xFFF5B74E);

  /// Dark mode success (same as darkPrimary).
  static const Color darkSuccess = Color(0xFF5FB896);

  /// Lighter blue for dark mode.
  static const Color darkInfo = Color(0xFF6CAAE0);

  // ---------------------------------------------------------------------------
  // Card network colors
  // ---------------------------------------------------------------------------

  /// Visa brand blue.
  static const Color visa = Color(0xFF1A1F71);

  /// Mastercard brand red.
  static const Color mastercard = Color(0xFFEB001B);

  /// American Express brand blue.
  static const Color amex = Color(0xFF006FCF);

  /// RuPay brand orange.
  static const Color rupay = Color(0xFFFF6600);

  /// Discover brand orange.
  static const Color discover = Color(0xFFFF6000);
}
