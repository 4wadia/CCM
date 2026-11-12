import 'dart:typed_data';

import 'package:credit_card_manager/integrations/storage/encrypted_file_store.dart';

/// Deterministic, in-memory file key provider for tests.
class InMemoryFileKeyProvider implements FileKeyProvider {
  InMemoryFileKeyProvider({Uint8List? key})
    : _key =
          key ??
          Uint8List.fromList(
            List<int>.generate(32, (index) => (index + 3) * 11 % 256),
          );

  final Uint8List _key;
  bool deleted = false;

  @override
  Future<Uint8List> getOrCreateKey() async {
    if (deleted) {
      throw StateError('Test file key was deleted');
    }
    return Uint8List.fromList(_key);
  }

  @override
  Future<void> deleteKey() async {
    deleted = true;
  }
}
