import 'dart:typed_data';

import 'package:credit_card_manager/core/secure_storage/database_key_provider.dart';

/// Deterministic key provider for tests.
///
/// Never used in production. The key is intentionally not random so failures are
/// reproducible.
class InMemoryKeyProvider implements DatabaseKeyProvider {
  InMemoryKeyProvider({Uint8List? key})
    : _key =
          key ??
          Uint8List.fromList(
            List<int>.generate(32, (index) => (index + 1) * 7 % 256),
          );

  final Uint8List _key;

  bool deleted = false;
  int reads = 0;

  @override
  Future<Uint8List> getOrCreateDatabaseKey() async {
    reads += 1;
    if (deleted) {
      throw const DatabaseKeyUnavailableException(
        cause: 'Test key was deleted',
      );
    }
    return Uint8List.fromList(_key);
  }

  @override
  Future<void> deleteDatabaseKey() async {
    deleted = true;
  }
}
