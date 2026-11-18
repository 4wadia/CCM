import 'package:flutter/material.dart';

import '../theme/onyx_theme.dart';

/// Luxury brand mark for Credit Card Manager (CCM).
///
/// Renders the iconic dual-card obsidian and gold insignia at any scale.
class AppLogo extends StatelessWidget {
  final double size;
  final bool withSquircle;
  final VoidCallback? onTap;

  const AppLogo({
    super.key,
    this.size = 36.0,
    this.withSquircle = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = Image.asset(
      withSquircle
          ? 'assets/logo/app_logo.png'
          : 'assets/logo/app_logo_transparent.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      cacheWidth: (size * 2.5).round(),
      cacheHeight: (size * 2.5).round(),
      errorBuilder: (context, error, stackTrace) =>
          _FallbackVectorLogo(size: size, withSquircle: withSquircle),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: image,
      );
    }
    return image;
  }
}

/// Fallback custom painted luxury card emblem if raster asset is unavailable.
class _FallbackVectorLogo extends StatelessWidget {
  final double size;
  final bool withSquircle;

  const _FallbackVectorLogo({required this.size, required this.withSquircle});

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(
      Theme.of(context).brightness == Brightness.dark,
    );
    return Container(
      width: size,
      height: size,
      decoration: withSquircle
          ? BoxDecoration(
              color: palette.isDarkMode
                  ? const Color(0xFF0D0E11)
                  : Colors.black,
              borderRadius: BorderRadius.circular(size * 0.22),
              border: Border.all(
                color: palette.gold.withValues(alpha: 0.35),
                width: size > 40 ? 1.5 : 1.0,
              ),
            )
          : null,
      child: Center(
        child: SizedBox(
          width: size * 0.65,
          height: size * 0.65,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Back card (gold)
              Transform.rotate(
                angle: 0.16,
                child: Container(
                  width: size * 0.52,
                  height: size * 0.34,
                  decoration: BoxDecoration(
                    color: palette.gold,
                    borderRadius: BorderRadius.circular(size * 0.06),
                  ),
                ),
              ),
              // Front card (dark with gold rim)
              Transform.rotate(
                angle: -0.10,
                child: Container(
                  width: size * 0.52,
                  height: size * 0.34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16171B),
                    borderRadius: BorderRadius.circular(size * 0.06),
                    border: Border.all(color: palette.gold, width: 1.2),
                  ),
                  child: Align(
                    alignment: const Alignment(-0.6, 0.0),
                    child: Container(
                      width: size * 0.11,
                      height: size * 0.08,
                      decoration: BoxDecoration(
                        color: palette.gold,
                        borderRadius: BorderRadius.circular(size * 0.02),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
