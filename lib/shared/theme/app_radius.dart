import 'package:flutter/painting.dart';

/// Design tokens for border radii used throughout the application.
final class AppRadius {
  const AppRadius._();

  // ---------------------------------------------------------------------------
  // Radius scale
  // ---------------------------------------------------------------------------

  /// 4 logical pixels.
  static const double xs = 4;

  /// 8 logical pixels.
  static const double sm = 8;

  /// 12 logical pixels.
  static const double md = 12;

  /// 16 logical pixels.
  static const double lg = 16;

  /// 18 logical pixels.
  static const double xl = 18;

  /// 24 logical pixels.
  static const double xxl = 24;

  /// Fully circular: 999.
  static const double full = 999;

  // ---------------------------------------------------------------------------
  // BorderRadius helpers
  // ---------------------------------------------------------------------------

  /// Card border radius: 12.
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));

  /// Button border radius: 12.
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));

  /// Input border radius: 12.
  static const BorderRadius input = BorderRadius.all(Radius.circular(md));

  /// Chip border radius: 8.
  static const BorderRadius chip = BorderRadius.all(Radius.circular(sm));

  /// Dialog border radius: 16.
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(lg));

  /// Bottom sheet border radius: 18.
  static const BorderRadius bottomSheet = BorderRadius.all(Radius.circular(xl));

  /// Fully circular border radius.
  static const BorderRadius circular = BorderRadius.all(Radius.circular(full));
}
