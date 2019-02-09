library salt;

import 'package:salt/chacha20_poly1305.dart';

///
/// Salt
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
class Salt {
  static List<int> chacha20Poly1305Decrypt(
      List<int> ciphertext, List<int> ad, List<int> nonce, List<int> key) {
    if (ad == null) {
      ad = new List(0);
    }
    var chacha20poly1305 = new Chacha20Poly1305(key);
    var plaintext = chacha20poly1305.decrypt(nonce, ciphertext, ad);
    return plaintext;
  }

  static List<int> chacha20Poly1305Encrypt(
      List<int> plaintext, List<int> ad, List<int> nonce, List<int> key) {
    if (ad == null) {
      ad = new List(0);
    }
    var chacha20poly1305 = new Chacha20Poly1305(key);
    var ciphertext = chacha20poly1305.encrypt(nonce, plaintext, ad);
    return ciphertext;
  }

  static bool equals(List<int> x, List<int> y) {
    var len = x.length;
    if (len != y.length) {
      return false;
    }
    var diff = 0;
    for (var i = 0; i < len; i++) {
      diff |= x[i] ^ y[i];
    }
    diff = (diff - 1) >> 31;
    return ((diff & 1) == 1);
  }
}
