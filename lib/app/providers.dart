import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/files/app_files.dart';
import '../core/secure_storage/database_key_provider.dart';
import '../data/database/app_database.dart';
import '../data/database/database_factory.dart';
import '../data/repositories/bank_repository_impl.dart';
import '../data/repositories/category_repository_impl.dart';
import '../data/repositories/credit_card_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/bank_repository.dart';
import '../domain/repositories/category_repository.dart';
import '../domain/repositories/credit_card_repository.dart';
import '../domain/repositories/settings_repository.dart';
import '../integrations/platform/secure_key_store.dart';

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
