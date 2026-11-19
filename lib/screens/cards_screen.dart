import 'package:flutter/material.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';
import '../widgets/physical_credit_card.dart';

class CardsScreen extends StatelessWidget {
  final List<CreditCardModel> cards;
  final VoidCallback onOpenNewCardModal;
  final ValueChanged<CreditCardModel> onSelectCard;
  final ValueChanged<CreditCardModel>? onCompleteCard;
  final bool isDarkMode;

  const CardsScreen({
    super.key,
    required this.cards,
    required this.onOpenNewCardModal,
    required this.onSelectCard,
    this.onCompleteCard,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(isDarkMode);
    final scale = OnyxScale.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        scale.s(20),
        scale.s(16),
        scale.s(20),
        scale.s(110),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header
          Padding(
            padding: EdgeInsets.only(top: scale.s(6), bottom: scale.s(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -0.25),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Text(
                          '${cards.length} ACTIVE CARDS',
                          key: ValueKey(cards.length),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: OnyxTypography.mono(
                            fontSize: scale.s(11),
                            color: palette.mutedText,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: scale.s(4)),
                      Text(
                        'Your Cards',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: OnyxTypography.editorial(
                          fontSize: scale.s(34),
                          fontWeight: FontWeight.w600,
                          height: 1.05,
                          color: palette.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: scale.s(12)),
                GestureDetector(
                  onTap: onOpenNewCardModal,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale.s(16),
                      vertical: scale.s(10),
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFF111113),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: scale.s(16),
                          color: isDarkMode
                              ? const Color(0xFF111113)
                              : const Color(0xFFF8F7F4),
                        ),
                        SizedBox(width: scale.s(6)),
                        Text(
                          'Add Card',
                          style: OnyxTypography.sans(
                            fontSize: scale.s(13),
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? const Color(0xFF111113)
                                : const Color(0xFFF8F7F4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: scale.s(14)),

          if (cards.isEmpty)
            Container(
              padding: EdgeInsets.all(scale.s(22)),
              decoration: BoxDecoration(
                color: palette.cardSurface,
                borderRadius: BorderRadius.circular(scale.s(18)),
                border: Border.all(color: palette.gold.withValues(alpha: 0.25)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    size: scale.s(34),
                    color: palette.gold,
                  ),
                  SizedBox(height: scale.s(12)),
                  Text(
                    'No cards yet',
                    style: OnyxTypography.editorial(
                      fontSize: scale.s(22),
                      fontWeight: FontWeight.w600,
                      color: palette.primaryText,
                    ),
                  ),
                  SizedBox(height: scale.s(6)),
                  Text(
                    'Add your first card, or allow SMS access so the app can detect cards and transactions from your bank messages.',
                    textAlign: TextAlign.center,
                    style: OnyxTypography.sans(
                      fontSize: scale.s(12),
                      color: palette.mutedText,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: scale.s(16)),
                  GestureDetector(
                    onTap: onOpenNewCardModal,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: scale.s(18),
                        vertical: scale.s(10),
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF111113),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Add your first card',
                        style: OnyxTypography.sans(
                          fontSize: scale.s(13),
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? const Color(0xFF111113)
                              : const Color(0xFFF8F7F4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            // Vertical Stack of Original-Color Physical Cards (Tightly Spaced)
            for (int i = 0; i < cards.length; i++) ...[
              _AnimatedCardEntrance(
                key: ValueKey('card-entrance-${cards[i].id}'),
                index: i,
                child: PhysicalCreditCard(
                  card: cards[i],
                  onTap: () {
                    if (cards[i].isNeedsCompletion && onCompleteCard != null) {
                      onCompleteCard!(cards[i]);
                    } else {
                      onSelectCard(cards[i]);
                    }
                  },
                ),
              ),
              if (cards[i].isNeedsCompletion) ...[
                SizedBox(height: scale.s(6)),
                GestureDetector(
                  onTap: () => onCompleteCard?.call(cards[i]),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale.s(14),
                      vertical: scale.s(8),
                    ),
                    decoration: BoxDecoration(
                      color: palette.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(scale.s(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: scale.s(14),
                              color: palette.gold,
                            ),
                            SizedBox(width: scale.s(8)),
                            Text(
                              'COMPLETE SETUP · CHOOSE BANK & MODEL',
                              style: OnyxTypography.mono(
                                fontSize: scale.s(9.5),
                                fontWeight: FontWeight.w700,
                                color: palette.gold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: scale.s(16),
                          color: palette.gold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (i < cards.length - 1) SizedBox(height: scale.s(10)),
            ],
        ],
      ),
    );
  }
}

class _AnimatedCardEntrance extends StatelessWidget {
  final Widget child;
  final int index;

  const _AnimatedCardEntrance({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final staggerIndex = index > 5 ? 5 : index;
    final duration = Duration(milliseconds: 380 + (staggerIndex * 45));

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 18),
            child: Transform.scale(
              scale: 0.965 + (value * 0.035),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
