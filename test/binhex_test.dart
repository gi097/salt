import 'package:flutter_test/flutter_test.dart';
import 'package:salt/binhex.dart';

///
/// Salt
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
class BinHexTest {
  static final List<String> testVectors = [
    '4290bcb154173531f314af57f3be3b5006da371ece272afa1b5dbdd1100a1007',
    '86d09974840bded2a5ca',
    'cd7cf67be39c794a',
    '87e229d4500845a079c0'
  ];

  void run() {
    var key = BinHex.hex2bin(testVectors[0]);
    var input = BinHex.hex2bin(testVectors[1]);
    var nonce = BinHex.hex2bin(testVectors[2]);
    var ad = BinHex.hex2bin(testVectors[3]);

    expect(testVectors[0], BinHex.bin2hex(key));
    expect(testVectors[1], BinHex.bin2hex(input));
    expect(testVectors[2], BinHex.bin2hex(nonce));
    expect(testVectors[3], BinHex.bin2hex(ad));
  }
}
