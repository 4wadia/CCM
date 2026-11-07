/// Formats a derived percentage for display.
///
/// This is presentation-only; financial money values never use `double`.
String formatPercent(double value) {
  final fixed = value.toStringAsFixed(1);
  final trimmed = fixed.endsWith('.0')
      ? fixed.substring(0, fixed.length - 2)
      : fixed;
  return '$trimmed%';
}
