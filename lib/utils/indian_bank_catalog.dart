import 'package:flutter/material.dart';

import '../models/financial_models.dart';

/// Visual treatment used by the card face and the issue/complete previews.
class CardColorMatch {
  final String label;
  final Color color;
  final bool isLight;
  final Color? accentColor;

  const CardColorMatch({
    required this.label,
    required this.color,
    required this.isLight,
    this.accentColor,
  });
}

/// A card product offered by an issuing bank.
///
/// [defaultBrand] is only a starting point. The issue and completion dialogs
/// let the user override the network because the same product can be issued on
/// more than one network (for example Visa and RuPay).
class CardVariantPreset {
  final String name;
  final CardSupplier defaultBrand;
  final CardColorMatch color;
  final String? imageUrl;

  /// Aspect ratio of [imageUrl] when the card is issued in a vertical format.
  /// Standard horizontal card art uses the widget's default 1.586 ratio.
  final double? imageAspectRatio;

  const CardVariantPreset({
    required this.name,
    required this.defaultBrand,
    required this.color,
    this.imageUrl,
    this.imageAspectRatio,
  });
}

CardColorMatch _brandColor(CardSupplier brand) {
  return switch (brand) {
    CardSupplier.visa => const CardColorMatch(
      label: 'Deep Navy',
      color: Color(0xFF16233A),
      isLight: false,
    ),
    CardSupplier.mastercard => const CardColorMatch(
      label: 'Graphite',
      color: Color(0xFF23262E),
      isLight: false,
    ),
    CardSupplier.rupay => const CardColorMatch(
      label: 'Saffron Bronze',
      color: Color(0xFF7A3B16),
      isLight: false,
      accentColor: Color(0xFFE2B874),
    ),
    CardSupplier.amex => const CardColorMatch(
      label: 'Silver Titanium',
      color: Color(0xFFE4E5EA),
      isLight: true,
    ),
    CardSupplier.diners => const CardColorMatch(
      label: 'Jet Black',
      color: Color(0xFF121316),
      isLight: false,
      accentColor: Color(0xFFD4AF37),
    ),
  };
}

String _hdfcArt(String name) {
  return 'https://s7ap1.scene7.com/is/image/hdfcbankPWS/$name'
      '?fmt=png-alpha&wid=640&hei=403&fit=constrain';
}

String _iciciArt(String path) {
  return 'https://www.icici.bank.in/content/dam/icicibank/india/'
      'managed-assets/revamp-page-images/$path';
}

String _sbiArt(String path) {
  return 'https://www.sbicard.com/static-resources/img/$path';
}

CardVariantPreset _variant(
  String name,
  CardSupplier brand, {
  CardColorMatch? color,
  String? imageUrl,
  double? imageAspectRatio,
}) {
  return CardVariantPreset(
    name: name,
    defaultBrand: brand,
    color: color ?? _brandColor(brand),
    imageUrl: imageUrl,
    imageAspectRatio: imageAspectRatio,
  );
}

