// ignore_for_file: directives_ordering, prefer_initializing_formals
import 'dart:io';

import '../../core/secure_storage/database_key_provider.dart';
import '../../data/database/app_database.dart';
import '../../domain/repositories/email_account_repository.dart';
import '../gmail/secure_token_store.dart';
import '../storage/encrypted_file_store.dart';

/// Full local deletion. Destroys the encrypted database, statement files,
/// secure-storage keys, and Gmail tokens. There is no remote copy to delete.
class LocalDataService {
  LocalDataService({
    required AppDatabase db,
    required File databaseFile,
    required DatabaseKeyProvider databaseKeyProvider,
    required FileKeyProvider fileKeyProvider,
    required EncryptedFileStore files,
    required SecureTokenStore tokens,
    required EmailAccountRepository emailAccounts,
  }) : _db = db,
       _databaseFile = databaseFile,
       _databaseKeyProvider = databaseKeyProvider,
       _fileKeyProvider = fileKeyProvider,
       _files = files,
       _tokens = tokens,
       _emailAccounts = emailAccounts;

  final AppDatabase _db;
  final File _databaseFile;
  final DatabaseKeyProvider _databaseKeyProvider;
  final FileKeyProvider _fileKeyProvider;
  final EncryptedFileStore _files;
  final SecureTokenStore _tokens;
  final EmailAccountRepository _emailAccounts;

  Future<void> wipeAll() async {
    final accounts = await _emailAccounts.getAll();
    for (final account in accounts) {
      await _tokens.delete(account.secureTokenReference);
    }
    final fileNames = await _files.listNames();
    for (final name in fileNames) {
      await _files.delete(name);
    }
    await _db.close();
    if (_databaseFile.existsSync()) await _databaseFile.delete();
    await _fileKeyProvider.deleteKey();
    await _databaseKeyProvider.deleteDatabaseKey();
  }
}
