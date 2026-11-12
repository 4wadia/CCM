// ignore_for_file: directives_ordering, prefer_initializing_formals
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import '../../core/errors/app_failure.dart';
import '../../domain/repositories/email_account_repository.dart';
import '../../integrations/gmail/secure_token_store.dart';
import '../../integrations/storage/encrypted_file_store.dart';
import '../../data/database/app_database.dart';
import '../../data/database/migrations.dart';

class BackupManifest {
  const BackupManifest({
    required this.createdAt,
    required this.schemaVersion,
    required this.tableCounts,
    required this.includedFiles,
    required this.skippedFiles,
  });

  final DateTime createdAt;
  final int schemaVersion;
  final Map<String, int> tableCounts;
  final int includedFiles;
  final int skippedFiles;
}

/// Portable encrypted backup. Tokens, secure-storage keys, and account
/// credentials are deliberately excluded. Statement PDFs are decrypted and
/// re-encrypted inside the backup envelope, then re-encrypted with the target
/// device's file key on restore.
class BackupService {
  BackupService({
    required AppDatabase db,
    required EncryptedFileStore files,
    required SecureTokenStore tokens,
    required EmailAccountRepository emailAccounts,
  }) : _db = db,
       _files = files,
       _tokens = tokens,
       _emailAccounts = emailAccounts;

  static const List<int> _magic = <int>[
    0x43,
    0x43,
    0x4D,
    0x42,
    0x41,
    0x43,
    0x4B,
    0x55,
    0x50,
    0x31,
  ];
  static const String _format = 'ccm-backup';
  static const int _formatVersion = 1;
  static const List<String> _tables = <String>[
    'banks',
    'credit_cards',
    'categories',
    'import_jobs',
    'transactions',
    'transaction_sources',
    'app_settings',
    'review_items',
    'statements',
    'statement_transactions',
    'cashback_rules',
    'cashback_entries',
    'reward_accounts',
    'reward_entries',
    'bank_rules',
  ];
  static const List<String> _deleteOrder = <String>[
    'sync_checkpoints',
    'email_accounts',
    'reward_entries',
    'reward_accounts',
    'cashback_entries',
    'cashback_rules',
    'statement_transactions',
    'statements',
    'review_items',
    'transaction_sources',
    'transactions',
    'import_jobs',
    'bank_rules',
    'categories',
    'credit_cards',
    'banks',
    'app_settings',
  ];

  final AppDatabase _db;
  final EncryptedFileStore _files;
  final SecureTokenStore _tokens;
  final EmailAccountRepository _emailAccounts;

  Future<Uint8List> create({required String password}) async {
    _validatePassword(password);
    final salt = _randomBytes(16);
    final nonce = _randomBytes(12);
    final key = await _deriveKey(password, salt);
    final tables = <String, List<Map<String, Object?>>>{};
    final counts = <String, int>{};
    for (final table in _tables) {
      final rows = await _db.customSelect('SELECT * FROM $table').get();
      final data = rows
          .map((row) => Map<String, Object?>.from(row.data))
          .toList(growable: false);
      tables[table] = data;
      counts[table] = data.length;
    }

    final files = <String, String>{};
    var skipped = 0;
    final statementRows = tables['statements'] ?? const [];
    for (final row in statementRows) {
      final name = row['encrypted_file_path'] as String?;
      if (name == null || name.isEmpty) continue;
      try {
        final bytes = await _files.readEncrypted(name);
        files[name] = base64Encode(bytes);
      } catch (_) {
        skipped++;
      }
    }

    final payload = <String, Object?>{
      'format': _format,
      'formatVersion': _formatVersion,
      'schemaVersion': latestSchemaVersion,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'tables': tables,
      'files': files,
      'skippedFiles': skipped,
    };
    final clear = utf8.encode(jsonEncode(payload));
    final box = await AesGcm.with256bits().encrypt(
      clear,
      secretKey: key,
      nonce: nonce,
      aad: <int>[..._magic, ...salt],
    );
    return Uint8List.fromList(<int>[
      ..._magic,
      ...salt,
      ...box.concatenation(),
    ]);
  }

