import 'package:flutter_test/flutter_test.dart';
import 'binhex_test.dart';
import 'chacha20_poly1305_test.dart';
import 'chacha20_test.dart';

///
/// Salt
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
void main() {
  test('running all unit tests...', () {
    var binHexTest = new BinHexTest();
    binHexTest.run();

    var chacha20test = new Chacha20Test();
    chacha20test.run();

    var chacha20poly1305test = new Chacha20Poly1305Test();
    chacha20poly1305test.run();
  });
}
