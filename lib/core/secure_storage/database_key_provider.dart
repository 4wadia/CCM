import 'dart:typed_data';

/// Supplies the 256-bit key used to open the encrypted database.
///
/// Implementations must never log, persist in plaintext, or transmit the key.
/// A production implementation wraps the key with Android Keystore or stores it
/// in the iOS Keychain.
abstract interface class DatabaseKeyProvider {
  /// Returns the existing key, creating it on first launch.
  ///
  /// Throws [DatabaseKeyUnavailableException] if the key exists but cannot be
  /// recovered. Callers must not treat that as "no key" and create a new one.
  Future<Uint8List> getOrCreateDatabaseKey();

  /// Permanently removes the key. Used by the full data-deletion workflow.
  Future<void> deleteDatabaseKey();
}

/// The platform key store could not provide the database key.
///
/// [cause] is for local diagnosis only and must not contain key material or be
/// shown to the user.
class DatabaseKeyUnavailableException implements Exception {
  const DatabaseKeyUnavailableException({this.cause});

  final Object? cause;

  @override
  String toString() => 'DatabaseKeyUnavailableException';
}
