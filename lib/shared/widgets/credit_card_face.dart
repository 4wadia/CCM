import 'package:material_ui/material_ui.dart';

import '../../../domain/entities/credit_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

/// A premium credit card visual representation.
///
/// Renders a realistic card face with gradient background, chip, network logo,
/// last-four digits, cardholder name, and used/available credit.
/// Aspect ratio 1.586:1 (ISO/IEC 7810 ID-1).
class CreditCardFace extends StatelessWidget {
  const CreditCardFace({
    super.key,
    required this.card,
    this.bankName,
    this.onTap,
    this.compact = false,
  });

  final CreditCard card;
  final String? bankName;
  final VoidCallback? onTap;

  /// When true, renders a smaller card suitable for lists.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = _gradientForNetwork(card.network);

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.586,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardFace,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            boxShadow: AppShadows.cardFace(isDark: isDark),
          ),
          child: Stack(
            children: [
              // Subtle noise/pattern overlay.
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: AppRadius.cardFace,
                  child: CustomPaint(painter: _CardPatternPainter()),
                ),
              ),
              // Card content.
              Padding(
                padding: EdgeInsets.all(compact ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: bank name + network.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            bankName ?? card.displayName,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: compact ? 12 : 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _NetworkLogo(
                          network: card.network,
                          size: compact ? 28 : 36,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Chip.
                    Container(
                      width: compact ? 32 : 40,
                      height: compact ? 24 : 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFD4AF37), Color(0xFFF0D675)],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: compact ? 18 : 22,
                          height: compact ? 14 : 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color: const Color(0xFFB8932C),
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 12 : 18),
                    // Card number (last four).
                    Text(
                      '•••• •••• •••• ${card.lastFour}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 16 : 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3.0,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    SizedBox(height: compact ? 6 : 10),
                    // Bottom row: cardholder + card name.
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.displayName.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: compact ? 9 : 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          card.currencyCode,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: compact ? 9 : 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<Color> _gradientForNetwork(CardNetwork network) {
    return switch (network) {
      CardNetwork.visa => AppColors.cardGradientSapphire,
      CardNetwork.mastercard => AppColors.cardGradientObsidian,
      CardNetwork.americanExpress => AppColors.cardGradientSlate,
      CardNetwork.rupay => AppColors.cardGradientEmerald,
      CardNetwork.discover => AppColors.cardGradientRose,
      CardNetwork.other => AppColors.cardGradientObsidian,
    };
  }
}

/// A minimal network logo rendered with text.
class _NetworkLogo extends StatelessWidget {
  const _NetworkLogo({required this.network, this.size = 36});

  final CardNetwork network;
  final double size;

  @override
  Widget build(BuildContext context) {
    final label = switch (network) {
      CardNetwork.visa => 'VISA',
      CardNetwork.mastercard => 'MC',
      CardNetwork.americanExpress => 'AMEX',
      CardNetwork.rupay => 'RuPay',
      CardNetwork.discover => 'DISC',
      CardNetwork.other => '···',
    };

    return Container(
      height: size * 0.65,
      padding: EdgeInsets.symmetric(horizontal: size * 0.2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size * 0.15),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: size * 0.3,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Subtle decorative pattern on the card face.
class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Subtle concentric arcs in the top-right corner.
    final center = Offset(size.width * 0.85, size.height * -0.15);
    for (var r = size.width * 0.3; r < size.width; r += size.width * 0.15) {
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
