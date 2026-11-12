import 'dart:math';

/// Stable-prefix opaque identifiers. No personal data is encoded in an ID.
abstract final class Ids {
  static final Random _random = Random.secure();

  static String next(String prefix) {
    final randomPart = _random.nextInt(0x7fffffff).toRadixString(16);
    return '${prefix}_${DateTime.now().microsecondsSinceEpoch}_$randomPart';
  }
}
