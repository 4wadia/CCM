import '../entities/bank.dart';
import '../entities/credit_card.dart';

class CardMatch {
  const CardMatch({
    this.card,
    this.bankId,
    this.ambiguous = false,
    this.reason,
  });

  final CreditCard? card;
  final String? bankId;
  final bool ambiguous;
  final String? reason;

  bool get matched => card != null && !ambiguous;
}

/// Matches an imported record to a card using the specification's priority:
/// last four digits, then issuer/bank. It never guesses when more than one card
/// remains. No full card number is accepted or stored.
abstract final class CardMatcher {
  static CardMatch match({
    required String? lastFour,
    required String? bankHint,
    required List<CreditCard> cards,
    required List<Bank> banks,
  }) {
    final active = cards.where((card) => card.isActive).toList(growable: false);
    final suffix = _lastFour(lastFour);
    final hint = bankHint?.trim().toLowerCase() ?? '';

    var candidates = active;
    if (suffix != null) {
      candidates = candidates
          .where((card) => card.lastFour == suffix)
          .toList(growable: false);
    }

    if (hint.isNotEmpty) {
      final bankById = <String, Bank>{for (final bank in banks) bank.id: bank};
      final hinted = candidates
          .where((card) {
            final bank = bankById[card.bankId];
            return bank != null &&
                (bank.id.toLowerCase().contains(hint) ||
                    bank.displayName.toLowerCase().contains(hint));
          })
          .toList(growable: false);
      // An issuer hint narrows a multi-card suffix match. If it produces no
      // result, keep the suffix candidates for the ambiguity check below.
      if (hinted.isNotEmpty) candidates = hinted;
    }

    if (candidates.length == 1 && (suffix != null || hint.isNotEmpty)) {
      final card = candidates.single;
      return CardMatch(card: card, bankId: card.bankId);
    }

    if (candidates.length > 1) {
      return const CardMatch(
        ambiguous: true,
        reason: 'More than one card could match this record.',
      );
    }

    return const CardMatch(reason: 'No card could be matched to this record.');
  }

  static String? _lastFour(String? value) {
    if (value == null) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return null;
    return digits.substring(digits.length - 4);
  }
}
