import 'package:flutter/material.dart';

import '../models/financial_models.dart';
import 'indian_bank_catalog.dart';

export 'indian_bank_catalog.dart';

/// Fetches the authentic original card color based on Issuing Bank & Variant.
CardColorMatch fetchOriginalCardColor(
  IndianBank bank,
  String cardTier, [
  CardSupplier? brand,
]) {
  final tierLower = cardTier.toLowerCase();
  final presets = bankCardVariants[bank] ?? const [];

  for (final preset in presets) {
    if (tierLower.contains(preset.name.toLowerCase())) {
      return preset.color;
    }
  }

  if (tierLower.contains('regalia') || tierLower.contains('gold')) {
    return const CardColorMatch(
      label: 'Champagne Gold',
      color: Color(0xFFE5D2AD),
      isLight: true,
      accentColor: Color(0xFF8A6814),
    );
  }
  if (tierLower.contains('white')) {
    return const CardColorMatch(
      label: 'Pearl White',
      color: Color(0xFFF2F2F5),
      isLight: true,
    );
  }
  if (tierLower.contains('infinia') ||
      tierLower.contains('black') ||
      tierLower.contains('reserve') ||
      tierLower.contains('zenith')) {
    return const CardColorMatch(
      label: 'Obsidian Gold',
      color: Color(0xFF15161A),
      isLight: false,
      accentColor: Color(0xFFD4AF37),
    );
  }
  if (tierLower.contains('amazon') ||
      tierLower.contains('flipkart') ||
      tierLower.contains('ace')) {
    return const CardColorMatch(
      label: 'Matte Charcoal',
      color: Color(0xFF1F2126),
      isLight: false,
    );
  }
  if (tierLower.contains('platinum') ||
      tierLower.contains('silver') ||
      tierLower.contains('titanium')) {
    return const CardColorMatch(
      label: 'Brushed Platinum',
      color: Color(0xFFE4E5EA),
      isLight: true,
    );
  }
  if (tierLower.contains('millennia') ||
      tierLower.contains('coral') ||
      tierLower.contains('rubyx')) {
    return const CardColorMatch(
      label: 'Crimson Slate',
      color: Color(0xFF6B1D2E),
      isLight: false,
    );
  }

  if (presets.isNotEmpty) {
    return presets.first.color;
  }

  if (brand == CardSupplier.amex) {
    return const CardColorMatch(
      label: 'Silver Titanium',
      color: Color(0xFFE4E5EA),
      isLight: true,
    );
  }

  return const CardColorMatch(
    label: 'Warm Sand',
    color: Color(0xFFDFD3C3),
    isLight: true,
  );
}

/// Returns an authentic card image URL if an official custom asset is defined for this variant.
String? fetchOriginalCardImageUrl(IndianBank bank, String cardTier) {
  final tierLower = cardTier.toLowerCase();
  final presets = bankCardVariants[bank] ?? const [];

  for (final preset in presets) {
    if (tierLower.contains(preset.name.toLowerCase()) &&
        preset.imageUrl != null) {
      return preset.imageUrl;
    }
  }

  return null;
}
