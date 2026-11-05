import 'dart:typed_data';

/// Required database key length in bytes (256 bits).
const int databaseKeyLength = 32;

/// Encodes a database key as lowercase hexadecimal for SQLCipher's raw-key
/// pragma (`PRAGMA key = "x'...'"`).
///
/// Throws [ArgumentError] for a key of the wrong length. Callers must zero the
/// source bytes after encoding.
String encodeDatabaseKeyHex(Uint8List key) {
  if (key.length != databaseKeyLength) {
    throw ArgumentError.value(
      key.length,
      'key',
      'Database key must be $databaseKeyLength bytes',
    );
  }

  final buffer = StringBuffer();
  for (final byte in key) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}
