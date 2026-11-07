import 'package:flutter/material.dart';

/// Visual variants for [AppChip].
enum AppChipVariant {
  /// A toggleable filter chip.
  filter,

  /// A read-only status indicator chip.
  status,
}

/// A design-system chip used for filtering or displaying status labels.
///
/// All styling is derived from [Theme.of] except the optional [color] override
/// for status chips.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.variant = AppChipVariant.filter,
    this.isSelected = false,
    this.onTap,
    this.color,
    this.icon,
  });

  final String label;
  final AppChipVariant variant;
  final bool isSelected;
  final VoidCallback? onTap;

  /// Optional colour override, primarily for [AppChipVariant.status].
  final Color? color;

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case AppChipVariant.filter:
        return FilterChip(
          selected: isSelected,
          onSelected: onTap != null ? (_) => onTap!() : null,
          avatar: icon != null ? Icon(icon, size: 18) : null,
          label: Text(label),
        );
      case AppChipVariant.status:
        final chipColor = color ?? theme.colorScheme.secondaryContainer;
        final labelColor = color != null
            ? (ThemeData.estimateBrightnessForColor(color!) == Brightness.dark
                  ? Colors.white
                  : Colors.black)
            : theme.colorScheme.onSecondaryContainer;

        return Chip(
          avatar: icon != null ? Icon(icon, size: 16, color: labelColor) : null,
          backgroundColor: chipColor,
          side: BorderSide.none,
          labelStyle: theme.textTheme.labelSmall?.copyWith(color: labelColor),
          label: Text(label),
        );
    }
  }
}
