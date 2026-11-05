import 'dart:io';

import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' show Database;

import '../../core/secure_storage/database_key_provider.dart';
import '../../core/security/key_encoding.dart';
import 'app_database.dart';

/// The database could not be opened or failed key verification.
///
/// [cause] is diagnostic only and never contains the key or row data.
class DatabaseOpenException implements Exception {
  const DatabaseOpenException({this.cause});

  final Object? cause;

  @override
  String toString() => 'DatabaseOpenException';
}

/// SQLCipher is not active in the linked SQLite build.
///
/// This must fail closed: without it, `PRAGMA key` would be ignored and data
/// would be written in plaintext.
class DatabaseCipherUnavailableException implements Exception {
  const DatabaseCipherUnavailableException();

  @override
  String toString() =>
      'DatabaseCipherUnavailableException: SQLCipher is not linked';
}

/// Opens the encrypted application database.
///
/// [background] runs SQLite on a dedicated isolate in production. Tests that
/// need direct file access to WAL files use `background: false`.
Future<AppDatabase> openEncryptedDatabase({
  required File file,
  required DatabaseKeyProvider keyProvider,
  bool background = true,
}) async {
  final key = await keyProvider.getOrCreateDatabaseKey();
  final String keyHex;
  try {
    keyHex = encodeDatabaseKeyHex(key);
  } finally {
    // The hex form is required for the connection setup; the raw bytes are not.
    key.fillRange(0, key.length, 0);
  }

  await file.parent.create(recursive: true);

  void setup(Database db) => configureEncryptedConnection(db, keyHex);

  final executor = background
      ? NativeDatabase.createInBackground(file, setup: setup)
      : NativeDatabase(file, setup: setup);

  final database = AppDatabase(executor);

  try {
    // Forces the connection open and validates the key before the database is
    // handed to callers.
    await database
        .customSelect('SELECT count(*) AS table_count FROM sqlite_master')
        .get();
  } catch (error) {
    await database.close();
    throw DatabaseOpenException(cause: error);
  }

  return database;
}

/// Applies the encryption and integrity pragmas to a freshly opened connection.
///
/// Exposed for tests so the exact production configuration can be asserted.
void configureEncryptedConnection(Database db, String keyHex) {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(keyHex)) {
    throw ArgumentError('Database key must be 64 lowercase hex characters');
  }

  db.execute('PRAGMA key = "x\'$keyHex\'";');

  final cipherVersion = db.select('PRAGMA cipher_version');
  if (cipherVersion.isEmpty) {
    throw const DatabaseCipherUnavailableException();
  }

  db.execute('PRAGMA cipher_memory_security = ON;');
  db.execute('PRAGMA foreign_keys = ON;');
  db.execute('PRAGMA secure_delete = ON;');
  db.execute('PRAGMA journal_mode = WAL;');

  // Reading the schema forces SQLCipher to validate the key. A wrong key fails
  // here instead of silently returning an empty database.
  db.select('SELECT count(*) FROM sqlite_master');
}
