///
/// Salt
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
class Chacha20 {
  var input = new List<int>(16);

  static int load32(List<int> x, var i) {
    return x[i] | (x[i + 1] << 8) | (x[i + 2] << 16) | (x[i + 3] << 24);
  }

  static void store32(List<int> x, var i, var u) {
    x[i + 0] = u;
    u >>= 8;
    x[i + 1] = u;
    u >>= 8;
    x[i + 2] = u;
    u >>= 8;
    x[i + 3] = u;
  }

  static int rotate(var v, var c) {
    return (v << c) | (v >> (32 - c));
  }

  static void round(List<int> x, var a, var b, var c, var d) {
    x[a] += x[b];
    x[d] = rotate(x[d] ^ x[a], 16);
    x[c] += x[d];
    x[b] = rotate(x[b] ^ x[c], 12);
    x[a] += x[b];
    x[d] = rotate(x[d] ^ x[a], 8);
    x[c] += x[d];
    x[b] = rotate(x[b] ^ x[c], 7);
  }

  void setupKey(List<int> key) {
    this.input[0] = 1634760805;
    this.input[1] = 857760878;
    this.input[2] = 2036477234;
    this.input[3] = 1797285236;
    for (var i = 0; i < 8; i++) {
      this.input[i + 4] = load32(key, i * 4);
    }
  }

  void setupNonce(List<int> nonce) {
    this.input[12] = 0;
    this.input[13] = 0;
    this.input[14] = load32(nonce, 0);
    this.input[15] = load32(nonce, 4);
  }

  void encrypt(List<int> dst, List<int> src, var len) {
    var x = new List<int>(16);
    var buf = new List<int>(64);
    var dpos = 0;
    var spos = 0;

    while (len > 0) {
      for (var i = 16 - 1; i >= 0; i--) {
        x[i] = this.input[i];
      }
      for (var i = 20; i > 0; i -= 2) {
        round(x, 0, 4, 8, 12);
        round(x, 1, 5, 9, 13);
        round(x, 2, 6, 10, 14);
        round(x, 3, 7, 11, 15);
        round(x, 0, 5, 10, 15);
        round(x, 1, 6, 11, 12);
        round(x, 2, 7, 8, 13);
        round(x, 3, 4, 9, 14);
      }
      for (var i = 16 - 1; i >= 0; i--) {
        x[i] += this.input[i];
        store32(buf, 4 * i, x[i]);
      }
      this.input[12] += 1;
      if (this.input[12] == 0) {
        this.input[13] += 1;
      }
      if (len <= 64) {
        for (var i = len - 1; i >= 0; i--) {
          dst[i + dpos] = src[i + spos] ^ buf[i];
        }
        return;
      }
      for (var i = 64 - 1; i >= 0; i--) {
        dst[i + dpos] = src[i + spos] ^ buf[i];
      }
      len -= 64;
      spos += 64;
      dpos += 64;
    }
  }

  void decrypt(List<int> dst, List<int> src, var len) {
    this.encrypt(dst, src, len);
  }

  void keystream(List<int> dst, var len) {
    for (var i = len - 1; i >= 0; i--) {
      dst[i] = 0;
    }
    this.encrypt(dst, dst, len);
  }
}