/// Curated catalogue of Indian credit-card products.
///
/// The list covers the major banks, public-sector issuers, foreign banks and
/// small finance banks that issue credit cards in India. Product names are
/// maintained here rather than being fetched from a remote service so the app
/// stays fully local-first. [IndianBank.other] is the fallback for anything not
/// listed yet.
final Map<IndianBank, List<CardVariantPreset>> _baseBankCardVariants = {
  IndianBank.hdfc: [
    _variant(
      'Infinia Metal',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Obsidian Gold',
        color: Color(0xFF15161A),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
      imageUrl: _hdfcArt('infinia-credit-card'),
    ),
    _variant(
      'Regalia Gold',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Champagne Gold',
        color: Color(0xFFE5D2AD),
        isLight: true,
        accentColor: Color(0xFF8A6814),
      ),
      imageUrl: _hdfcArt('regalia-gold-credit-card'),
    ),
    _variant(
      'Diners Club Black',
      CardSupplier.diners,
      color: const CardColorMatch(
        label: 'Jet Black',
        color: Color(0xFF121316),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
      imageUrl: _hdfcArt('diners-club-black'),
    ),
    _variant(
      'Millennia',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Deep Cobalt',
        color: Color(0xFF1E355E),
        isLight: false,
      ),
      imageUrl: _hdfcArt('millennia-credit-card'),
    ),
    _variant(
      'MoneyBack+',
      CardSupplier.visa,
      imageUrl: _hdfcArt('moneyback-plus-credit-card'),
    ),
    _variant(
      'Freedom',
      CardSupplier.visa,
      imageUrl: _hdfcArt('freedom-credit-card'),
    ),
    _variant(
      'Tata Neu Infinity',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Royal Plum',
        color: Color(0xFF3C1942),
        isLight: false,
        accentColor: Color(0xFFE2B874),
      ),
      imageUrl: _hdfcArt('tata-neu-i'),
    ),
    _variant(
      'Tata Neu Plus',
      CardSupplier.rupay,
      imageUrl: _hdfcArt('tata-neu-p'),
    ),
    _variant(
      'Swiggy Ornge',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Swiggy Orange',
        color: Color(0xFFD9480F),
        isLight: false,
      ),
      imageUrl: _hdfcArt('card-facia-swiggy'),
    ),
    _variant(
      'Swiggy BLCK',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Swiggy Black',
        color: Color(0xFF121214),
        isLight: false,
        accentColor: Color(0xFFF5E6D3),
      ),
      imageUrl: _hdfcArt('facia-swiggy-blck-cc'),
    ),
    _variant(
      'Marriott Bonvoy',
      CardSupplier.visa,
      imageUrl: _hdfcArt('Card-Facia-Marriott-Bonvoy'),
    ),
    _variant('IndiGo 6E Rewards', CardSupplier.visa),
    _variant(
      'Shoppers Stop',
      CardSupplier.visa,
      imageUrl: _hdfcArt('Card-Facia-Shoppers-Stop-Blue'),
    ),
    _variant(
      'IRCTC',
      CardSupplier.rupay,
      imageUrl: _hdfcArt('Card-Facia-IRCTC'),
    ),
  ],
  IndianBank.icici: [
    _variant(
      'Emeralde Private Metal',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Deep Emerald',
        color: Color(0xFF14332A),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
      imageUrl: _iciciArt('emeralde/emeralde-pdp-final.webp'),
    ),
    _variant(
      'Sapphiro',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Sapphire Blue',
        color: Color(0xFF15345C),
        isLight: false,
      ),
      imageUrl: _iciciArt('sapphiro-pdp2.webp'),
    ),
    _variant(
      'Rubyx',
      CardSupplier.amex,
      color: const CardColorMatch(
        label: 'Ruby Garnet',
        color: Color(0xFF6E1828),
        isLight: false,
      ),
      imageUrl: _iciciArt('rubyx-pdp2.webp'),
    ),
    _variant(
      'Coral',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Coral Crimson',
        color: Color(0xFF8A2B2B),
        isLight: false,
      ),
      imageUrl: _iciciArt('coral-pdp2.webp'),
    ),
    _variant(
      'Amazon Pay',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Matte Charcoal',
        color: Color(0xFF1F2126),
        isLight: false,
        accentColor: Color(0xFFF59E0B),
      ),
    ),
    _variant('MakeMyTrip', CardSupplier.visa),
    _variant('Adani One', CardSupplier.visa),
    _variant('HPCL', CardSupplier.rupay),
    _variant('Manchester United', CardSupplier.visa),
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
  ],
  IndianBank.sbi: [
    _variant(
      'Eternal',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Eternal Black',
        color: Color(0xFF111114),
        isLight: false,
        accentColor: Color(0xFFC9CBD1),
      ),
      imageUrl: _sbiArt(
        'card/product-detail-assets/all-other-cards-left-banners/'
        'eternal-sbi-card/front-eternal-card.png',
      ),
      imageAspectRatio: 0.63,
    ),
    _variant(
      'PhonePe SELECT BLACK',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'PhonePe Midnight',
        color: Color(0xFF0B1220),
        isLight: false,
        accentColor: Color(0xFF7C5CFF),
      ),
      imageUrl: _sbiArt(
        'card/card-face-assets/for-website/front/vertical/'
        'phonepe-select-black-card-face-min.png',
      ),
      imageAspectRatio: 0.63,
    ),
    _variant(
      'PhonePe PURPLE',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'PhonePe Purple',
        color: Color(0xFF4A1E6B),
        isLight: false,
        accentColor: Color(0xFFB983FF),
      ),
      imageUrl: _sbiArt(
        'card/card-face-assets/for-website/front/vertical/'
        'phonepe-purple-card-face-min.png',
      ),
      imageAspectRatio: 0.63,
    ),
    _variant(
      'Aurum',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Espresso Bronze',
        color: Color(0xFF261A14),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant(
      'ELITE',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'SBI Azure Navy',
        color: Color(0xFF173B70),
        isLight: false,
      ),
    ),
    _variant(
      'PRIME',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Graphite Slate',
        color: Color(0xFF23262E),
        isLight: false,
      ),
    ),
    _variant(
      'SimplyCLICK',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Electric Blue',
        color: Color(0xFF1B4F8C),
        isLight: false,
      ),
    ),
    _variant(
      'Cashback',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Cobalt Indigo',
        color: Color(0xFF223466),
        isLight: false,
      ),
    ),
    _variant('SimplySAVE', CardSupplier.visa),
    _variant('Paytm SBI Card', CardSupplier.visa),
    _variant('BPCL', CardSupplier.rupay),
    _variant('IRCTC', CardSupplier.rupay),
    _variant('Air India', CardSupplier.visa),
    _variant('Ola Money', CardSupplier.visa),
    _variant('Reliance SBI Card', CardSupplier.visa),
    _variant('Titan', CardSupplier.visa),
    _variant('Shaurya', CardSupplier.rupay),
  ],
  IndianBank.axis: [
    _variant(
      'Magnus',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Imperial Maroon',
        color: Color(0xFF381426),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant(
      'Atlas',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Axis Burgundy',
        color: Color(0xFF5E1633),
        isLight: false,
      ),
    ),
    _variant('Reserve', CardSupplier.visa),
    _variant('Burgundy Private', CardSupplier.visa),
    _variant(
      'ACE',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Onyx Slate',
        color: Color(0xFF1A1D24),
        isLight: false,
      ),
    ),
    _variant(
      'Flipkart Axis',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Royal Cobalt',
        color: Color(0xFF183B75),
        isLight: false,
      ),
    ),
    _variant('Airtel Axis', CardSupplier.mastercard),
    _variant('My Zone', CardSupplier.visa),
    _variant('Neo', CardSupplier.visa),
    _variant('Privilege', CardSupplier.visa),
    _variant('Samsung Axis', CardSupplier.visa),
    _variant('IndianOil Axis', CardSupplier.rupay),
  ],
  IndianBank.kotak: [
    _variant('Infiniti', CardSupplier.visa),
    _variant(
      'White Reserve',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Pearl White',
        color: Color(0xFFF2F2F5),
        isLight: true,
      ),
    ),
    _variant(
      'Zen Signature',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Midnight Indigo',
        color: Color(0xFF1C2333),
        isLight: false,
      ),
    ),
    _variant(
      'Mojo Platinum',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Kotak Crimson',
        color: Color(0xFF7A1622),
        isLight: false,
      ),
    ),
    _variant(
      'League Platinum',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Gunmetal',
        color: Color(0xFF262933),
        isLight: false,
      ),
    ),
    _variant('Royale Signature', CardSupplier.visa),
    _variant('PVR Kotak', CardSupplier.visa),
    _variant('IndiGo Kotak', CardSupplier.visa),
    _variant('Myntra Kotak', CardSupplier.visa),
    _variant('811 Dream Different', CardSupplier.visa),
  ],
  IndianBank.indusInd: [
    _variant(
      'Pinnacle',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Deep Slate',
        color: Color(0xFF1A2230),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant(
      'Legend',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'IndusInd Maroon',
        color: Color(0xFF571C24),
        isLight: false,
      ),
    ),
    _variant(
      'Tiger',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Amber Bronze',
        color: Color(0xFF332215),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant(
      'EazyDiner',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Terracotta Red',
        color: Color(0xFF6E241B),
        isLight: false,
      ),
    ),
    _variant('Nexxt', CardSupplier.visa),
    _variant('Indulge', CardSupplier.visa),
    _variant('InterMiles', CardSupplier.visa),
    _variant('Avios', CardSupplier.visa),
    _variant('Platinum', CardSupplier.visa),
    _variant('Samarth', CardSupplier.rupay),
  ],
  IndianBank.idfcFirst: [
    _variant(
      'Wealth',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'IDFC Ruby',
        color: Color(0xFF631422),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant(
      'Select',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Prussian Blue',
        color: Color(0xFF1D2D44),
        isLight: false,
      ),
    ),
    _variant(
      'Millennia',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Crimson Red',
        color: Color(0xFF751D2E),
        isLight: false,
      ),
    ),
    _variant(
      'FIRST Classic',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Steel Slate',
        color: Color(0xFF2B303A),
        isLight: false,
      ),
    ),
    _variant('Ashva', CardSupplier.visa),
    _variant('Mayura', CardSupplier.visa),
    _variant('SWYP', CardSupplier.visa),
    _variant('Power+', CardSupplier.visa),
    _variant('FIRST WOW', CardSupplier.rupay),
  ],
  IndianBank.rbl: [
    _variant(
      'World Safari',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Safari Navy',
        color: Color(0xFF1D344F),
        isLight: false,
      ),
    ),
    _variant(
      'Icon',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Carbon Black',
        color: Color(0xFF20232B),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant(
      'ShopRite',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Indigo Blue',
        color: Color(0xFF22356B),
        isLight: false,
      ),
    ),
    _variant('Platinum Maxima', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('SaveMax', CardSupplier.visa),
    _variant('Insignia', CardSupplier.visa),
    _variant('Play', CardSupplier.visa),
  ],
  IndianBank.yesBank: [
    _variant(
      'Marquee',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Yes Royal Navy',
        color: Color(0xFF14284B),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant(
      'Reserve',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Deep Midnight',
        color: Color(0xFF1B2234),
        isLight: false,
      ),
    ),
    _variant(
      'ACE',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Sapphire Navy',
        color: Color(0xFF1D4278),
        isLight: false,
      ),
    ),
    _variant('Yes Private', CardSupplier.visa),
    _variant('First Preferred', CardSupplier.visa),
    _variant('Premia', CardSupplier.visa),
    _variant('Select', CardSupplier.visa),
    _variant('Byepass', CardSupplier.visa),
  ],
  IndianBank.federal: [
    _variant(
      'Celesta',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Federal Navy',
        color: Color(0xFF17365D),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant(
      'Imperio',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Maritime Blue',
        color: Color(0xFF20426B),
        isLight: false,
      ),
    ),
    _variant(
      'Signet',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Slate Blue',
        color: Color(0xFF27384D),
        isLight: false,
      ),
    ),
    _variant('Scapia', CardSupplier.visa),
    _variant('OneCard', CardSupplier.visa),
    _variant('Fi Money', CardSupplier.visa),
    _variant('Jupiter Edge', CardSupplier.visa),
    _variant('Wave', CardSupplier.visa),
  ],
  IndianBank.auSmallFinance: [
    _variant(
      'Zenith+',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'AU Royal Plum',
        color: Color(0xFF3C194D),
        isLight: false,
        accentColor: Color(0xFFD4AF37),
      ),
    ),
    _variant('Zenith', CardSupplier.visa),
    _variant(
      'Vetta',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Velvet Purple',
        color: Color(0xFF522463),
        isLight: false,
      ),
    ),
    _variant(
      'LIT',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Copper Rust',
        color: Color(0xFF5C2B16),
        isLight: false,
      ),
    ),
    _variant('Altura', CardSupplier.visa),
    _variant('Altura Plus', CardSupplier.visa),
    _variant('InstaPay', CardSupplier.visa),
    _variant('Business', CardSupplier.visa),
  ],
  IndianBank.bob: [
    _variant(
      'Eterna',
      CardSupplier.visa,
      color: const CardColorMatch(
        label: 'Baroda Vermilion',
        color: Color(0xFF9E3418),
        isLight: false,
      ),
    ),
    _variant(
      'Premier',
      CardSupplier.mastercard,
      color: const CardColorMatch(
        label: 'Sunset Copper',
        color: Color(0xFFB8491D),
        isLight: false,
      ),
    ),
    _variant(
      'Easy',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Terracotta Orange',
        color: Color(0xFFC95322),
        isLight: false,
      ),
    ),
    _variant('Select', CardSupplier.visa),
    _variant('IRCTC', CardSupplier.rupay),
    _variant('HPCL', CardSupplier.rupay),
    _variant('Signature', CardSupplier.visa),
  ],
  IndianBank.pnb: [
    _variant(
      'RuPay Select',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'PNB Maroon',
        color: Color(0xFF6B1929),
        isLight: false,
      ),
    ),
    _variant(
      'Platinum',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Brushed Silver',
        color: Color(0xFFDCE0E6),
        isLight: true,
      ),
    ),
    _variant(
      'Raksha',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Service Navy',
        color: Color(0xFF1B3554),
        isLight: false,
      ),
    ),
    _variant('Pride', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('Global', CardSupplier.visa),
  ],
  IndianBank.canara: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('Travel', CardSupplier.visa),
    _variant('Rewards', CardSupplier.visa),
  ],
  IndianBank.unionBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('Jeevan', CardSupplier.rupay),
    _variant('Rewards', CardSupplier.visa),
  ],
  IndianBank.bankOfIndia: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('Star', CardSupplier.visa),
  ],
  IndianBank.centralBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('Cent Bank', CardSupplier.visa),
  ],
  IndianBank.indianBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('IB Rewardz', CardSupplier.visa),
  ],
  IndianBank.indianOverseasBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('IOB Rewards', CardSupplier.visa),
  ],
  IndianBank.ucoBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('Signature', CardSupplier.visa),
  ],
  IndianBank.bankOfMaharashtra: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.punjabAndSindBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('Signature', CardSupplier.visa),
  ],
  IndianBank.idbi: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('WINGS', CardSupplier.visa),
  ],
  IndianBank.cityUnionBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.southIndianBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.karurVysyaBank: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.dcb: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.csb: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.bandhan: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.dbs: [
    _variant('Live Fresh', CardSupplier.visa),
    _variant('Treasures', CardSupplier.visa),
    _variant('Vantage', CardSupplier.visa),
    _variant('Altitude', CardSupplier.visa),
  ],
  IndianBank.standardChartered: [
    _variant('Ultimate', CardSupplier.visa),
    _variant('Smart', CardSupplier.visa),
    _variant('Manhattan', CardSupplier.visa),
    _variant('Priority', CardSupplier.visa),
    _variant('Rewards', CardSupplier.visa),
    _variant('EaseMyTrip', CardSupplier.visa),
    _variant('DigiSmart', CardSupplier.visa),
  ],
  IndianBank.hsbc: [
    _variant('Live+', CardSupplier.visa),
    _variant('Cashback', CardSupplier.visa),
    _variant('TravelOne', CardSupplier.visa),
    _variant('Premier', CardSupplier.visa),
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay', CardSupplier.rupay),
  ],
  IndianBank.citibank: [
    _variant('Prestige', CardSupplier.visa),
    _variant('PremierMiles', CardSupplier.visa),
    _variant('Cashback', CardSupplier.visa),
    _variant('Rewards', CardSupplier.visa),
    _variant('IndianOil', CardSupplier.visa),
  ],
  IndianBank.americanExpress: [
    _variant('Centurion', CardSupplier.amex),
    _variant('Platinum Charge', CardSupplier.amex),
    _variant('Platinum Travel', CardSupplier.amex),
    _variant('Gold Charge', CardSupplier.amex),
    _variant('Membership Rewards', CardSupplier.amex),
    _variant('SmartEarn', CardSupplier.amex),
  ],
  IndianBank.sbm: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('OneCard', CardSupplier.visa),
    _variant('Slice', CardSupplier.visa),
  ],
  IndianBank.equitas: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.ujjivan: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.jana: [
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.esaf: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
    _variant('Signature', CardSupplier.visa),
  ],
  IndianBank.suryoday: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.utkarsh: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.capitalSmallFinance: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.northEastSmallFinance: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.slice: [
    _variant(
      'UPI Credit Card',
      CardSupplier.rupay,
      color: const CardColorMatch(
        label: 'Super Slicer Magenta',
        color: Color(0xFFB000A6),
        isLight: false,
        accentColor: Color(0xFFFFD6FA),
      ),
    ),
  ],
  IndianBank.unitySmallFinance: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.shivalikSmallFinance: [
    _variant('Platinum', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
  IndianBank.other: [
    _variant('Credit Card', CardSupplier.visa),
    _variant('Platinum', CardSupplier.visa),
    _variant('Signature', CardSupplier.visa),
    _variant('RuPay Select', CardSupplier.rupay),
  ],
};

/// Adds a catch-all option to every bank so a newly launched or unlisted card
/// product never blocks the user from completing setup.
final Map<IndianBank, List<CardVariantPreset>> bankCardVariants = {
  for (final entry in _baseBankCardVariants.entries)
    entry.key: [
      ...entry.value,
      if (!entry.value.any((variant) => variant.name == 'Other card'))
        _variant('Other card', CardSupplier.visa),
    ],
};
