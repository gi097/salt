import 'package:salt/chacha20.dart';
import 'package:salt/poly1305.dart';
import 'package:salt/salt.dart';

///
/// Salt
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
class Chacha20Poly1305 {
  var key;

  Chacha20Poly1305(List<int> key) {
    this.key = key;
  }

  List<int> init(Chacha20 ctx, List<int> nonce) {
    ctx.setupKey(this.key);
    ctx.setupNonce(nonce);

    var subKey = new List<int>(64);
    ctx.keystream(subKey, 64);

    var out = new List<int>(32);
    for (var i = 32 - 1; i >= 0; i--) {
      out[i] = subKey[i];
    }
    return out;
  }

  static void store64(List<int> dst, var pos, var num) {
    dst[pos + 0] = num;
    num >>= 8;
    dst[pos + 1] = num;
    num >>= 8;
    dst[pos + 2] = num;
    num >>= 8;
    dst[pos + 3] = num;
    num >>= 8;
    dst[pos + 4] = num;
    num >>= 8;
    dst[pos + 5] = num;
    num >>= 8;
    dst[pos + 6] = num;
    num >>= 8;
    dst[pos + 7] = num;
  }

  static List<int> tag(List<int> key, List<int> ciphertext, List<int> data) {
    if (key.length != 32) {
      throw new Exception("Key length must be 32");
    }
    var clen = ciphertext.length;
    var dlen = data.length;
    var m = new List<int>(clen + dlen + 16);
    for (var i = dlen - 1; i >= 0; i--) {
      m[i] = data[i];
    }
    store64(m, dlen, dlen);
    for (var i = clen - 1; i >= 0; i--) {
      m[dlen + 8 + i] = ciphertext[i];
    }
    store64(m, clen + dlen + 8, clen);

    var mac = new List<int>(16);
    var poly1305 = new Poly1305();
    poly1305.auth(mac, m, m.length, key);

    return mac;
  }

  List<int> encrypt(List<int> nonce, List<int> input, List<int> data) {
    var c20 = new Chacha20();
    var key = this.init(c20, nonce);

    var ilen = input.length;
    var ciphertext = new List<int>(ilen);
    c20.encrypt(ciphertext, input, ilen);

    var mac = tag(key, ciphertext, data);
    var res = new List<int>(ilen + mac.length);
    for (var i = 0; i < ilen; i++) {
      res[i] = ciphertext[i];
    }
    for (var i = ilen; i < ilen + mac.length; i++) {
      res[i] = mac[i - ilen];
    }
    return res;
  }

  List<int> decrypt(List<int> nonce, List<int> ciphertext, List<int> data) {
    if (ciphertext.length < 16) {
      throw new Exception("Ciphertext length must be >= 16");
    }
    var c20 = new Chacha20();
    var key = this.init(c20, nonce);
    var clen = ciphertext.length - 16;

    var digest = List<int>(ciphertext.length - clen);
    for (var i = clen; i < ciphertext.length; i++) {
      digest[i - clen] = ciphertext[i];
    }

    var input = List<int>(clen);
    for (var i = 0; i < clen; i++) {
      input[i] = ciphertext[i];
    }

    var mac = tag(key, input, data);
    if (!Salt.equals(digest, mac)) {
      return null;
    }
    var out = new List<int>(clen);
    c20.decrypt(out, ciphertext, clen);
    return out;
  }
}
