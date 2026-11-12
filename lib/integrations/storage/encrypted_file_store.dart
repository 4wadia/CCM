// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;

import '../../core/errors/app_failure.dart';
import '../../core/files/app_files.dart';

/// Supplies the random 256-bit key used for encrypted statement files.
abstract interface class FileKeyProvider {
  Future<Uint8List> getOrCreateKey();

  Future<void> deleteKey();
}

/// File key stored in Android Keystore-backed secure storage or iOS Keychain.
class SecureFileKeyProvider implements FileKeyProvider {
  const SecureFileKeyProvider({
    this.storage = const FlutterSecureStorage(),
    this.keyName = 'ccm.file_key.v1',
  });

  final FlutterSecureStorage storage;
  final String keyName;

  @override
  Future<Uint8List> getOrCreateKey() async {
    final existing = await storage.read(key: keyName);
    if (existing != null) {
      try {
        final bytes = base64Decode(existing);
        if (bytes.length != 32) {
          throw const FormatException('Invalid file key length');
        }
        return Uint8List.fromList(bytes);
      } on FormatException catch (error) {
        throw AppFailure(
          code: 'CCM-FILE-001',
          message: 'Encrypted statement files cannot be unlocked.',
          cause: error,
        );
      }
    }
    final random = Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(32, (_) => random.nextInt(256)),
    );
    await storage.write(key: keyName, value: base64Encode(bytes));
    return bytes;
  }

  @override
  Future<void> deleteKey() async {
    await storage.delete(key: keyName);
  }
}

/// AES-256-GCM encrypted file storage with opaque names.
class EncryptedFileStore {
  EncryptedFileStore({
    required FileKeyProvider keyProvider,
    Future<Directory> Function()? directoryProvider,
    AesGcm? cipher,
  }) : _keyProvider = keyProvider,
       _directoryProvider = directoryProvider ?? appStatementsDirectory,
       _cipher = cipher ?? AesGcm.with256bits();

  static const List<int> _magic = <int>[0x43, 0x43, 0x4D, 0x46, 0x31];
  static const String _extension = '.ccmenc';

  final FileKeyProvider _keyProvider;
  final Future<Directory> Function() _directoryProvider;
  final AesGcm _cipher;

  Future<String> writeEncrypted({
    required List<int> bytes,
    String? suggestedName,
  }) async {
    final key = await _keyProvider.getOrCreateKey();
    final secretKey = SecretKey(key);
    final box = await _cipher.encrypt(bytes, secretKey: secretKey);
    final payload = Uint8List.fromList(<int>[
      ..._magic,
      ...box.concatenation(),
    ]);
    final name = _opaqueName(suggestedName);
    final directory = await _directoryProvider();
    final file = File(p.join(directory.path, name));
    await file.writeAsBytes(payload, flush: true);
    return name;
  }

  Future<Uint8List> readEncrypted(String opaqueName) async {
    final file = await _fileFor(opaqueName);
    final bytes = await file.readAsBytes();
    if (bytes.length <= _magic.length ||
        !_listEquals(bytes.sublist(0, _magic.length), _magic)) {
      throw const AppFailure(
        code: 'CCM-FILE-002',
        message: 'The encrypted file format is not recognized.',
      );
    }
    try {
      final box = SecretBox.fromConcatenation(
        bytes.sublist(_magic.length),
        nonceLength: _cipher.nonceLength,
        macLength: _cipher.macAlgorithm.macLength,
      );
      final key = await _keyProvider.getOrCreateKey();
      final clear = await _cipher.decrypt(box, secretKey: SecretKey(key));
      return Uint8List.fromList(clear);
    } on SecretBoxAuthenticationError catch (error) {
      throw AppFailure(
        code: 'CCM-FILE-003',
        message: 'The encrypted file could not be authenticated.',
        cause: error,
      );
    } on ArgumentError catch (error) {
      throw AppFailure(
        code: 'CCM-FILE-002',
        message: 'The encrypted file format is not recognized.',
        cause: error,
      );
    }
  }

  Future<void> delete(String opaqueName) async {
    final file = await _fileFor(opaqueName);
    if (file.existsSync()) await file.delete();
  }

  Future<List<String>> listNames() async {
    final directory = await _directoryProvider();
    if (!directory.existsSync()) return const <String>[];
    final files = await directory.list().toList();
    return files
        .where((entity) => entity is File && entity.path.endsWith(_extension))
        .map((entity) => p.basename(entity.path))
        .toList(growable: false);
  }

  Future<File> _fileFor(String opaqueName) async {
    final name = p.basename(opaqueName);
    if (name != opaqueName || !name.endsWith(_extension)) {
      throw const AppFailure(
        code: 'CCM-FILE-004',
        message: 'The encrypted file name is invalid.',
      );
    }
    final directory = await _directoryProvider();
    return File(p.join(directory.path, name));
  }

  String _opaqueName(String? suggestedName) {
    final random = Random.secure();
    final token = List<int>.generate(18, (_) => random.nextInt(256));
    final encoded = base64UrlEncode(token).replaceAll('=', '');
    final hashPart = suggestedName == null
        ? ''
        : sha256.convert(utf8.encode(suggestedName)).toString().substring(0, 8);
    return '$encoded$hashPart$_extension';
  }

  static bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

String sha256Hex(List<int> bytes) => sha256.convert(bytes).toString();
