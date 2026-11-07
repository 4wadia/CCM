import 'package:flutter/painting.dart';

/// Design tokens for elevation shadows.
///
/// Each method accepts [isDark] to adapt shadow intensity for the current
/// brightness mode.
final class AppShadows {
  const AppShadows._();

  /// Small shadow: offset(0,1), blur 3.
  static BoxShadow sm({required bool isDark}) => BoxShadow(
    offset: const Offset(0, 1),
    blurRadius: 3,
    color: const Color(0xFF000000).withValues(alpha: isDark ? 0.3 : 0.08),
  );

  /// Medium shadow: offset(0,2), blur 8.
  static BoxShadow md({required bool isDark}) => BoxShadow(
    offset: const Offset(0, 2),
    blurRadius: 8,
    color: const Color(0xFF000000).withValues(alpha: isDark ? 0.4 : 0.12),
  );

  /// Large shadow: offset(0,4), blur 16.
  static BoxShadow lg({required bool isDark}) => BoxShadow(
    offset: const Offset(0, 4),
    blurRadius: 16,
    color: const Color(0xFF000000).withValues(alpha: isDark ? 0.5 : 0.16),
  );
}
