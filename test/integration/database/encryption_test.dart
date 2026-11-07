import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:credit_card_manager/core/secure_storage/database_key_provider.dart';
import 'package:credit_card_manager/core/security/key_encoding.dart';
import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/database/migrations.dart';
import 'package:credit_card_manager/data/repositories/bank_repository_impl.dart';
import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../../fakes/in_memory_key_provider.dart';

/// Sentinel that must never appear in plaintext on disk.
const String _sentinel = 'ZEPHYR-SENTINEL-9137';

void main() {
  late Directory tempDir;
  late File databaseFile;
  late InMemoryKeyProvider keyProvider;
  AppDatabase? database;

  Future<AppDatabase> open({
    InMemoryKeyProvider? provider,
    bool background = false,
  }) {
    return openEncryptedDatabase(
      file: databaseFile,
      keyProvider: provider ?? keyProvider,
      background: background,
    );
  }

  Future<void> insertSentinelBank() async {
    final now = DateTime.utc(2026, 11, 5);
    await BankRepositoryImpl(database!).upsert(
      Bank(
        id: 'bank_test',
        displayName: _sentinel,
        countryCode: 'IN',
        region: 'India',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_encryption_test');
    databaseFile = File(p.join(tempDir.path, 'ccm.sqlite'));
    keyProvider = InMemoryKeyProvider();
    database = await open();
  });

  tearDown(() async {
    await database?.close();
    database = null;
    await tempDir.delete(recursive: true);
  });

  test('SQLCipher is active and connection pragmas are applied', () async {
    final cipher = await database!.customSelect('PRAGMA cipher_version').get();
    expect(cipher, isNotEmpty, reason: 'SQLCipher must be linked');

    final journal = await database!.customSelect('PRAGMA journal_mode').get();
    expect(journal.single.data['journal_mode'], 'wal');

    final foreignKeys = await database!
        .customSelect('PRAGMA foreign_keys')
        .get();
    expect(foreignKeys.single.data['foreign_keys'], 1);
  });

  test('database, WAL, and SHM files contain no plaintext', () async {
    await insertSentinelBank();

    // Force a checkpoint so recent writes are considered for the main file too.
    await database!.customSelect('PRAGMA wal_checkpoint(PASSIVE)').get();

    final candidates = <File>[
      databaseFile,
      File('${databaseFile.path}-wal'),
      File('${databaseFile.path}-shm'),
    ];

    var checked = 0;
    for (final file in candidates) {
      if (!file.existsSync()) {
        continue;
      }
      checked += 1;

      final bytes = await file.readAsBytes();
      final asText = latin1.decode(bytes);

      expect(
        asText,
        isNot(contains(_sentinel)),
        reason: '${p.basename(file.path)} must not contain plaintext',
      );

      if (file.path == databaseFile.path) {
        expect(
          asText,
          isNot(startsWith('SQLite format 3')),
          reason: 'Encrypted database must not have a plaintext SQLite header',
        );
      }
    }

    expect(checked, greaterThan(0), reason: 'No database files were checked');
  });

  test('data persists after close and reopen with the same key', () async {
    await insertSentinelBank();
    await database!.close();
    database = null;

    database = await open();
    final banks = await BankRepositoryImpl(database!).getAll();

    expect(banks, hasLength(1));
    expect(banks.single.displayName, _sentinel);
  });

  test('a wrong key is rejected', () async {
    await insertSentinelBank();
    await database!.close();
    database = null;

    final wrongKey = InMemoryKeyProvider(
      key: Uint8List.fromList(List<int>.filled(32, 9)),
    );

    await expectLater(
      open(provider: wrongKey),
      throwsA(isA<DatabaseOpenException>()),
    );
  });

  test('a deleted key cannot be used to reopen the database', () async {
    await insertSentinelBank();
    await database!.close();
    database = null;

    await keyProvider.deleteDatabaseKey();

    await expectLater(open(), throwsA(isA<DatabaseKeyUnavailableException>()));
  });

  test('refuses a database written by a newer schema', () async {
    await database!.close();
    database = null;

    final key = await keyProvider.getOrCreateDatabaseKey();
    final keyHex = encodeDatabaseKeyHex(key);
    key.fillRange(0, key.length, 0);

    final raw = sqlite3.open(databaseFile.path);
    try {
      configureEncryptedConnection(raw, keyHex);
      raw.execute('PRAGMA user_version = ${latestSchemaVersion + 1}');
    } finally {
      raw.close();
    }

    await expectLater(open(), throwsA(isA<DatabaseOpenException>()));
  });

  test(
    'production background-isolate path opens the same encrypted file',
    () async {
      await insertSentinelBank();
      await database!.close();
      database = null;

      database = await open(background: true);

      final banks = await BankRepositoryImpl(database!).getAll();
      expect(banks.single.displayName, _sentinel);
    },
  );
}
