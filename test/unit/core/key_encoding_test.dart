import 'dart:typed_data';

import 'package:credit_card_manager/core/security/key_encoding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encodes 32 bytes as 64 lowercase hex characters', () {
    final key = Uint8List.fromList(List<int>.generate(32, (index) => index));

    final encoded = encodeDatabaseKeyHex(key);

    expect(encoded, hasLength(64));
    expect(encoded, matches(RegExp(r'^[0-9a-f]{64}$')));
    expect(encoded.startsWith('000102030405060708090a0b0c0d0e0f'), isTrue);
    expect(encoded.endsWith('1e1f'), isTrue);
  });

  test('pads single-digit bytes', () {
    final key = Uint8List.fromList(List<int>.filled(32, 0x0a));
    expect(encodeDatabaseKeyHex(key), '0a' * 32);
  });

  test('rejects keys of the wrong length', () {
    expect(() => encodeDatabaseKeyHex(Uint8List(31)), throwsArgumentError);
    expect(() => encodeDatabaseKeyHex(Uint8List(33)), throwsArgumentError);
  });
}
