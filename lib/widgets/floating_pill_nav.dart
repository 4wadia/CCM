import 'package:flutter/material.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';

class FloatingPillNav extends StatelessWidget {
  final ScreenId activeTab;
  final ValueChanged<ScreenId> onSelectTab;
  final bool isDarkMode;

  const FloatingPillNav({
    super.key,
    required this.activeTab,
    required this.onSelectTab,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final pillBackground = isDarkMode
        ? const Color(0xFF1C1C1F)
        : const Color(0xFFFFFFFF);
    final activeIndicator = isDarkMode
        ? const Color(0xFFF8F7F4)
        : const Color(0xFF111113);
    final activeTextColor = isDarkMode
        ? const Color(0xFF111113)
        : const Color(0xFFF8F7F4);
    final inactiveTextColor = isDarkMode
        ? const Color(0xFFF8F7F4).withValues(alpha: 0.65)
        : const Color(0xFF111113).withValues(alpha: 0.65);

    final scale = OnyxScale.of(context);
    final double pillWidth = scale.s(292);
    final double pillHeight = scale.s(48);
    final double padding = scale.s(4.5);
    final double indicatorWidth = (pillWidth - padding * 2) / 3;

    final Alignment indicatorAlignment = switch (activeTab) {
      ScreenId.home => Alignment.centerLeft,
      ScreenId.cards => Alignment.center,
      ScreenId.profile => Alignment.centerRight,
    };

    return RepaintBoundary(
      child: Container(
        width: pillWidth,
        height: pillHeight,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: pillBackground,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Stack(
          children: [
            // Sliding Active Pill Indicator
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: const Cubic(0.22, 1.0, 0.36, 1.0),
              alignment: indicatorAlignment,
              child: Container(
                width: indicatorWidth,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: activeIndicator,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),

            // Nav Tab Labels
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelectTab(ScreenId.home),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: OnyxTypography.sans(
                          fontSize: scale.s(12),
                          fontWeight: FontWeight.w600,
                          color: activeTab == ScreenId.home
                              ? activeTextColor
                              : inactiveTextColor,
                        ),
                        child: const Text('Home'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelectTab(ScreenId.cards),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: OnyxTypography.sans(
                          fontSize: scale.s(12),
                          fontWeight: FontWeight.w600,
                          color: activeTab == ScreenId.cards
                              ? activeTextColor
                              : inactiveTextColor,
                        ),
                        child: const Text('Cards'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelectTab(ScreenId.profile),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: OnyxTypography.sans(
                          fontSize: scale.s(12),
                          fontWeight: FontWeight.w600,
                          color: activeTab == ScreenId.profile
                              ? activeTextColor
                              : inactiveTextColor,
                        ),
                        child: const Text('Profile'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
