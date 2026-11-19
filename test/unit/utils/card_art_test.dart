import 'package:credit_card_manager/models/financial_models.dart';
import 'package:credit_card_manager/utils/card_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns official artwork for curated HDFC and ICICI variants', () {
    expect(
      fetchOriginalCardImageUrl(IndianBank.hdfc, 'HDFC Infinia Metal'),
      contains('infinia-credit-card'),
    );
    expect(
      fetchOriginalCardImageUrl(IndianBank.hdfc, 'HDFC Tata Neu Infinity'),
      contains('tata-neu-i'),
    );
    expect(
      fetchOriginalCardImageUrl(IndianBank.icici, 'ICICI Sapphiro'),
      contains('sapphiro-pdp2.webp'),
    );
    expect(
      fetchOriginalCardImageUrl(
        IndianBank.icici,
        'ICICI Emeralde Private Metal',
      ),
      contains('emeralde-pdp-final.webp'),
    );
  });

  test('returns official artwork for SBI co-branded variants', () {
    expect(
      fetchOriginalCardImageUrl(IndianBank.sbi, 'SBI Eternal'),
      contains('front-eternal-card.png'),
    );
    expect(
      fetchOriginalCardImageUrl(IndianBank.sbi, 'SBI PhonePe SELECT BLACK'),
      contains('phonepe-select-black-card-face-min.png'),
    );
    expect(
      fetchOriginalCardImageUrl(IndianBank.sbi, 'SBI PhonePe PURPLE'),
      contains('phonepe-purple-card-face-min.png'),
    );
  });

  test('returns official artwork for both Swiggy HDFC variants', () {
    expect(
      fetchOriginalCardImageUrl(IndianBank.hdfc, 'HDFC Swiggy Ornge'),
      contains('card-facia-swiggy'),
    );
    expect(
      fetchOriginalCardImageUrl(IndianBank.hdfc, 'HDFC Swiggy BLCK'),
      contains('facia-swiggy-blck-cc'),
    );
  });

  test('keeps vertical SBI artwork in its native aspect ratio', () {
    expect(
      fetchOriginalCardAspectRatio(IndianBank.sbi, 'SBI Eternal'),
      closeTo(0.63, 0.001),
    );
    expect(
      fetchOriginalCardAspectRatio(IndianBank.sbi, 'SBI PhonePe PURPLE'),
      closeTo(0.63, 0.001),
    );
    expect(
      fetchOriginalCardAspectRatio(IndianBank.hdfc, 'HDFC Swiggy BLCK'),
      closeTo(1.586, 0.001),
    );
  });

  test('falls back to generated art for variants without a curated image', () {
    expect(fetchOriginalCardImageUrl(IndianBank.sbi, 'SBI ELITE'), isNull);
    expect(
      fetchOriginalCardImageUrl(IndianBank.slice, 'Slice UPI Credit Card'),
      isNull,
    );
    expect(fetchOriginalCardImageUrl(IndianBank.other, 'Other card'), isNull);
  });

  test('returns the variant colour for the selected product', () {
    final color = fetchOriginalCardColor(
      IndianBank.hdfc,
      'HDFC Infinia Metal',
      CardSupplier.visa,
    );
    expect(color.label, 'Obsidian Gold');
    expect(color.isLight, isFalse);
  });
}
