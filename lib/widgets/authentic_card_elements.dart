import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';

/// Realistic EMV Smart Chip matching real physical credit cards
class EmvChipWidget extends StatelessWidget {
  final bool isGold;
  final double width;
  final double height;

  const EmvChipWidget({
    super.key,
    this.isGold = true,
    this.width = 38,
    this.height = 28,
  });

  @override
  Widget build(BuildContext context) {
    final baseGradient = isGold
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFDF7A),
              Color(0xFFD4AF37),
              Color(0xFFA67C1E),
              Color(0xFFE5C568),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF3F4F6),
              Color(0xFFD1D5DB),
              Color(0xFF9CA3AF),
              Color(0xFFE5E7EB),
            ],
          );

    final borderColor = isGold
        ? const Color(0xFF8B6B1B).withValues(alpha: 0.75)
        : const Color(0xFF6B7280).withValues(alpha: 0.75);

    final grooveColor = isGold
        ? const Color(0xFF6E5110).withValues(alpha: 0.65)
        : const Color(0xFF4B5563).withValues(alpha: 0.65);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: baseGradient,
        borderRadius: BorderRadius.circular(4.5),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _EmvChipGroovePainter(grooveColor: grooveColor),
      ),
    );
  }
}

class _EmvChipGroovePainter extends CustomPainter {
  final Color grooveColor;

  _EmvChipGroovePainter({required this.grooveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = grooveColor
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Horizontal center divider line
    canvas.drawLine(Offset(0, h * 0.5), Offset(w, h * 0.5), paint);

    // Left vertical contact dividers
    canvas.drawLine(Offset(w * 0.32, 0), Offset(w * 0.32, h * 0.35), paint);
    canvas.drawLine(Offset(w * 0.32, h * 0.65), Offset(w * 0.32, h), paint);

    // Right vertical contact dividers
    canvas.drawLine(Offset(w * 0.68, 0), Offset(w * 0.68, h * 0.35), paint);
    canvas.drawLine(Offset(w * 0.68, h * 0.65), Offset(w * 0.68, h), paint);

    // Center micro-pad rounded box
    final centerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.5),
        width: w * 0.36,
        height: h * 0.36,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(centerRect, paint);
  }

  @override
  bool shouldRepaint(covariant _EmvChipGroovePainter oldDelegate) =>
      oldDelegate.grooveColor != grooveColor;
}

/// Authentic Contactless NFC Waves symbol found on modern physical credit cards
class ContactlessWaveWidget extends StatelessWidget {
  final Color color;
  final double size;

  const ContactlessWaveWidget({
    super.key,
    this.color = Colors.white,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ContactlessWavePainter(color: color)),
    );
  }
}

class _ContactlessWavePainter extends CustomPainter {
  final Color color;

  _ContactlessWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(-size.width * 0.2, size.height * 0.5);
    final radii = [
      size.width * 0.42,
      size.width * 0.62,
      size.width * 0.82,
      size.width * 1.02,
    ];

    const sweepAngle = math.pi * 0.38;
    const startAngle = -sweepAngle / 2;

    for (final r in radii) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ContactlessWavePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Authentic Bank Logo Mark matching physical cards using official bank branding
class AuthenticBankLogo extends StatelessWidget {
  final IndianBank bank;
  final bool isLightCard;
  final double scale;

  const AuthenticBankLogo({
    super.key,
    required this.bank,
    this.isLightCard = false,
    this.scale = 1.0,
  });

  String _bankSlug(IndianBank bank) {
    return switch (bank) {
      IndianBank.hdfc => 'hdfc',
      IndianBank.icici => 'icici',
      IndianBank.sbi => 'sbi',
      IndianBank.axis => 'axis',
      IndianBank.kotak => 'kotak',
      IndianBank.indusInd => 'indusind',
      IndianBank.bob => 'bob',
      IndianBank.pnb => 'pnb',
      IndianBank.idfcFirst => 'idfc',
      IndianBank.rbl => 'rbl',
      IndianBank.yesBank => 'yes',
      IndianBank.auSmallFinance => 'au',
      IndianBank.federal => 'federal',
    };
  }

