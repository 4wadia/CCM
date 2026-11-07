import 'package:flutter/material.dart';

/// A styled surface card with optional tap handling.
///
/// Reads styling from [Theme.of] so it works with any configured theme.
/// When [onTap] is provided the card wraps its content in an [InkWell] for
/// material splash feedback.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? padding;

  /// Defaults to `EdgeInsets.zero`.
  final EdgeInsetsGeometry? margin;

  /// Defaults to `BorderRadius.circular(12)`.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePadding = padding ?? const EdgeInsets.all(16);
    final effectiveMargin = margin ?? EdgeInsets.zero;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);

    final cardColor =
        theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
    final cardElevation = theme.cardTheme.elevation ?? 0;
    final cardShape = RoundedRectangleBorder(
      borderRadius: effectiveBorderRadius,
      side: theme.cardTheme.shape is RoundedRectangleBorder
          ? (theme.cardTheme.shape! as RoundedRectangleBorder).side
          : BorderSide.none,
    );

    Widget content = Padding(padding: effectivePadding, child: child);

    if (onTap != null) {
      content = InkWell(
        borderRadius: effectiveBorderRadius,
        onTap: onTap,
        child: content,
      );
    }

    return Padding(
      padding: effectiveMargin,
      child: Material(
        color: cardColor,
        elevation: cardElevation,
        shape: cardShape,
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );
  }
}
