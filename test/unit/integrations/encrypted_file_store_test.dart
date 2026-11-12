import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:credit_card_manager/core/errors/app_failure.dart';
import 'package:credit_card_manager/integrations/storage/encrypted_file_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../fakes/in_memory_file_key_provider.dart';

void main() {
  late Directory tempDir;
  late InMemoryFileKeyProvider keyProvider;
  late EncryptedFileStore store;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_file_store_test');
    keyProvider = InMemoryFileKeyProvider();
    store = EncryptedFileStore(
      keyProvider: keyProvider,
      directoryProvider: () async => tempDir,
    );
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('writes opaque encrypted files and reads the original bytes', () async {
    final clear = Uint8List.fromList(
      utf8.encode('statement plaintext that must not appear on disk'),
    );

    final name = await store.writeEncrypted(
      bytes: clear,
      suggestedName: 'october-statement.pdf',
    );

    expect(name, endsWith('.ccmenc'));
    expect(name, isNot(contains('october-statement')));

    final file = File(p.join(tempDir.path, name));
    final raw = await file.readAsBytes();
    expect(raw, isNot(equals(clear)));
    expect(
      utf8.decode(raw, allowMalformed: true),
      isNot(contains('statement plaintext')),
    );

    expect(await store.readEncrypted(name), clear);
    expect(await store.listNames(), [name]);
  });

  test('produces a different opaque name for each write', () async {
    final one = await store.writeEncrypted(bytes: [1, 2, 3]);
    final two = await store.writeEncrypted(bytes: [1, 2, 3]);

    expect(one, isNot(two));
  });

  test('rejects authentication with the wrong key', () async {
    final name = await store.writeEncrypted(bytes: [1, 2, 3, 4]);
    final other = EncryptedFileStore(
      keyProvider: InMemoryFileKeyProvider(
        key: Uint8List.fromList(List<int>.generate(32, (index) => index + 1)),
      ),
      directoryProvider: () async => tempDir,
    );

    await expectLater(
      other.readEncrypted(name),
      throwsA(
        isA<AppFailure>().having((error) => error.code, 'code', 'CCM-FILE-003'),
      ),
    );
  });

  test('rejects path traversal and non-encrypted names', () async {
    await expectLater(
      store.readEncrypted('../secret.ccmenc'),
      throwsA(
        isA<AppFailure>().having((error) => error.code, 'code', 'CCM-FILE-004'),
      ),
    );
    await expectLater(
      store.readEncrypted('plain.txt'),
      throwsA(
        isA<AppFailure>().having((error) => error.code, 'code', 'CCM-FILE-004'),
      ),
    );
  });

  test('deletes encrypted files', () async {
    final name = await store.writeEncrypted(bytes: [1, 2, 3]);
    await store.delete(name);

    expect(await store.listNames(), isEmpty);
    await expectLater(
      store.readEncrypted(name),
      throwsA(isA<FileSystemException>()),
    );
  });

  test('fails closed after the file key is deleted', () async {
    final name = await store.writeEncrypted(bytes: [1, 2, 3]);
    await keyProvider.deleteKey();

    await expectLater(store.readEncrypted(name), throwsA(isA<StateError>()));
  });
}