  Future<BackupManifest> restore({
    required List<int> bytes,
    required String password,
  }) async {
    _validatePassword(password);
    if (bytes.length < _magic.length + 16 + 12 + 16 ||
        !_startsWith(bytes, _magic)) {
      throw const AppFailure(
        code: 'CCM-BACKUP-001',
        message: 'The backup file is not a valid Credit Card Manager backup.',
      );
    }
    final salt = bytes.sublist(_magic.length, _magic.length + 16);
    final key = await _deriveKey(password, salt);
    try {
      final box = SecretBox.fromConcatenation(
        bytes.sublist(_magic.length + 16),
        nonceLength: 12,
        macLength: 16,
      );
      final clear = await AesGcm.with256bits().decrypt(
        box,
        secretKey: key,
        aad: <int>[..._magic, ...salt],
      );
      final decoded = jsonDecode(utf8.decode(clear));
      if (decoded is! Map<String, Object?> ||
          decoded['format'] != _format ||
          decoded['formatVersion'] != _formatVersion) {
        throw const AppFailure(
          code: 'CCM-BACKUP-002',
          message: 'The backup format is unsupported.',
        );
      }
      final schemaVersion = (decoded['schemaVersion'] as num?)?.toInt() ?? 0;
      if (schemaVersion > latestSchemaVersion || schemaVersion < 1) {
        throw const AppFailure(
          code: 'CCM-BACKUP-003',
          message: 'This backup was created by an incompatible app version.',
        );
      }
      final tables = _castTables(decoded['tables']);
      final files = _castFiles(decoded['files']);
      // Capture accounts before the restore clears the table so their tokens
      // can be removed from secure storage afterwards.
      final accounts = await _emailAccounts.getAll();
      final oldFiles = await _files.listNames();
      final fileMap = <String, String>{};
      final newFiles = <String>[];
      for (final entry in files.entries) {
        final newName = await _files.writeEncrypted(
          bytes: base64Decode(entry.value),
          suggestedName: entry.key,
        );
        fileMap[entry.key] = newName;
        newFiles.add(newName);
      }
      try {
        await _restoreTables(tables, fileMap);
      } catch (_) {
        for (final name in newFiles) {
          await _files.delete(name);
        }
        rethrow;
      }
      final retained = newFiles.toSet();
      for (final old in oldFiles) {
        if (!retained.contains(old)) await _files.delete(old);
      }
      for (final account in accounts) {
        await _tokens.delete(account.secureTokenReference);
      }
      final counts = <String, int>{
        for (final entry in tables.entries) entry.key: entry.value.length,
      };
      return BackupManifest(
        createdAt:
            DateTime.tryParse(decoded['createdAt']?.toString() ?? '') ??
            DateTime.now(),
        schemaVersion: schemaVersion,
        tableCounts: counts,
        includedFiles: newFiles.length,
        skippedFiles: files.length - newFiles.length,
      );
    } on SecretBoxAuthenticationError catch (error) {
      throw AppFailure(
        code: 'CCM-BACKUP-004',
        message: 'The backup password is incorrect or the file is damaged.',
        cause: error,
      );
    } on FormatException catch (error) {
      throw AppFailure(
        code: 'CCM-BACKUP-001',
        message: 'The backup file is not valid.',
        cause: error,
      );
    }
  }

  Future<void> _restoreTables(
    Map<String, List<Map<String, Object?>>> tables,
    Map<String, String> fileMap,
  ) async {
    await _db.transaction(() async {
      await _db.customStatement('PRAGMA defer_foreign_keys = ON');
      for (final table in _deleteOrder) {
        await _db.customStatement('DELETE FROM $table');
      }
      for (final table in _tables) {
        final rows = tables[table] ?? const <Map<String, Object?>>[];
        for (final original in rows) {
          final row = Map<String, Object?>.from(original);
          if (table == 'statements') {
            final oldName = row['encrypted_file_path'] as String?;
            if (oldName != null && fileMap.containsKey(oldName)) {
              row['encrypted_file_path'] = fileMap[oldName];
            }
          }
          if (row.isEmpty) continue;
          final columns = row.keys.toList(growable: false);
          final placeholders = List.filled(columns.length, '?').join(',');
          await _db.customStatement(
            'INSERT INTO $table (${columns.join(',')}) VALUES ($placeholders)',
            columns.map((column) => row[column]).toList(growable: false),
          );
        }
      }
    });
  }

  Map<String, List<Map<String, Object?>>> _castTables(Object? value) {
    if (value is! Map<String, Object?>) {
      throw const AppFailure(
        code: 'CCM-BACKUP-002',
        message: 'The backup does not contain a database export.',
      );
    }
    final result = <String, List<Map<String, Object?>>>{};
    for (final entry in value.entries) {
      if (!_tables.contains(entry.key)) continue;
      final rows = entry.value;
      if (rows is! List<Object?>) continue;
      result[entry.key] = rows
          .whereType<Map<String, Object?>>()
          .map((row) => Map<String, Object?>.from(row))
          .toList(growable: false);
    }
    return result;
  }

  Map<String, String> _castFiles(Object? value) {
    if (value is! Map<String, Object?>) return const <String, String>{};
    return <String, String>{
      for (final entry in value.entries)
        if (entry.value is String) entry.key: entry.value! as String,
    };
  }

  Future<SecretKey> _deriveKey(String password, List<int> salt) {
    final algorithm = Argon2id(
      parallelism: 2,
      memory: 64 * 1024,
      iterations: 3,
      hashLength: 32,
    );
    return algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
  }

  void _validatePassword(String password) {
    if (password.length < 12) {
      throw const AppFailure(
        code: 'CCM-BACKUP-005',
        message: 'Use a backup password with at least 12 characters.',
      );
    }
  }

  List<int> _randomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }

  bool _startsWith(List<int> bytes, List<int> prefix) {
    if (bytes.length < prefix.length) return false;
    for (var i = 0; i < prefix.length; i++) {
      if (bytes[i] != prefix[i]) return false;
    }
    return true;
  }
}
