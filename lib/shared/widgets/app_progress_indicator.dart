import 'package:flutter/material.dart';

/// A horizontal progress bar with rounded corners, an animated foreground,
/// and optional percentage label.
///
/// The foreground colour automatically shifts from primary → warning → error
/// as [value] increases, making it ideal for credit-utilisation displays.
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
    this.foregroundColor,
    this.label,
    this.showLabel = false,
  });

  /// Progress value between `0.0` and `1.0`.
  final double value;

  /// Track height in logical pixels.
  final double height;

  /// Override for the background track colour.
  final Color? backgroundColor;

  /// Override for the filled bar colour. When `null` the colour is chosen
  /// automatically based on [value] thresholds.
  final Color? foregroundColor;

  /// Text displayed alongside the bar (e.g. `'75%'`).
  final String? label;

  /// Whether [label] is visible.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double clampedValue = value.clamp(0.0, 1.0);

    final effectiveBackground =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final effectiveForeground = foregroundColor ?? _autoColor(theme);

    final Widget bar = ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            // Background track
            Container(color: effectiveBackground),
            // Foreground bar
            FractionallySizedBox(
              widthFactor: clampedValue,
              child: Container(
                decoration: BoxDecoration(
                  color: effectiveForeground,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (showLabel && label != null) {
      return Row(
        children: [
          Expanded(child: bar),
          const SizedBox(width: 8),
          Text(
            label!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return bar;
  }

  /// Returns a colour based on the utilisation value:
  /// * `< 75 %` → primary
  /// * `75 – 90 %` → tertiary (used as warning)
  /// * `> 90 %` → error
  Color _autoColor(ThemeData theme) {
    if (value > 0.9) return theme.colorScheme.error;
    if (value >= 0.75) return theme.colorScheme.tertiary;
    return theme.colorScheme.primary;
  }
}
