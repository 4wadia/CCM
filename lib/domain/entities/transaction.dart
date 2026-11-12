/// Canonical transaction types from the specification.
enum TransactionType {
  purchase,
  refund,
  reversal,
  payment,
  fee,
  interest,
  cashAdvance,
  emiConversion,
  adjustment,
  unknown;

  static TransactionType fromStorage(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => TransactionType.unknown,
    );
  }

  /// Whether a positive amount of this type increases what the user owes.
  bool get isDebit => switch (this) {
    TransactionType.purchase => true,
    TransactionType.fee => true,
    TransactionType.interest => true,
    TransactionType.cashAdvance => true,
    TransactionType.emiConversion => true,
    TransactionType.unknown => true,
    TransactionType.refund => false,
    TransactionType.reversal => false,
    TransactionType.payment => false,
    TransactionType.adjustment => true,
  };

  String get label => switch (this) {
    TransactionType.purchase => 'Purchase',
    TransactionType.refund => 'Refund',
    TransactionType.reversal => 'Reversal',
    TransactionType.payment => 'Payment',
    TransactionType.fee => 'Fee',
    TransactionType.interest => 'Interest',
    TransactionType.cashAdvance => 'Cash advance',
    TransactionType.emiConversion => 'EMI conversion',
    TransactionType.adjustment => 'Adjustment',
    TransactionType.unknown => 'Unknown',
  };
}

/// Lifecycle of a canonical transaction.
enum TransactionStatus {
  pending,
  posted,
  reversed,
  failed,
  needsReview;

  static TransactionStatus fromStorage(String value) {
    return TransactionStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => TransactionStatus.needsReview,
    );
  }

  String get label => switch (this) {
    TransactionStatus.pending => 'Pending',
    TransactionStatus.posted => 'Posted',
    TransactionStatus.reversed => 'Reversed',
    TransactionStatus.failed => 'Failed',
    TransactionStatus.needsReview => 'Needs review',
  };
}

/// Confidence assigned by an importer before a source is reconciled.
enum SourceConfidence {
  high,
  medium,
  low;

  static SourceConfidence fromStorage(String? value) {
    return SourceConfidence.values.firstWhere(
      (confidence) => confidence.name == value,
      orElse: () => SourceConfidence.low,
    );
  }
}

/// Where a raw record came from.
enum TransactionSourceType {
  sms,
  gmailStatement,
  pdfStatement,
  manual;

  static TransactionSourceType fromStorage(String value) {
    return TransactionSourceType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => TransactionSourceType.manual,
    );
  }

  String get label => switch (this) {
    TransactionSourceType.sms => 'SMS',
    TransactionSourceType.gmailStatement => 'Gmail statement',
    TransactionSourceType.pdfStatement => 'PDF statement',
    TransactionSourceType.manual => 'Manual',
  };
}

/// Match state of a raw source against the canonical ledger.
enum SourceMatchStatus {
  created,
  linkedExisting,
  ambiguous,
  ignored,
  failed;

  static SourceMatchStatus fromStorage(String value) {
    return SourceMatchStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => SourceMatchStatus.failed,
    );
  }
}

/// A canonical transaction. Amounts are signed integer minor units: debits
/// (purchases, fees, interest) are positive, credits (refunds, payments) are
/// negative. Never use floating point for these values.
class CardTransaction {
  const CardTransaction({
    required this.id,
    required this.amountMinor,
    required this.currencyCode,
    required this.transactionDate,
    required this.transactionType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.cardId,
    this.bankId,
    this.merchantOriginal,
    this.merchantNormalized,
    this.postingDate,
    this.categoryId,
    this.sourceConfidence,
    this.notes,
    this.fingerprint,
    this.fingerprintVersion,
  });

  final String id;
  final String? cardId;
  final String? bankId;
  final String? merchantOriginal;
  final String? merchantNormalized;
  final int amountMinor;
  final String currencyCode;
  final DateTime transactionDate;
  final DateTime? postingDate;
  final TransactionType transactionType;
  final String? categoryId;
  final TransactionStatus status;
  final SourceConfidence? sourceConfidence;
  final String? notes;
  final String? fingerprint;
  final int? fingerprintVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get displayMerchant => (merchantOriginal?.trim().isNotEmpty ?? false)
      ? merchantOriginal!.trim()
      : (merchantNormalized?.trim().isNotEmpty ?? false)
      ? merchantNormalized!.trim()
      : 'Unlabelled transaction';

