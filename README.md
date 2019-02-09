# Salt, a crypto library for Flutter
[![Build Status](https://travis-ci.com/gi097/salt.svg?branch=develop)](https://travis-ci.com/gi097/salt)
[![Stars](http://starveller.sigsev.io/api/repos/gi097/salt/badge)](http://starveller.sigsev.io/gi097/salt)
[![Coverage Status](https://coveralls.io/repos/github/gi097/salt/badge.svg?branch=develop&service=github)](https://coveralls.io/github/gi097/salt?branch=develop)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)

This is a simple and pure Dart library which adds support for cryptography in Flutter apps without
having to use native C bindings. The goal for this project is to slowly adopt several crypto
algorithms with proper tests.

Currently the following crypto algorithms are supported:

- chacha20-poly1305

## Getting started
First of all add the following dependencies to your `pubspec.yaml`:

```
dependencies:
  salt: ^0.1.0
```

Then you will find everything you need in the `Salt` class. Below is an example how to
encrypt and decrypt a message using chacha20-poly1305:

```dart
import 'package:salt/binhex.dart';
import 'package:salt/salt.dart'

var key = BinHex.hex2bin('4290bcb154173531f314af57f3be3b5006da371ece272afa1b5dbdd1100a1007');
var input = BinHex.hex2bin('86d09974840bded2a5ca');
var nonce = BinHex.hex2bin('cd7cf67be39c794a');
var ad = BinHex.hex2bin('87e229d4500845a079c0');

var ciphertext = Salt.chacha20Poly1305Encrypt(input, ad, nonce, key);
var plaintext = Salt.chacha20Poly1305Decrypt(ciphertext, ad, nonce, key);
```

## Notes
- This library uses a lot of ported code from the following repository: https://github.com/devi/Salt
- In this library we use `List<int>` instead of `Uint8List`
