///
/// Salt
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
class Poly1305 {
  int8To16(List<int> p, var pos) {
    return ((p[pos])) | (((p[pos + 1])) << 8);
  }

  int16To8(List<int> p, var pos, var v) {
    p[pos] = (v >> 0);
    p[pos + 1] = (v >> 8);
  }

  init(List<int> key) {
    var ctx = new List(6);
    ctx[0] = new List<int>(16);
    ctx[1] = 0;
    ctx[2] = new List<int>(10);
    ctx[3] = new List<int>(10);
    ctx[4] = new List<int>(8);
    ctx[5] = 0;
    var t = new List<int>(8);
    for (var i = 8 - 1; i >= 0; i--) {
      t[i] = this.int8To16(key, i * 2);
    }
    ctx[2][0] = t[0] & 0x1fff;
    ctx[2][1] = ((t[0] >> 13) | (t[1] << 3)) & 0x1fff;
    ctx[2][2] = ((t[1] >> 10) | (t[2] << 6)) & 0x1f03;
    ctx[2][3] = ((t[2] >> 7) | (t[3] << 9)) & 0x1fff;
    ctx[2][4] = ((t[3] >> 4) | (t[4] << 12)) & 0x00ff;
    ctx[2][5] = (t[4] >> 1) & 0x1ffe;
    ctx[2][6] = ((t[4] >> 14) | (t[5] << 2)) & 0x1fff;
    ctx[2][7] = ((t[5] >> 11) | (t[6] << 5)) & 0x1f81;
    ctx[2][8] = ((t[6] >> 8) | (t[7] << 8)) & 0x1fff;
    ctx[2][9] = (t[7] >> 5) & 0x007f;
    for (var i = 8 - 1; i >= 0; i--) {
      ctx[3][i] = 0;
      ctx[4][i] = this.int8To16(key, 16 + (2 * i));
    }
    ctx[3][8] = 0;
    ctx[3][9] = 0;
    return ctx;
  }

  blocks(List ctx, List<int> m, var mpos, var bytes) {
    var hibit = ctx[5] != 0 ? 0 : (1 << 11);
    var t = new List<int>(8);
    var d = new List<int>(10);
    var c = 0;
    while (bytes >= 16) {
      for (var i = 8 - 1; i >= 0; i--) {
        t[i] = this.int8To16(m, i * 2 + mpos);
      }
      ctx[3][0] += t[0] & 0x1fff;
      ctx[3][1] += ((t[0] >> 13) | (t[1] << 3)) & 0x1fff;
      ctx[3][2] += ((t[1] >> 10) | (t[2] << 6)) & 0x1fff;
      ctx[3][3] += ((t[2] >> 7) | (t[3] << 9)) & 0x1fff;
      ctx[3][4] += ((t[3] >> 4) | (t[4] << 12)) & 0x1fff;
      ctx[3][5] += (t[4] >> 1) & 0x1fff;
      ctx[3][6] += ((t[4] >> 14) | (t[5] << 2)) & 0x1fff;
      ctx[3][7] += ((t[5] >> 11) | (t[6] << 5)) & 0x1fff;
      ctx[3][8] += ((t[6] >> 8) | (t[7] << 8)) & 0x1fff;
      ctx[3][9] += (t[7] >> 5) | hibit;
      for (var i = 0, c = 0; i < 10; i++) {
        d[i] = c;
        for (var j = 0; j < 10; j++) {
          d[i] += (ctx[3][j]) *
              ((j <= i) ? ctx[2][i - j] : (5 * ctx[2][i + 10 - j]));
          if (j == 4) {
            c = (d[i] >> 13);
            d[i] &= 0x1fff;
          }
        }
        c += (d[i] >> 13);
        d[i] &= 0x1fff;
      }
      c = ((c << 2) + c);
      c += d[0];
      d[0] = ((c) & 0x1fff);
      c = (c >> 13);
      d[1] += c;
      for (var i = 10 - 1; i >= 0; i--) {
        ctx[3][i] = d[i];
      }
      mpos += 16;
      bytes -= 16;
    }
  }

