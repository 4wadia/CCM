import 'transaction.dart';

enum StatementProcessingStatus {
  downloaded,
  processing,
  needsReview,
  reconciled,
  failed;

  static StatementProcessingStatus fromStorage(String value) {
    return StatementProcessingStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => StatementProcessingStatus.failed,
    );
  }
}

enum StatementMatchStatus {
  unmatched,
  matched,
  ambiguous,
  imported,
  ignored;

  static StatementMatchStatus fromStorage(String value) {
    return StatementMatchStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => StatementMatchStatus.unmatched,
    );
  }
}

class Statement {
  const Statement({
    required this.id,
    required this.statementPeriodStart,
    required this.statementPeriodEnd,
    required this.statementDate,
    required this.currencyCode,
    required this.encryptedFilePath,
    required this.fileHash,
    required this.processingStatus,
    required this.createdAt,
    required this.updatedAt,
    this.cardId,
    this.bankId,
    this.paymentDueDate,
    this.previousBalanceMinor = 0,
    this.totalDueMinor = 0,
    this.minimumDueMinor = 0,
    this.fileSizeBytes = 0,
    this.parserId,
    this.parserVersion,
  });

  final String id;
  final String? cardId;
  final String? bankId;
  final DateTime statementPeriodStart;
  final DateTime statementPeriodEnd;
  final DateTime statementDate;
  final DateTime? paymentDueDate;
  final int previousBalanceMinor;
  final int totalDueMinor;
  final int minimumDueMinor;
  final String currencyCode;
  final String encryptedFilePath;
  final String fileHash;
  final int fileSizeBytes;
  final StatementProcessingStatus processingStatus;
  final String? parserId;
  final String? parserVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  Statement copyWith({
    String? cardId,
    String? bankId,
    DateTime? paymentDueDate,
    int? previousBalanceMinor,
    int? totalDueMinor,
    int? minimumDueMinor,
    StatementProcessingStatus? processingStatus,
    String? parserId,
    String? parserVersion,
    DateTime? updatedAt,
  }) {
    return Statement(
      id: id,
      cardId: cardId ?? this.cardId,
      bankId: bankId ?? this.bankId,
      statementPeriodStart: statementPeriodStart,
      statementPeriodEnd: statementPeriodEnd,
      statementDate: statementDate,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      previousBalanceMinor: previousBalanceMinor ?? this.previousBalanceMinor,
      totalDueMinor: totalDueMinor ?? this.totalDueMinor,
      minimumDueMinor: minimumDueMinor ?? this.minimumDueMinor,
      currencyCode: currencyCode,
      encryptedFilePath: encryptedFilePath,
      fileHash: fileHash,
      fileSizeBytes: fileSizeBytes,
      processingStatus: processingStatus ?? this.processingStatus,
      parserId: parserId ?? this.parserId,
      parserVersion: parserVersion ?? this.parserVersion,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class StatementTransaction {
  const StatementTransaction({
    required this.id,
    required this.statementId,
    required this.description,
    required this.amountMinor,
    required this.currencyCode,
    required this.transactionDate,
    required this.transactionType,
    required this.matchStatus,
    required this.createdAt,
    this.transactionId,
    this.merchantNormalized,
    this.postingDate,
  });

  final String id;
  final String statementId;
  final String? transactionId;
  final String description;
  final String? merchantNormalized;
  final int amountMinor;
  final String currencyCode;
  final DateTime transactionDate;
  final DateTime? postingDate;
  final TransactionType transactionType;
  final StatementMatchStatus matchStatus;
  final DateTime createdAt;
}

class ParsedStatement {
  const ParsedStatement({
    required this.periodStart,
    required this.periodEnd,
    required this.statementDate,
    required this.currencyCode,
    required this.transactions,
    this.paymentDueDate,
    this.previousBalanceMinor = 0,
    this.totalDueMinor = 0,
    this.minimumDueMinor = 0,
    this.cardLastFour,
    this.bankHint,
    this.parserId = 'generic-statement',
    this.parserVersion = '1',
  });

  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime statementDate;
  final DateTime? paymentDueDate;
  final int previousBalanceMinor;
  final int totalDueMinor;
  final int minimumDueMinor;
  final String currencyCode;
  final String? cardLastFour;
  final String? bankHint;
  final String parserId;
  final String parserVersion;
  final List<ParsedTransaction> transactions;
}
