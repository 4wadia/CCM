import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../entities/transaction.dart';
import 'merchant_normalizer.dart';

/// Computes the versioned SHA-256 fingerprint used for exact duplicate checks.
///
/// The fingerprint deliberately includes the card, signed amount, currency,
/// posting day, normalized merchant, and transaction type. It is not a
/// substitute for reconciliation: fuzzy matches still require merchant and date
/// agreement before a source is linked.
abstract final class TransactionFingerprint {
  static const int currentVersion = 1;

  static String? compute({
    required String? cardId,
    required int amountMinor,
    required String currencyCode,
    required DateTime transactionDate,
    required String? merchant,
    required TransactionType type,
    int version = currentVersion,
  }) {
    if (cardId == null || cardId.trim().isEmpty) return null;
    final canonical = jsonEncode(<Object?>[
      version,
      cardId,
      amountMinor,
      currencyCode.toUpperCase(),
      _day(transactionDate),
      MerchantNormalizer.normalize(merchant),
      type.name,
    ]);
    return sha256.convert(utf8.encode(canonical)).toString();
  }

  static String _day(DateTime value) {
    final utc = value.toUtc();
    return '${utc.year.toString().padLeft(4, '0')}'
        '${utc.month.toString().padLeft(2, '0')}'
        '${utc.day.toString().padLeft(2, '0')}';
  }
}
