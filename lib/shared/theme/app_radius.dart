import 'package:flutter/painting.dart';

/// Design tokens for border radii.
///
/// Generous, modern radii inspired by Apple and Linear design systems.
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

  /// 20 logical pixels.
  static const double xl = 20;

  /// 24 logical pixels.
  static const double xxl = 24;

  /// 28 logical pixels.
  static const double xxxl = 28;

  /// Fully circular: 999.
  static const double full = 999;

  // ---------------------------------------------------------------------------
  // BorderRadius helpers
  // ---------------------------------------------------------------------------

  /// Card border radius: 20.
  static const BorderRadius card = BorderRadius.all(Radius.circular(xl));

  /// Credit card face radius: 16.
  static const BorderRadius cardFace = BorderRadius.all(Radius.circular(lg));

  /// Button border radius: 12.
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));

  /// Input border radius: 12.
  static const BorderRadius input = BorderRadius.all(Radius.circular(md));

  /// Chip / badge border radius: 8.
  static const BorderRadius chip = BorderRadius.all(Radius.circular(sm));

  /// Dialog border radius: 24.
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xxl));

  /// Bottom sheet top corners: 28.
  static const BorderRadius bottomSheet = BorderRadius.all(
    Radius.circular(xxxl),
  );

  /// Fully circular.
  static const BorderRadius circular = BorderRadius.all(Radius.circular(full));
}
