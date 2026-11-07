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