  bool get isCredit => amountMinor < 0;

  bool get needsReview => status == TransactionStatus.needsReview;

  CardTransaction copyWith({
    String? cardId,
    String? bankId,
    String? merchantOriginal,
    String? merchantNormalized,
    int? amountMinor,
    String? currencyCode,
    DateTime? transactionDate,
    DateTime? postingDate,
    TransactionType? transactionType,
    String? categoryId,
    TransactionStatus? status,
    SourceConfidence? sourceConfidence,
    String? notes,
    String? fingerprint,
    int? fingerprintVersion,
    DateTime? updatedAt,
  }) {
    return CardTransaction(
      id: id,
      cardId: cardId ?? this.cardId,
      bankId: bankId ?? this.bankId,
      merchantOriginal: merchantOriginal ?? this.merchantOriginal,
      merchantNormalized: merchantNormalized ?? this.merchantNormalized,
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      transactionDate: transactionDate ?? this.transactionDate,
      postingDate: postingDate ?? this.postingDate,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      sourceConfidence: sourceConfidence ?? this.sourceConfidence,
      notes: notes ?? this.notes,
      fingerprint: fingerprint ?? this.fingerprint,
      fingerprintVersion: fingerprintVersion ?? this.fingerprintVersion,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Immutable audit record for a raw import.
class TransactionSource {
  const TransactionSource({
    required this.id,
    required this.sourceType,
    required this.originalDescription,
    required this.matchStatus,
    required this.createdAt,
    this.transactionId,
    this.sourceReference,
    this.sourceDate,
    this.importJobId,
    this.parserId,
    this.parserVersion,
  });

  final String id;
  final String? transactionId;
  final TransactionSourceType sourceType;
  final String? sourceReference;
  final DateTime? sourceDate;
  final String originalDescription;
  final String? importJobId;
  final String? parserId;
  final String? parserVersion;
  final SourceMatchStatus matchStatus;
  final DateTime createdAt;
}

/// A normalized record emitted by an SMS, statement, or manual parser before it
/// is reconciled with the canonical ledger.
class ParsedTransaction {
  const ParsedTransaction({
    required this.description,
    required this.amountMinor,
    required this.currencyCode,
    required this.transactionDate,
    required this.transactionType,
    required this.confidence,
    this.merchant,
    this.postingDate,
    this.cardLastFour,
    this.bankHint,
    this.sourceReference,
    this.parserId,
    this.parserVersion,
    this.notes,
    this.status,
  });

  final String description;
  final int amountMinor;
  final String currencyCode;
  final DateTime transactionDate;
  final DateTime? postingDate;
  final TransactionType transactionType;
  final SourceConfidence confidence;
  final String? merchant;
  final String? cardLastFour;
  final String? bankHint;
  final String? sourceReference;
  final String? parserId;
  final String? parserVersion;
  final String? notes;

  /// Optional status supplied by a parser (for example a declined SMS alert).
  final TransactionStatus? status;

  /// Debits are positive and credits negative in the canonical ledger.
  int get signedAmountMinor =>
      transactionType.isDebit ? amountMinor.abs() : -amountMinor.abs();
}

/// Query filters used by the transaction list and CSV export.
class TransactionFilter {
  const TransactionFilter({
    this.cardId,
    this.bankId,
    this.categoryId,
    this.merchant,
    this.from,
    this.to,
    this.minAmountMinor,
    this.maxAmountMinor,
    this.types = const <TransactionType>{},
    this.status,
    this.sourceType,
    this.reviewOnly = false,
    this.unassignedOnly = false,
  });

  final String? cardId;
  final String? bankId;
  final String? categoryId;
  final String? merchant;
  final DateTime? from;
  final DateTime? to;
  final int? minAmountMinor;
  final int? maxAmountMinor;
  final Set<TransactionType> types;
  final TransactionStatus? status;
  final TransactionSourceType? sourceType;
  final bool reviewOnly;
  final bool unassignedOnly;

  bool get hasFilters =>
      cardId != null ||
      bankId != null ||
      categoryId != null ||
      (merchant != null && merchant!.trim().isNotEmpty) ||
      from != null ||
      to != null ||
      minAmountMinor != null ||
      maxAmountMinor != null ||
      types.isNotEmpty ||
      status != null ||
      sourceType != null ||
      reviewOnly ||
      unassignedOnly;
}