  @override
  Widget build(BuildContext context) {
    final slug = _bankSlug(bank);
    final assetPath = isLightCard
        ? 'assets/logos/banks/$slug.png'
        : 'assets/logos/banks/${slug}_white.png';

    final targetHeight = 18.0 * scale;

    return Image.asset(
      assetPath,
      height: targetHeight,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      errorBuilder: (context, error, stackTrace) => _buildFallback(context),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final textInk = isLightCard
        ? const Color(0xFF111113)
        : const Color(0xFFF8F7F4);

    switch (bank) {
      case IndianBank.hdfc:
        // Authentic HDFC Bank: Red square border, blue core, white cross + bold white text
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 17 * scale,
              height: 17 * scale,
              decoration: BoxDecoration(
                color: const Color(0xFF004C8F),
                borderRadius: BorderRadius.circular(2.5 * scale),
                border: Border.all(
                  color: const Color(0xFFED1C24),
                  width: 1.4 * scale,
                ),
              ),
              child: Center(
                child: Container(
                  width: 5.5 * scale,
                  height: 5.5 * scale,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'HDFC BANK',
              style: OnyxTypography.sans(
                fontSize: 12.5 * scale,
                fontWeight: FontWeight.w900,
                color: textInk,
                letterSpacing: 0.6,
              ),
            ),
          ],
        );

      case IndianBank.icici:
        // Authentic ICICI Bank: Orange rounded square with white 'i' + bold text
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 17 * scale,
              height: 17 * scale,
              decoration: BoxDecoration(
                color: const Color(0xFFF37021),
                borderRadius: BorderRadius.circular(3.5 * scale),
              ),
              child: Center(
                child: Text(
                  'i',
                  style: OnyxTypography.editorial(
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'ICICI Bank',
              style: OnyxTypography.sans(
                fontSize: 12.5 * scale,
                fontWeight: FontWeight.w800,
                color: textInk,
                letterSpacing: -0.2,
              ),
            ),
          ],
        );

      case IndianBank.sbi:
        // Authentic SBI Card: Electric cyan/blue circle with white keyhole
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 17 * scale,
              height: 17 * scale,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00B5EF),
              ),
              child: Center(
                child: Container(
                  width: 4.5 * scale,
                  height: 8.5 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2.5 * scale),
                      topRight: Radius.circular(2.5 * scale),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'SBI Card',
              style: OnyxTypography.sans(
                fontSize: 12.5 * scale,
                fontWeight: FontWeight.w900,
                color: textInk,
                letterSpacing: 0.4,
              ),
            ),
          ],
        );

      case IndianBank.axis:
        // Authentic Axis Bank: Rich burgundy inverted 'A' chevron
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(16 * scale, 16 * scale),
              painter: _AxisChevronPainter(color: const Color(0xFF97144D)),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'AXIS BANK',
              style: OnyxTypography.sans(
                fontSize: 12.5 * scale,
                fontWeight: FontWeight.w900,
                color: textInk,
                letterSpacing: 0.8,
              ),
            ),
          ],
        );

      case IndianBank.kotak:
        // Authentic Kotak: Red infinity loop
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '∞',
              style: OnyxTypography.sans(
                fontSize: 19 * scale,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFED1C24),
              ),
            ),
            SizedBox(width: 4 * scale),
            Text(
              'kotak',
              style: OnyxTypography.sans(
                fontSize: 12.5 * scale,
                fontWeight: FontWeight.w800,
                color: textInk,
                letterSpacing: -0.2,
              ),
            ),
          ],
        );

      case IndianBank.indusInd:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 17 * scale,
              height: 17 * scale,
              decoration: BoxDecoration(
                color: const Color(0xFF6E241B),
                borderRadius: BorderRadius.circular(3 * scale),
              ),
              child: Center(
                child: Icon(
                  Icons.shield,
                  size: 11 * scale,
                  color: const Color(0xFFD4AF37),
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'IndusInd Bank',
              style: OnyxTypography.sans(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w800,
                color: textInk,
              ),
            ),
          ],
        );

      case IndianBank.bob:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 17 * scale,
              height: 17 * scale,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF26522),
              ),
              child: Center(
                child: Icon(
                  Icons.wb_sunny,
                  size: 11 * scale,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'Bank of Baroda',
              style: OnyxTypography.sans(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w800,
                color: textInk,
              ),
            ),
          ],
        );

      case IndianBank.idfcFirst:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4 * scale,
                vertical: 2 * scale,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF8E1B32),
                borderRadius: BorderRadius.circular(2.5 * scale),
              ),
              child: Text(
                'FIRST',
                style: OnyxTypography.sans(
                  fontSize: 7.5 * scale,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'IDFC FIRST',
              style: OnyxTypography.sans(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w800,
                color: textInk,
              ),
            ),
          ],
        );

      case IndianBank.pnb:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 17 * scale,
              height: 17 * scale,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFA51D24),
              ),
              child: Center(
                child: Text(
                  'pnb',
                  style: OnyxTypography.sans(
                    fontSize: 8 * scale,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFD700),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'pnb',
              style: OnyxTypography.sans(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w800,
                color: textInk,
              ),
            ),
          ],
        );

      case IndianBank.federal:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 17 * scale,
              height: 17 * scale,
              decoration: BoxDecoration(
                color: const Color(0xFF004B87),
                borderRadius: BorderRadius.circular(3 * scale),
              ),
              child: Center(
                child: Icon(
                  Icons.shield_outlined,
                  size: 11 * scale,
                  color: const Color(0xFFFFC20E),
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'FEDERAL BANK',
              style: OnyxTypography.sans(
                fontSize: 11 * scale,
                fontWeight: FontWeight.w900,
                color: textInk,
                letterSpacing: 0.3,
              ),
            ),
          ],
        );

      case IndianBank.auSmallFinance:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 17 * scale,
              height: 17 * scale,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6A00), Color(0xFF6B1D74)],
                ),
              ),
              child: Center(
                child: Text(
                  'AU',
                  style: OnyxTypography.sans(
                    fontSize: 8.5 * scale,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5 * scale),
            Text(
              'AU BANK',
              style: OnyxTypography.sans(
                fontSize: 11.5 * scale,
                fontWeight: FontWeight.w900,
                color: textInk,
              ),
            ),
          ],
        );

      case IndianBank.yesBank:
        return Text(
          'YES BANK',
          style: OnyxTypography.sans(
            fontSize: 12.5 * scale,
            fontWeight: FontWeight.w900,
            color: textInk,
            letterSpacing: 0.8,
          ),
        );

      case IndianBank.rbl:
        return Text(
          'RBL BANK',
          style: OnyxTypography.sans(
            fontSize: 12.5 * scale,
            fontWeight: FontWeight.w900,
            color: textInk,
            letterSpacing: 0.8,
          ),
        );
    }
  }
}

