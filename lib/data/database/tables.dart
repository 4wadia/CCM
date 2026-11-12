import 'package:drift/drift.dart';

/// Banks known to the application.
///
/// Bank rows are created from verified adapters and from cards the user adds.
/// No bank-specific parsing lives here.
@DataClassName('BankRow')
class Banks extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text()();
  TextColumn get countryCode => text().withLength(min: 2, max: 2)();
  TextColumn get region => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Credit cards. Card numbers are never stored beyond the last four digits.
@DataClassName('CreditCardRow')
class CreditCards extends Table {
  TextColumn get id => text()();
  TextColumn get bankId => text().references(Banks, #id)();
  TextColumn get displayName => text()();
  TextColumn get cardholderName => text().nullable()();
  TextColumn get network => text()();
  TextColumn get lastFour => text().withLength(min: 4, max: 4)();
  IntColumn get creditLimitMinor => integer()();

  /// Reconciled current balance in minor units. Added in schema v2.
  IntColumn get currentOutstandingMinor =>
      integer().withDefault(const Constant(0))();

  TextColumn get currencyCode => text()();
  IntColumn get statementDay => integer().nullable()();
  IntColumn get dueDay => integer().nullable()();
  DateTimeColumn get billingCycleStart => dateTime().nullable()();
  DateTimeColumn get billingCycleEnd => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get rewardProgramme => text().nullable()();
  IntColumn get colorValue => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Transaction categories. System categories are seeded and cannot be deleted.
@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable().references(Categories, #id)();
  BoolColumn get isSystemCategory =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Canonical transactions. Source provenance lives in [TransactionSources].
@DataClassName('TransactionRow')
class Transactions extends Table {
  TextColumn get id => text()();

  /// Nullable: ambiguous imports remain unassigned until reviewed.
  TextColumn get cardId => text().nullable().references(CreditCards, #id)();
  TextColumn get bankId => text().nullable().references(Banks, #id)();
  TextColumn get merchantOriginal => text().nullable()();
  TextColumn get merchantNormalized => text().nullable()();
  IntColumn get amountMinor => integer()();
  TextColumn get currencyCode => text()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get postingDate => dateTime().nullable()();
  TextColumn get transactionType => text()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get status => text()();
  TextColumn get sourceConfidence => text().nullable()();
  TextColumn get notes => text().nullable()();

  /// SHA-256 fingerprint of normalized import fields. Added in schema v3.
  TextColumn get fingerprint => text().nullable()();

  /// Version of the fingerprint recipe. Bump when normalization changes.
  IntColumn get fingerprintVersion => integer().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Raw records from SMS, statement PDFs, or manual entry.
///
/// A canonical transaction can have multiple sources. Source rows are the audit
/// trail and are not silently rewritten.
@DataClassName('TransactionSourceRow')
class TransactionSources extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId =>
      text().nullable().references(Transactions, #id)();
  TextColumn get sourceType => text()();
  TextColumn get sourceReference => text().nullable()();
  DateTimeColumn get sourceDate => dateTime().nullable()();
  TextColumn get originalDescription => text()();
  TextColumn get importJobId => text().nullable().references(ImportJobs, #id)();
  TextColumn get parserId => text().nullable()();
  TextColumn get parserVersion => text().nullable()();
  TextColumn get matchStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Import job audit records. Jobs are idempotent and safe to retry.
@DataClassName('ImportJobRow')
class ImportJobs extends Table {
  TextColumn get id => text()();
  TextColumn get sourceType => text()();
  TextColumn get status => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get progress => integer().nullable()();
  IntColumn get recordsFound => integer().withDefault(const Constant(0))();
  IntColumn get recordsImported => integer().withDefault(const Constant(0))();
  IntColumn get recordsSkipped => integer().withDefault(const Constant(0))();
  IntColumn get recordsRequiringReview =>
      integer().withDefault(const Constant(0))();
  TextColumn get errorCode => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Application settings.
///
/// [encryptedValue] is reserved for values that must be encrypted even inside
/// the encrypted database (for example, a globally unique account identifier).
/// Secrets belong in platform secure storage, never here.
@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get id => text()();
  TextColumn get settingKey => text()();
  TextColumn get encryptedValue => text().nullable()();
  TextColumn get plainValue => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Ambiguous or incomplete imported records. Nothing is silently discarded.
@DataClassName('ReviewItemRow')
class ReviewItems extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text().nullable()();
  TextColumn get sourceType => text().nullable()();
  TextColumn get sourceReference => text().nullable()();
  TextColumn get reasonCode => text()();
  TextColumn get userMessage => text()();
  TextColumn get details => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Statement metadata and the opaque path of its encrypted PDF.
@DataClassName('StatementRow')
class Statements extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text().nullable().references(CreditCards, #id)();
  TextColumn get bankId => text().nullable().references(Banks, #id)();
  DateTimeColumn get statementPeriodStart => dateTime()();
  DateTimeColumn get statementPeriodEnd => dateTime()();
  DateTimeColumn get statementDate => dateTime()();
  DateTimeColumn get paymentDueDate => dateTime().nullable()();
  IntColumn get previousBalanceMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalDueMinor => integer().withDefault(const Constant(0))();
  IntColumn get minimumDueMinor => integer().withDefault(const Constant(0))();
  TextColumn get currencyCode => text()();
  TextColumn get encryptedFilePath => text()();
  TextColumn get fileHash => text()();
  IntColumn get fileSizeBytes => integer().withDefault(const Constant(0))();
  TextColumn get processingStatus => text()();
  TextColumn get parserId => text().nullable()();
  TextColumn get parserVersion => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Rows extracted from a statement before or after reconciliation.
@DataClassName('StatementTransactionRow')
class StatementTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get statementId => text().references(Statements, #id)();
  TextColumn get transactionId =>
      text().nullable().references(Transactions, #id)();
  TextColumn get description => text()();
  TextColumn get merchantNormalized => text().nullable()();
  IntColumn get amountMinor => integer()();
  TextColumn get currencyCode => text()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get postingDate => dateTime().nullable()();
  TextColumn get transactionType => text()();
  TextColumn get matchStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cashback ledger entries. Monetary values remain integer minor units.
@DataClassName('CashbackEntryRow')
class CashbackEntries extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text().references(CreditCards, #id)();
  TextColumn get transactionId =>
      text().nullable().references(Transactions, #id)();
  IntColumn get amountMinor => integer()();
  TextColumn get currencyCode => text()();
  TextColumn get status => text()();
  DateTimeColumn get earnedAt => dateTime()();
  DateTimeColumn get creditedAt => dateTime().nullable()();
  DateTimeColumn get reversedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One reward programme account per card programme.
@DataClassName('RewardAccountRow')
class RewardAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text().references(CreditCards, #id)();
  TextColumn get programmeName => text()();
  IntColumn get currentPoints => integer().withDefault(const Constant(0))();
  IntColumn get estimatedValueMinor => integer().nullable()();
  TextColumn get currencyCode => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Reward points earned, redeemed, expired, or manually adjusted.
@DataClassName('RewardEntryRow')
class RewardEntries extends Table {
  TextColumn get id => text()();
  TextColumn get rewardAccountId => text().references(RewardAccounts, #id)();
  TextColumn get transactionId =>
      text().nullable().references(Transactions, #id)();
  IntColumn get points => integer()();
  TextColumn get entryType => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Declarative, versioned bank rules. Never contains executable code.
@DataClassName('BankRuleRow')
class BankRules extends Table {
  TextColumn get id => text()();
  TextColumn get bankId => text().references(Banks, #id)();
  TextColumn get ruleType => text()();
  TextColumn get configurationVersion => text()();
  TextColumn get configuration => text()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Connected email account metadata. Tokens live only in secure storage; this
/// table stores an opaque reference, never a refresh or access token.
@DataClassName('EmailAccountRow')
class EmailAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get provider => text()();
  TextColumn get emailAddress => text()();
  TextColumn get secureTokenReference => text()();
  TextColumn get status => text().withDefault(const Constant('connected'))();
  BoolColumn get syncEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get connectedAt => dateTime()();
  DateTimeColumn get lastSuccessfulSync => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Resumable sync checkpoints, one row per email account.
@DataClassName('SyncCheckpointRow')
class SyncCheckpoints extends Table {
  TextColumn get id => text()();
  TextColumn get emailAccountId => text().references(EmailAccounts, #id)();
  TextColumn get providerCheckpoint => text().nullable()();
  DateTimeColumn get lastSyncStarted => dateTime().nullable()();
  DateTimeColumn get lastSyncCompleted => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get errorCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Declarative cashback policy. Percentages are basis points and caps are in
/// integer minor units; no floating point is used.
@DataClassName('CashbackRuleRow')
class CashbackRules extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text().references(CreditCards, #id)();
  TextColumn get kind => text()();
  IntColumn get rateBasisPoints => integer().nullable()();
  IntColumn get flatAmountMinor => integer().nullable()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get merchantContains => text().nullable()();
  IntColumn get monthlyCapMinor => integer().nullable()();
  TextColumn get currencyCode => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
