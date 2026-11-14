import 'package:material_ui/material_ui.dart';

/// Visual variants for [AppButton].
enum AppButtonVariant {
  /// Filled button with the theme's primary colour.
  primary,

  /// Outlined button.
  secondary,

  /// Text-only button.
  text,

  /// Filled button with the theme's error colour.
  destructive,
}

/// A design-system button that maps [AppButtonVariant] to the correct Material
/// button type, reading all styling from the current [Theme].
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  /// When `true` a small progress indicator replaces the content and the button
  /// is disabled.
  final bool isLoading;

  /// When `true` the button stretches to `double.infinity`.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final VoidCallback? effectiveOnPressed = isLoading ? null : onPressed;

    final Widget buttonChild = isLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _progressColor(theme),
            ),
          )
        : _buildLabel();

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = icon != null && !isLoading
            ? ElevatedButton.icon(
                onPressed: effectiveOnPressed,
                icon: Icon(icon),
                label: buttonChild,
              )
            : ElevatedButton(onPressed: effectiveOnPressed, child: buttonChild);
      case AppButtonVariant.secondary:
        button = icon != null && !isLoading
            ? OutlinedButton.icon(
                onPressed: effectiveOnPressed,
                icon: Icon(icon),
                label: buttonChild,
              )
            : OutlinedButton(onPressed: effectiveOnPressed, child: buttonChild);
      case AppButtonVariant.text:
        button = icon != null && !isLoading
            ? TextButton.icon(
                onPressed: effectiveOnPressed,
                icon: Icon(icon),
                label: buttonChild,
              )
            : TextButton(onPressed: effectiveOnPressed, child: buttonChild);
      case AppButtonVariant.destructive:
        button = icon != null && !isLoading
            ? ElevatedButton.icon(
                onPressed: effectiveOnPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                icon: Icon(icon),
                label: buttonChild,
              )
            : ElevatedButton(
                onPressed: effectiveOnPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                child: buttonChild,
              );
    }

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildLabel() {
    return Text(label);
  }

  Color _progressColor(ThemeData theme) {
    switch (variant) {
      case AppButtonVariant.primary:
        return theme.colorScheme.onPrimary;
      case AppButtonVariant.secondary:
        return theme.colorScheme.primary;
      case AppButtonVariant.text:
        return theme.colorScheme.primary;
      case AppButtonVariant.destructive:
        return theme.colorScheme.onError;
    }
  }
}
