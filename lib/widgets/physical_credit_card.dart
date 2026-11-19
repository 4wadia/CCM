import 'dart:io';

import 'package:flutter/material.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';
import '../utils/card_helpers.dart';
import 'authentic_card_elements.dart';

class CardSupplierMark extends StatelessWidget {
  final CardSupplier brand;
  final bool isLight;

  const CardSupplierMark({
    super.key,
    required this.brand,
    required this.isLight,
  });

  String _providerAssetPath(CardSupplier brand) {
    return switch (brand) {
      CardSupplier.visa =>
        isLight
            ? 'assets/logos/providers/visa.png'
            : 'assets/logos/providers/visa_white.png',
      CardSupplier.mastercard => 'assets/logos/providers/mastercard.png',
      CardSupplier.rupay =>
        isLight
            ? 'assets/logos/providers/rupay.png'
            : 'assets/logos/providers/rupay_white.png',
      CardSupplier.amex => 'assets/logos/providers/amex.png',
      CardSupplier.diners => 'assets/logos/providers/diners.png',
    };
  }

  Widget _buildFallback(BuildContext context) {
    final scale = OnyxScale.of(context);
    final textColor = isLight
        ? const Color(0xFF111113)
        : const Color(0xFFF8F7F4);
    switch (brand) {
      case CardSupplier.mastercard:
        return SizedBox(
          width: scale.s(32),
          height: scale.s(20),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: Container(
                  width: scale.s(20),
                  height: scale.s(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEB001B),
                  ),
                ),
              ),
              Positioned(
                left: scale.s(12),
                child: Container(
                  width: scale.s(20),
                  height: scale.s(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF79E1B),
                  ),
                ),
              ),
            ],
          ),
        );
      case CardSupplier.visa:
        return Text(
          'VISA',
          style: OnyxTypography.sans(
            fontSize: scale.s(16),
            fontWeight: FontWeight.w900,
            color: textColor,
            letterSpacing: -0.5,
          ).copyWith(fontStyle: FontStyle.italic),
        );
      default:
        return Text(
          brand.label.toUpperCase(),
          style: OnyxTypography.sans(
            fontSize: scale.s(13),
            fontWeight: FontWeight.w800,
            color: textColor,
            letterSpacing: 1.0,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = OnyxScale.of(context);
    final assetPath = _providerAssetPath(brand);

    final double targetHeight = switch (brand) {
      CardSupplier.visa => scale.s(20),
      CardSupplier.mastercard => scale.s(22),
      CardSupplier.rupay => scale.s(18),
      CardSupplier.amex => scale.s(20),
      CardSupplier.diners => scale.s(20),
    };

    return Image.asset(
      assetPath,
      height: targetHeight,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildFallback(context),
    );
  }
}

class PhysicalCreditCard extends StatefulWidget {
  final CreditCardModel card;
  final VoidCallback? onTap;
  final double aspectRatio;

  const PhysicalCreditCard({
    super.key,
    required this.card,
    this.onTap,
    this.aspectRatio = 1.586,
  });

  @override
  State<PhysicalCreditCard> createState() => _PhysicalCreditCardState();
}

class _PhysicalCreditCardState extends State<PhysicalCreditCard> {
  String? _loadedArtKey;
  bool _artLoaded = false;
  bool _artFailed = false;

  @override
  void didUpdateWidget(covariant PhysicalCreditCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldArt = oldWidget.card.cardImagePath ?? oldWidget.card.cardImageUrl;
    final newArt = widget.card.cardImagePath ?? widget.card.cardImageUrl;
    if (oldArt != newArt) {
      _loadedArtKey = null;
      _artLoaded = false;
      _artFailed = false;
    }
  }

