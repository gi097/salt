///
/// Salt
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
class BinHex {
  static List<int> hex2bin(String input) {
    var bytes = new List<int>((input.length / 2).round());
    for (var i = 0; i < input.length; i += 2) {
      bytes[(i / 2).round()] = int.parse(input.substring(i, i + 2), radix: 16);
    }
    return bytes;
  }

  static String bin2hex(List<int> bin) {
    var buffer = "";
    for (var b in bin) {
      buffer += (b + 0x100).toRadixString(16).substring(1);
    }
    return buffer;
  }
}
