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

  test('falls back to generated art for variants without a curated image', () {
    expect(fetchOriginalCardImageUrl(IndianBank.sbi, 'SBI ELITE'), isNull);
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
