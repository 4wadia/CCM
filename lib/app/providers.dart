import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/files/app_files.dart';
import '../core/secure_storage/database_key_provider.dart';
import '../data/database/app_database.dart';
import '../data/database/database_factory.dart';
import '../data/repositories/bank_repository_impl.dart';
import '../data/repositories/category_repository_impl.dart';
import '../data/repositories/credit_card_repository_impl.dart';
import '../data/repositories/email_repository_impl.dart';
import '../data/repositories/import_repositories_impl.dart';
import '../data/repositories/reward_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../data/repositories/statement_repository_impl.dart';
import '../data/repositories/transaction_repository_impl.dart';
import '../domain/repositories/bank_repository.dart';
import '../domain/repositories/category_repository.dart';
import '../domain/repositories/credit_card_repository.dart';
import '../domain/repositories/email_account_repository.dart';
import '../domain/repositories/import_job_repository.dart';
import '../domain/repositories/reward_repository.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/repositories/statement_repository.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/services/cashback_application_service.dart';
import '../domain/services/import_service.dart';
import '../integrations/backup/backup_service.dart';
import '../integrations/backup/local_data_service.dart';
import '../integrations/gmail/gmail_client.dart';
import '../integrations/gmail/gmail_config.dart';
import '../integrations/gmail/gmail_sync_service.dart';
import '../integrations/gmail/oauth_service.dart';
import '../integrations/gmail/secure_token_store.dart';
import '../integrations/pdf/pdf_text_extractor.dart';
import '../integrations/pdf/statement_import_service.dart';
import '../integrations/platform/secure_key_store.dart';
import '../integrations/sms/sms_import_service.dart';
import '../integrations/sms/sms_platform.dart';
import '../integrations/storage/encrypted_file_store.dart';

/// Platform-backed database key. Overridden in tests.
final databaseKeyProviderProvider = Provider<DatabaseKeyProvider>(
  (ref) => const SecureKeyStore(),
);

/// Encrypted database, opened on first use.
///
/// Opened lazily; Cards and Home consume it through repository providers.
final appDatabaseProvider = FutureProvider<AppDatabase>((ref) async {
  final keyProvider = ref.watch(databaseKeyProviderProvider);
  final file = await appDatabaseFile();

  final database = await openEncryptedDatabase(
    file: file,
    keyProvider: keyProvider,
  );

  ref.onDispose(() {
    unawaited(database.close());
  });
  return database;
});

final databaseFileProvider = FutureProvider<File>((ref) => appDatabaseFile());

final bankRepositoryProvider = FutureProvider<BankRepository>((ref) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return BankRepositoryImpl(database);
});

final creditCardRepositoryProvider = FutureProvider<CreditCardRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return CreditCardRepositoryImpl(database);
});

final categoryRepositoryProvider = FutureProvider<CategoryRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return CategoryRepositoryImpl(database);
});

final settingsRepositoryProvider = FutureProvider<SettingsRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return SettingsRepositoryImpl(database);
});

final transactionRepositoryProvider = FutureProvider<TransactionRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return TransactionRepositoryImpl(database);
});

final importJobRepositoryProvider = FutureProvider<ImportJobRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return ImportJobRepositoryImpl(database);
});

final reviewRepositoryProvider = FutureProvider<ReviewRepository>((ref) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return ReviewRepositoryImpl(database);
});

final statementRepositoryProvider = FutureProvider<StatementRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return StatementRepositoryImpl(database);
});

final cashbackRepositoryProvider = FutureProvider<CashbackRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return CashbackRepositoryImpl(database);
});

final rewardRepositoryProvider = FutureProvider<RewardRepository>((ref) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return RewardRepositoryImpl(database);
});

final emailAccountRepositoryProvider = FutureProvider<EmailAccountRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return EmailAccountRepositoryImpl(database);
});

final bankRuleRepositoryProvider = FutureProvider<BankRuleRepository>((
  ref,
) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return BankRuleRepositoryImpl(database);
});

final importServiceProvider = FutureProvider<ImportService>((ref) async {
  return ImportService(
    transactions: await ref.watch(transactionRepositoryProvider.future),
    jobs: await ref.watch(importJobRepositoryProvider.future),
    reviews: await ref.watch(reviewRepositoryProvider.future),
    cards: await ref.watch(creditCardRepositoryProvider.future),
    banks: await ref.watch(bankRepositoryProvider.future),
    categories: await ref.watch(categoryRepositoryProvider.future),
  );
});

