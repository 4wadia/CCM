import 'package:flutter/widgets.dart';

/// Shared timing and easing for lightweight interface motion.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration navigation = Duration(milliseconds: 340);
  static const Duration progress = Duration(milliseconds: 520);

  static const Curve curve = Curves.easeOutCubic;
  static const Curve navigationCurve = Curves.easeInOutCubic;

  /// Respects the system's reduced-motion setting.
  static Duration effective(BuildContext context, Duration duration) {
    return MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
  }
}
