import 'dart:ui';

/// Premium fintech design tokens.
///
/// Inspired by Stripe, Revolut, and Linear — neutral base with a single
/// accent, generous contrast, and restrained use of colour.
final class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------------
  // Light palette
  // ---------------------------------------------------------------------------

  /// Pure white background for maximum breathing room.
  static const Color background = Color(0xFFF8F9FA);

  /// Card / elevated surface.
  static const Color surface = Color(0xFFFFFFFF);

  /// Secondary surface for inputs, chips.
  static const Color surfaceVariant = Color(0xFFF1F3F5);

  /// Tertiary surface for subtle grouping.
  static const Color surfaceTertiary = Color(0xFFE9ECEF);

  /// Deep blue-black for premium feel.
  static const Color primary = Color(0xFF0A84FF);

  /// Lighter primary tint.
  static const Color primaryContainer = Color(0xFFE8F3FF);

  /// White on primary.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Near-black ink — richly dark without being pure black.
  static const Color textPrimary = Color(0xFF0F172A);

  /// Medium slate for secondary text.
  static const Color textSecondary = Color(0xFF64748B);

  /// Light gray for tertiary labels.
  static const Color textTertiary = Color(0xFF94A3B8);

  /// Very subtle border for card outlines.
  static const Color border = Color(0xFFE2E8F0);

  /// Lighter border for inner dividers.
  static const Color borderLight = Color(0xFFF1F5F9);

  /// Divider for list separators.
  static const Color divider = Color(0xFFF1F5F9);

  /// Semantic: error / high utilisation.
  static const Color error = Color(0xFFEF4444);

  /// Semantic: warning / approaching limit.
  static const Color warning = Color(0xFFF59E0B);

  /// Semantic: success / good standing.
  static const Color success = Color(0xFF10B981);

  /// Semantic: info / neutral emphasis.
  static const Color info = Color(0xFF3B82F6);

  // ---------------------------------------------------------------------------
  // Dark palette
  // ---------------------------------------------------------------------------

  /// Near-black background with a hint of blue.
  static const Color darkBackground = Color(0xFF0B0F19);

  /// Elevated surface.
  static const Color darkSurface = Color(0xFF141923);

  /// Secondary surface.
  static const Color darkSurfaceVariant = Color(0xFF1E2433);

  /// Tertiary surface.
  static const Color darkSurfaceTertiary = Color(0xFF262D3D);

  /// Blue accent for dark mode.
  static const Color darkPrimary = Color(0xFF5BA7FF);

  /// Dark primary container.
  static const Color darkPrimaryContainer = Color(0xFF0D2847);

  /// White on primary (dark mode).
  static const Color darkOnPrimary = Color(0xFFFFFFFF);

  /// Light text.
  static const Color darkTextPrimary = Color(0xFFF1F5F9);

  /// Muted text.
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  /// Dimmed text.
  static const Color darkTextTertiary = Color(0xFF64748B);

  /// Subtle borders.
  static const Color darkBorder = Color(0xFF1E293B);

  /// Very subtle borders.
  static const Color darkBorderLight = Color(0xFF1A2332);

  /// Divider.
  static const Color darkDivider = Color(0xFF1E293B);

  /// Dark mode error.
  static const Color darkError = Color(0xFFF87171);

  /// Dark mode warning.
  static const Color darkWarning = Color(0xFFFBBF24);

  /// Dark mode success.
  static const Color darkSuccess = Color(0xFF34D399);

  /// Dark mode info.
  static const Color darkInfo = Color(0xFF60A5FA);

  // ---------------------------------------------------------------------------
  // Card network colours (fixed brand identity)
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

  // ---------------------------------------------------------------------------
  // Card face gradient palettes
  // ---------------------------------------------------------------------------

  /// Obsidian — premium dark card gradient.
  static const List<Color> cardGradientObsidian = [
    Color(0xFF1A1F2E),
    Color(0xFF0F1318),
  ];

  /// Slate — sophisticated mid-tone.
  static const List<Color> cardGradientSlate = [
    Color(0xFF334155),
    Color(0xFF1E293B),
  ];

  /// Sapphire — deep blue.
  static const List<Color> cardGradientSapphire = [
    Color(0xFF1E40AF),
    Color(0xFF1E3A5F),
  ];

  /// Emerald — rich green.
  static const List<Color> cardGradientEmerald = [
    Color(0xFF065F46),
    Color(0xFF064E3B),
  ];

  /// Rose gold.
  static const List<Color> cardGradientRose = [
    Color(0xFF9F1239),
    Color(0xFF881337),
  ];
}