final cashbackApplicationServiceProvider =
    FutureProvider<CashbackApplicationService>((ref) async {
      return CashbackApplicationService(
        cashback: await ref.watch(cashbackRepositoryProvider.future),
        transactions: await ref.watch(transactionRepositoryProvider.future),
      );
    });

final smsPlatformProvider = Provider<SmsPlatform>(
  (ref) => MethodChannelSmsPlatform(),
);

final smsImportServiceProvider = FutureProvider<SmsImportService>((ref) async {
  return SmsImportService(
    platform: ref.watch(smsPlatformProvider),
    importer: await ref.watch(importServiceProvider.future),
    settings: await ref.watch(settingsRepositoryProvider.future),
    reviews: await ref.watch(reviewRepositoryProvider.future),
    banks: await ref.watch(bankRepositoryProvider.future),
  );
});

final fileKeyProviderProvider = Provider<FileKeyProvider>(
  (ref) => const SecureFileKeyProvider(),
);

final encryptedFileStoreProvider = Provider<EncryptedFileStore>((ref) {
  return EncryptedFileStore(keyProvider: ref.watch(fileKeyProviderProvider));
});

final pdfTextExtractorProvider = Provider<PdfTextExtractor>(
  (ref) => const SyncfusionPdfTextExtractor(),
);

final statementImportServiceProvider = FutureProvider<StatementImportService>((
  ref,
) async {
  return StatementImportService(
    files: ref.watch(encryptedFileStoreProvider),
    extractor: ref.watch(pdfTextExtractorProvider),
    statements: await ref.watch(statementRepositoryProvider.future),
    importer: await ref.watch(importServiceProvider.future),
    reviews: await ref.watch(reviewRepositoryProvider.future),
    jobs: await ref.watch(importJobRepositoryProvider.future),
    transactions: await ref.watch(transactionRepositoryProvider.future),
    cards: await ref.watch(creditCardRepositoryProvider.future),
    banks: await ref.watch(bankRepositoryProvider.future),
    bankRules: await ref.watch(bankRuleRepositoryProvider.future),
  );
});

final gmailConfigProvider = Provider<GmailConfig>(
  (ref) => GmailConfig.fromEnvironment(),
);

final secureTokenStoreProvider = Provider<SecureTokenStore>(
  (ref) => const FlutterSecureTokenStore(),
);

final oauthServiceProvider = Provider<OAuthService>((ref) {
  return GoogleOAuthService(config: ref.watch(gmailConfigProvider));
});

final gmailClientProvider = Provider<GmailClient>((ref) => GoogleGmailClient());

final gmailSyncServiceProvider = FutureProvider<GmailSyncService>((ref) async {
  return GmailSyncService(
    config: ref.watch(gmailConfigProvider),
    oauth: ref.watch(oauthServiceProvider),
    tokens: ref.watch(secureTokenStoreProvider),
    client: ref.watch(gmailClientProvider),
    accounts: await ref.watch(emailAccountRepositoryProvider.future),
    jobs: await ref.watch(importJobRepositoryProvider.future),
    reviews: await ref.watch(reviewRepositoryProvider.future),
    statements: await ref.watch(statementImportServiceProvider.future),
  );
});

final backupServiceProvider = FutureProvider<BackupService>((ref) async {
  return BackupService(
    db: await ref.watch(appDatabaseProvider.future),
    files: ref.watch(encryptedFileStoreProvider),
    tokens: ref.watch(secureTokenStoreProvider),
    emailAccounts: await ref.watch(emailAccountRepositoryProvider.future),
  );
});

final localDataServiceProvider = FutureProvider<LocalDataService>((ref) async {
  return LocalDataService(
    db: await ref.watch(appDatabaseProvider.future),
    databaseFile: await ref.watch(databaseFileProvider.future),
    databaseKeyProvider: ref.watch(databaseKeyProviderProvider),
    fileKeyProvider: ref.watch(fileKeyProviderProvider),
    files: ref.watch(encryptedFileStoreProvider),
    tokens: ref.watch(secureTokenStoreProvider),
    emailAccounts: await ref.watch(emailAccountRepositoryProvider.future),
  );
});