  void _markArtLoaded(String key) {
    if (_artLoaded && _loadedArtKey == key) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _loadedArtKey = key;
        _artLoaded = true;
        _artFailed = false;
      });
    });
  }

  void _markArtFailed(String key) {
    if (_artFailed && _loadedArtKey == key) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _loadedArtKey = key;
        _artFailed = true;
        _artLoaded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final scale = OnyxScale.of(context);
    final originalColor = fetchOriginalCardColor(
      card.bankName,
      card.cardTier,
      card.brand,
    );
    final baseColor = card.isFrozen
        ? const Color(0xFF18181B)
        : (card.cardColorValue != null
              ? Color(card.cardColorValue!)
              : originalColor.color);

    final hasLocalImage =
        card.cardImagePath != null &&
        card.cardImagePath!.isNotEmpty &&
        File(card.cardImagePath!).existsSync();
    final effectiveImageUrl =
        card.cardImageUrl ??
        fetchOriginalCardImageUrl(card.bankName, card.cardTier);
    final hasNetworkImage =
        effectiveImageUrl != null && effectiveImageUrl.isNotEmpty;
    final artKey = hasLocalImage
        ? card.cardImagePath
        : (hasNetworkImage ? effectiveImageUrl : null);
    final hasArt = artKey != null;
    final showArt = hasArt && !_artFailed;
    final showGenerated = !showArt || !_artLoaded;

    final isLight = card.isFrozen
        ? false
        : (card.isLightCard ?? originalColor.isLight);
    final inkColor = isLight
        ? const Color(0xFF111113)
        : const Color(0xFFF8F7F4);

    final tierLower = card.cardTier.toLowerCase();
    final isSilverChip =
        tierLower.contains('cashback') ||
        tierLower.contains('white') ||
        tierLower.contains('platinum') ||
        tierLower.contains('millennia') ||
        isLight;

    final last4 = card.maskedNumber.length >= 4
        ? card.maskedNumber.substring(card.maskedNumber.length - 4)
        : '••••';

    final Widget generatedFace = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: scale.s(18),
        vertical: scale.s(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AuthenticBankLogo(
                bank: card.bankName,
                isLightCard: isLight,
                scale: scale.factor,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (card.contactlessEnabled)
                    ContactlessWaveWidget(
                      color: inkColor.withValues(alpha: 0.8),
                      size: scale.s(16),
                    ),
                  if (card.isFrozen) ...[
                    SizedBox(width: scale.s(6)),
                    Icon(
                      Icons.lock_outline,
                      size: scale.s(15),
                      color: const Color(0xFFF87171),
                    ),
                  ],
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: scale.s(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EmvChipWidget(
                  isGold: !isSilverChip,
                  width: scale.s(36),
                  height: scale.s(26),
                ),
                Flexible(
                  child: AuthenticCardTierArt(
                    bank: card.bankName,
                    cardTier: card.cardTier,
                    isLightCard: isLight,
                    scale: scale.factor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '•••• •••• •••• $last4',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(13.5),
                        fontWeight: FontWeight.w600,
                        color: inkColor,
                        letterSpacing: 2.0,
                        tabularFigures: true,
                      ),
                    ),
                    SizedBox(height: scale.s(4)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'VALID\nTHRU',
                          style: OnyxTypography.mono(
                            fontSize: scale.s(6.5),
                            color: inkColor.withValues(alpha: 0.65),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(width: scale.s(5)),
                        Text(
                          card.expiry.isNotEmpty ? card.expiry : '••/••',
                          style: OnyxTypography.mono(
                            fontSize: scale.s(11),
                            fontWeight: FontWeight.w600,
                            color: inkColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: scale.s(10)),
              CardSupplierMark(brand: card.brand, isLight: isLight),
            ],
          ),
        ],
      ),
    );

    final Widget cardBody = RepaintBoundary(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(scale.s(14)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(scale.s(14)),
            child: Stack(
              children: [
                if (showArt)
                  Positioned.fill(
                    child: Opacity(
                      opacity: _artLoaded ? 1 : 0,
                      child: hasLocalImage
                          ? Image.file(
                              File(card.cardImagePath!),
                              fit: BoxFit.cover,
                              cacheWidth: scale.s(700).round(),
                              frameBuilder:
                                  (context, child, frame, synchronous) {
                                    if (frame != null) {
                                      _markArtLoaded(artKey);
                                    }
                                    return child;
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                _markArtFailed(artKey);
                                return const SizedBox.shrink();
                              },
                            )
                          : Image.network(
                              effectiveImageUrl!,
                              fit: BoxFit.cover,
                              cacheWidth: scale.s(700).round(),
                              frameBuilder:
                                  (context, child, frame, synchronous) {
                                    if (frame != null) {
                                      _markArtLoaded(artKey);
                                    }
                                    return child;
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                _markArtFailed(artKey);
                                return const SizedBox.shrink();
                              },
                            ),
                    ),
                  ),

                // While official artwork loads (or if it fails) keep a complete,
                // generated card face instead of showing an empty coloured box.
                if (showGenerated) generatedFace,

                // Official card art already includes the bank and network
                // marks, so only add a quiet strip for the masked number.
                if (showArt && _artLoaded)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        scale.s(16),
                        scale.s(22),
                        scale.s(16),
                        scale.s(12),
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xB3000000)],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '•••• $last4',
                            style: OnyxTypography.mono(
                              fontSize: scale.s(11.5),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF8F7F4),
                              letterSpacing: 1.4,
                              tabularFigures: true,
                            ),
                          ),
                          if (card.expiry.isNotEmpty)
                            Text(
                              card.expiry,
                              style: OnyxTypography.mono(
                                fontSize: scale.s(10.5),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF8F7F4),
                                letterSpacing: 0.8,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                if (card.isFrozen)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.82),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: Color(0xFFF87171),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'CARD FROZEN',
                            style: OnyxTypography.mono(
                              fontSize: 12,
                              color: const Color(0xFFFCA5A5),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.onTap == null) return cardBody;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: cardBody,
    );
  }
}
