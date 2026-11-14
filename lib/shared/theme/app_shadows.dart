import 'package:flutter/painting.dart';

/// Design tokens for elevation shadows.
///
/// Subtle, sophisticated shadows for a layered interface.
final class AppShadows {
  const AppShadows._();

  /// Subtle shadow for cards.
  static BoxShadow sm({required bool isDark}) => BoxShadow(
    offset: const Offset(0, 1),
    blurRadius: 3,
    spreadRadius: 0,
    color: const Color(0xFF0F172A).withValues(alpha: isDark ? 0.2 : 0.06),
  );

  /// Medium shadow for elevated elements.
  static BoxShadow md({required bool isDark}) => BoxShadow(
    offset: const Offset(0, 4),
    blurRadius: 12,
    spreadRadius: -2,
    color: const Color(0xFF0F172A).withValues(alpha: isDark ? 0.3 : 0.08),
  );

  /// Large shadow for modals and popovers.
  static BoxShadow lg({required bool isDark}) => BoxShadow(
    offset: const Offset(0, 8),
    blurRadius: 24,
    spreadRadius: -4,
    color: const Color(0xFF0F172A).withValues(alpha: isDark ? 0.4 : 0.12),
  );

  /// Card face shadow — subtle lift.
  static List<BoxShadow> cardFace({required bool isDark}) => [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 8,
      color: const Color(0xFF000000).withValues(alpha: isDark ? 0.3 : 0.08),
    ),
    BoxShadow(
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -4,
      color: const Color(0xFF000000).withValues(alpha: isDark ? 0.2 : 0.06),
    ),
  ];
}