class _AxisChevronPainter extends CustomPainter {
  final Color color;

  _AxisChevronPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.5, size.height * 0.45)
      ..lineTo(size.width * 0.6, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AxisChevronPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Authentic Card Tier Artwork matching the physical card face in user's pocket
class AuthenticCardTierArt extends StatelessWidget {
  final IndianBank bank;
  final String cardTier;
  final bool isLightCard;
  final double scale;

  const AuthenticCardTierArt({
    super.key,
    required this.bank,
    required this.cardTier,
    this.isLightCard = false,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final tierLower = cardTier.toLowerCase();

    // 1. Amazon Pay ICICI (Trademark white 'amazon' + bold 'pay' with yellow curved arrow smile)
    if (tierLower.contains('amazon')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'amazon',
                style: OnyxTypography.sans(
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(width: 2 * scale),
              Text(
                'pay',
                style: OnyxTypography.sans(
                  fontSize: 16.5 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * scale),
          // Amazon Signature Curved Arrow Smile
          CustomPaint(
            size: Size(38 * scale, 7 * scale),
            painter: _AmazonSmileArrowPainter(color: const Color(0xFFFF9900)),
          ),
        ],
      );
    }

    // 2. HDFC Infinia Metal (Gold foil luxury serif typography with Metal badge)
    if (tierLower.contains('infinia')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'I N F I N I A',
            style: OnyxTypography.editorial(
              fontSize: 19 * scale,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.8,
              color: const Color(0xFFE5C578),
            ),
          ),
          SizedBox(height: 3 * scale),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5 * scale,
              vertical: 1.5 * scale,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5 * scale),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.65),
                width: 0.8 * scale,
              ),
              color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
            ),
            child: Text(
              'METAL EDITION',
              style: OnyxTypography.mono(
                fontSize: 7.5 * scale,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: const Color(0xFFE5C578),
              ),
            ),
          ),
        ],
      );
    }

    // 3. SBI Cashback (Dynamic electric cyan italic with speed lines)
    if (tierLower.contains('cashback')) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3 * scale,
            height: 18 * scale,
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF),
              borderRadius: BorderRadius.circular(1.5 * scale),
            ),
          ),
          SizedBox(width: 5 * scale),
          Text(
            'CASHBACK',
            style: OnyxTypography.sans(
              fontSize: 17 * scale,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: Colors.white,
            ).copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      );
    }

    // 4. HDFC Diners Club Black
    if (tierLower.contains('diners')) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Diners split globe emblem
          Container(
            width: 22 * scale,
            height: 22 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0079C1),
                width: 1.5 * scale,
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF0079C1), Color(0xFF002244)],
              ),
            ),
            child: Center(
              child: Container(
                width: 2 * scale,
                height: 18 * scale,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Diners Club',
                style: OnyxTypography.editorial(
                  fontSize: 13 * scale,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF3F4F6),
                ),
              ),
              Text(
                'BLACK',
                style: OnyxTypography.sans(
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                  color: const Color(0xFFE5C578),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // 5. HDFC Regalia Gold
    if (tierLower.contains('regalia')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                size: 14 * scale,
                color: const Color(0xFFE5C578),
              ),
              SizedBox(width: 4 * scale),
              Text(
                'REGALIA',
                style: OnyxTypography.editorial(
                  fontSize: 15 * scale,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: const Color(0xFFE5C578),
                ),
              ),
            ],
          ),
          Text(
            'GOLD',
            style: OnyxTypography.mono(
              fontSize: 9.5 * scale,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: const Color(0xFFF8F7F4),
            ),
          ),
        ],
      );
    }

    // 6. HDFC Millennia
    if (tierLower.contains('millennia')) {
      return Text(
        'millennia',
        style: OnyxTypography.sans(
          fontSize: 18 * scale,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
      );
    }

    // 7. Axis Magnus
    if (tierLower.contains('magnus')) {
      return Text(
        'M A G N U S',
        style: OnyxTypography.editorial(
          fontSize: 17 * scale,
          fontWeight: FontWeight.w600,
          letterSpacing: 3.2,
          color: const Color(0xFFE5C578),
        ),
      );
    }

    // 8. Axis Atlas (Aviation compass motif)
    if (tierLower.contains('atlas')) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.explore_outlined,
            size: 16 * scale,
            color: const Color(0xFFE5C578),
          ),
          SizedBox(width: 6 * scale),
          Text(
            'A T L A S',
            style: OnyxTypography.sans(
              fontSize: 15 * scale,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.6,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    // 9. Tata Neu Infinity
    if (tierLower.contains('neu')) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5 * scale,
              vertical: 2 * scale,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(4 * scale),
            ),
            child: Text(
              'neu',
              style: OnyxTypography.sans(
                fontSize: 11 * scale,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3B0764),
              ),
            ),
          ),
          SizedBox(width: 6 * scale),
          Text(
            'INFINITY',
            style: OnyxTypography.sans(
              fontSize: 13 * scale,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    // 10. Flipkart Axis
    if (tierLower.contains('flipkart')) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18 * scale,
            height: 18 * scale,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE500),
              borderRadius: BorderRadius.circular(3 * scale),
            ),
            child: Center(
              child: Text(
                'f',
                style: OnyxTypography.sans(
                  fontSize: 13 * scale,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF2874F0),
                ),
              ),
            ),
          ),
          SizedBox(width: 6 * scale),
          Text(
            'Flipkart',
            style: OnyxTypography.sans(
              fontSize: 14 * scale,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ],
      );
    }

    // 11. Kotak White Reserve
    if (tierLower.contains('white')) {
      return Text(
        'WHITE RESERVE',
        style: OnyxTypography.sans(
          fontSize: 14 * scale,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
          color: const Color(0xFF1E293B),
        ),
      );
    }

    // Default clean variant label
    return Text(
      cardTier.toUpperCase(),
      style: OnyxTypography.mono(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w700,
        color: isLightCard ? const Color(0xFF111113) : const Color(0xFFF8F7F4),
        letterSpacing: 1.4,
      ),
    );
  }
}

