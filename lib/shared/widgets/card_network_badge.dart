import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:material_ui/material_ui.dart';

/// Displays a small coloured badge indicating the card network.
///
/// Brand colours are defined as local static constants because they represent
/// fixed network identities and cannot be derived from the app theme.
class CardNetworkBadge extends StatelessWidget {
  const CardNetworkBadge({super.key, required this.network, this.size = 24});

  final CardNetwork network;
  final double size;

  // Brand colours per network.
  static const Color _visaBlue = Color(0xFF1A1F71);
  static const Color _mastercardRed = Color(0xFFEB001B);
  static const Color _amexBlue = Color(0xFF006FCF);
  static const Color _rupayOrange = Color(0xFFF37021);
  static const Color _discoverOrange = Color(0xFFFF6600);
  static const Color _otherGrey = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = _colorForNetwork(network);

    final fontSize = (size * 0.4).clamp(8.0, 14.0);
    final labelStyle =
        theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ) ??
        TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        );

    return Container(
      height: size,
      constraints: BoxConstraints(minWidth: size),
      padding: EdgeInsets.symmetric(horizontal: size * 0.2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      alignment: Alignment.center,
      child: Text(_abbreviation(network), style: labelStyle),
    );
  }

  static Color _colorForNetwork(CardNetwork network) {
    switch (network) {
      case CardNetwork.visa:
        return _visaBlue;
      case CardNetwork.mastercard:
        return _mastercardRed;
      case CardNetwork.americanExpress:
        return _amexBlue;
      case CardNetwork.rupay:
        return _rupayOrange;
      case CardNetwork.discover:
        return _discoverOrange;
      case CardNetwork.other:
        return _otherGrey;
    }
  }

  static String _abbreviation(CardNetwork network) {
    switch (network) {
      case CardNetwork.visa:
        return 'VISA';
      case CardNetwork.mastercard:
        return 'MC';
      case CardNetwork.americanExpress:
        return 'AMEX';
      case CardNetwork.rupay:
        return 'RuPay';
      case CardNetwork.discover:
        return 'DISC';
      case CardNetwork.other:
        return '···';
    }
  }
}
