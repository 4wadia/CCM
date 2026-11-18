import 'package:credit_card_manager/models/financial_models.dart';
import 'package:credit_card_manager/utils/indian_bank_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Indian bank and card catalogue', () {
    test('every bank has at least one selectable card variant', () {
      for (final bank in IndianBank.values) {
        final variants = bankCardVariants[bank];
        expect(
          variants,
          isNotNull,
          reason: '${bank.displayName} is missing from the catalogue',
        );
        expect(
          variants,
          isNotEmpty,
          reason: '${bank.displayName} has no card variants',
        );
      }
    });

    test('every bank has a catch-all card option', () {
      for (final bank in IndianBank.values) {
        final names = bankCardVariants[bank]!
            .map((variant) => variant.name)
            .toList();
        expect(
          names,
          contains('Other card'),
          reason: '${bank.displayName} cannot represent an unlisted product',
        );
      }
    });

    test('variant names are non-empty and unique within each bank', () {
      for (final bank in IndianBank.values) {
        final names = bankCardVariants[bank]!
            .map((variant) => variant.name.trim())
            .toList();
        expect(
          names.every((name) => name.isNotEmpty),
          isTrue,
          reason: '${bank.displayName} has an empty variant name',
        );
        expect(
          names.toSet().length,
          names.length,
          reason: '${bank.displayName} has duplicate variant names',
        );
      }
    });

    test('catalogue covers the major Indian credit-card issuers', () {
      expect(
        IndianBank.values,
        containsAll(<IndianBank>[
          IndianBank.hdfc,
          IndianBank.icici,
          IndianBank.sbi,
          IndianBank.axis,
          IndianBank.kotak,
          IndianBank.indusInd,
          IndianBank.idfcFirst,
          IndianBank.rbl,
          IndianBank.yesBank,
          IndianBank.federal,
          IndianBank.auSmallFinance,
          IndianBank.bob,
          IndianBank.pnb,
          IndianBank.canara,
          IndianBank.unionBank,
          IndianBank.standardChartered,
          IndianBank.hsbc,
          IndianBank.citibank,
          IndianBank.americanExpress,
          IndianBank.sbm,
          IndianBank.other,
        ]),
      );
    });

    test('every catalogue variant has a usable network and colour', () {
      for (final entry in bankCardVariants.entries) {
        for (final variant in entry.value) {
          expect(
            variant.name.trim(),
            isNotEmpty,
            reason: '${entry.key.displayName} has an unnamed variant',
          );
          expect(
            variant.color.color.a,
            greaterThan(0),
            reason: '${entry.key.displayName} / ${variant.name} has no colour',
          );
        }
      }
    });
  });
}
