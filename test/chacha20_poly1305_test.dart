import 'package:flutter_test/flutter_test.dart';
import 'package:salt/binhex.dart';
import 'package:salt/salt.dart';

///
/// Salt
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
class Chacha20Poly1305Test {
  static final List<String> testVectors = [
    '4290bcb154173531f314af57f3be3b5006da371ece272afa1b5dbdd1100a1007',
    '86d09974840bded2a5ca',
    'cd7cf67be39c794a',
    '87e229d4500845a079c0',
    'e3e446f7ede9a19b62a4677dabf4e3d24b876bb284753896e1d6',
  ];

  void run() {
    var key = BinHex.hex2bin(testVectors[0]);
    var input = BinHex.hex2bin(testVectors[1]);
    var nonce = BinHex.hex2bin(testVectors[2]);
    var ad = BinHex.hex2bin(testVectors[3]);
    var expected = BinHex.hex2bin(testVectors[4]);

    var ciphertext = Salt.chacha20Poly1305Encrypt(input, ad, nonce, key);
    expect(true, Salt.equals(expected, ciphertext));

    var plaintext = Salt.chacha20Poly1305Decrypt(ciphertext, ad, nonce, key);
    expect(true, Salt.equals(input, plaintext));
  }
}