  update(List ctx, List<int> m, var bytes) {
    var want = 0;
    var mpos = 0;
    if (ctx[1] != 0) {
      want = 16 - ctx[1];
      if (want > bytes) want = bytes;
      for (var i = want - 1; i >= 0; i--) {
        ctx[0][ctx[1] + i] = m[i + mpos];
      }
      bytes -= want;
      mpos += want;
      ctx[1] += want;
      if (ctx[1] < 16) {
        return;
      }
      this.blocks(ctx, ctx[0], 0, 16);
      ctx[1] = 0;
    }
    if (bytes >= 16) {
      want = (bytes & ~(16 - 1));
      this.blocks(ctx, m, mpos, want);
      mpos += want;
      bytes -= want;
    }
    if (bytes != 0) {
      for (var i = bytes - 1; i >= 0; i--) {
        ctx[0][ctx[1] + i] = m[i + mpos];
      }
      ctx[1] += bytes;
    }
  }

  finish(List ctx, List<int> mac) {
    var g = new List<int>(10);
    if (ctx[1] != 0) {
      var i = ctx[1];
      ctx[0][i++] = 1;
      for (; i < 16; i++) ctx[0][i] = 0;
      ctx[5] = 1;
      this.blocks(ctx, ctx[0], 0, 16);
    }
    var c = ctx[3][1] >> 13;
    ctx[3][1] &= 0x1fff;
    for (var i = 2; i < 10; i++) {
      ctx[3][i] += c;
      c = ctx[3][i] >> 13;
      ctx[3][i] &= 0x1fff;
    }
    ctx[3][0] += (c * 5);
    c = ctx[3][0] >> 13;
    ctx[3][0] &= 0x1fff;
    ctx[3][1] += c;
    c = ctx[3][1] >> 13;
    ctx[3][1] &= 0x1fff;
    ctx[3][2] += c;

    g[0] = ctx[3][0] + 5;
    c = g[0] >> 13;
    g[0] &= 0x1fff;
    for (var i = 1; i < 10; i++) {
      g[i] = ctx[3][i] + c;
      c = g[i] >> 13;
      g[i] &= 0x1fff;
    }
    g[9] -= (1 << 13);
    var mask = (g[9] >> 15) - 1;
    for (var i = 10 - 1; i >= 0; i--) {
      g[i] &= mask;
    }
    mask = ~mask;
    for (var i = 10 - 1; i >= 0; i--) {
      ctx[3][i] = (ctx[3][i] & mask) | g[i];
    }
    ctx[3][0] = ((ctx[3][0]) | (ctx[3][1] << 13));
    ctx[3][1] = ((ctx[3][1] >> 3) | (ctx[3][2] << 10));
    ctx[3][2] = ((ctx[3][2] >> 6) | (ctx[3][3] << 7));
    ctx[3][3] = ((ctx[3][3] >> 9) | (ctx[3][4] << 4));
    ctx[3][4] = ((ctx[3][4] >> 12) | (ctx[3][5] << 1) | (ctx[3][6] << 14));
    ctx[3][5] = ((ctx[3][6] >> 2) | (ctx[3][7] << 11));
    ctx[3][6] = ((ctx[3][7] >> 5) | (ctx[3][8] << 8));
    ctx[3][7] = ((ctx[3][8] >> 8) | (ctx[3][9] << 5));
    var f = ctx[3][0] + ctx[4][0];
    ctx[3][0] = f;
    for (var i = 1; i < 8; i++) {
      f = (ctx[3][i]) + ctx[4][i] + (f >> 16);
      ctx[3][i] = f;
    }
    for (var i = 8 - 1; i >= 0; i--) {
      this.int16To8(mac, i * 2, ctx[3][i]);
      ctx[4][i] = 0;
    }
    for (var i = 10 - 1; i >= 0; i--) {
      ctx[3][i] = 0;
      ctx[2][i] = 0;
    }
  }

  auth(List<int> mac, List<int> m, var bytes, List<int> key) {
    var ctx = this.init(key);
    this.update(ctx, m, bytes);
    this.finish(ctx, mac);
  }
}