class _AmazonSmileArrowPainter extends CustomPainter {
  final Color color;

  _AmazonSmileArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(2, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 1.05,
        size.width * 0.85,
        size.height * 0.35,
      );

    canvas.drawPath(path, paint);

    // Arrow tip
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final tipPath = Path()
      ..moveTo(size.width * 0.72, size.height * 0.2)
      ..lineTo(size.width, size.height * 0.38)
      ..lineTo(size.width * 0.86, size.height * 0.85)
      ..close();

    canvas.drawPath(tipPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant _AmazonSmileArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Custom Background Texture Painters for Authentic Physical Cards
class PhysicalCardSurfacePainter extends CustomPainter {
  final IndianBank bank;
  final String cardTier;

  PhysicalCardSurfacePainter({required this.bank, required this.cardTier});

  @override
  void paint(Canvas canvas, Size size) {
    final tierLower = cardTier.toLowerCase();

    // 1. HDFC Infinia Metal Brushed Micro-Lines
    if (tierLower.contains('infinia') || tierLower.contains('metal')) {
      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.035)
        ..strokeWidth = 0.5;

      for (double y = 4; y < size.height; y += 4.5) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      }
      return;
    }

    // 2. Amazon Pay Carbon Weave Pattern
    if (tierLower.contains('amazon')) {
      final gridPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.03)
        ..strokeWidth = 0.6;

      for (double x = 0; x < size.width + size.height; x += 9) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x - size.height, size.height),
          gridPaint,
        );
      }
      return;
    }

    // 3. SBI Cashback Diagonal Speed Accent
    if (tierLower.contains('cashback')) {
      final slashPaint = Paint()
        ..color = const Color(0xFF00A3C4).withValues(alpha: 0.45)
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(size.width * 0.45, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width * 0.15, size.height)
        ..close();

      canvas.drawPath(path, slashPaint);
      return;
    }

    // 4. Axis Atlas Celestial Navigation Rings
    if (tierLower.contains('atlas')) {
      final ringPaint = Paint()
        ..color = const Color(0xFFD4AF37).withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final center = Offset(size.width * 0.85, size.height * 0.4);
      canvas.drawCircle(center, size.width * 0.22, ringPaint);
      canvas.drawCircle(center, size.width * 0.38, ringPaint);
      canvas.drawCircle(center, size.width * 0.55, ringPaint);
      return;
    }

    // 5. HDFC Regalia Gold Ornate Guilloche Waves
    if (tierLower.contains('regalia')) {
      final wavePaint = Paint()
        ..color = const Color(0xFFD4AF37).withValues(alpha: 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;

      for (int i = 0; i < 6; i++) {
        final path = Path()..moveTo(0, size.height * (0.2 + i * 0.12));
        for (double x = 0; x < size.width; x += 20) {
          path.relativeQuadraticBezierTo(10, 6 * (i % 2 == 0 ? 1 : -1), 20, 0);
        }
        canvas.drawPath(path, wavePaint);
      }
      return;
    }
  }

  @override
  bool shouldRepaint(covariant PhysicalCardSurfacePainter oldDelegate) =>
      oldDelegate.bank != bank || oldDelegate.cardTier != cardTier;
}
