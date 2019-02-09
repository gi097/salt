# Salt. A Crypto library for Flutter
[![Build Status](https://travis-ci.com/gi097/salt.svg?branch=develop)](https://travis-ci.com/gi097/salt)
[![Stars](http://starveller.sigsev.io/api/repos/gi097/salt/badge)](http://starveller.sigsev.io/gi097/salt)
[![Coverage Status](https://coveralls.io/repos/github/gi097/salt/badge.svg?branch=develop&service=github)](https://coveralls.io/github/gi097/salt?branch=develop)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)

This is a simple and pure Dart library which adds support for cryptography in Flutter apps without
having to use native C bindings.

Currently the following algorithms are supported:

- `chacha20-poly1305`

## Getting started
First of all add the following dependencies to your `pubspec.yaml`:

```
dependencies:
  salt: ^0.0.1
```

## Usage
This library contains a class `Salt` which provides all high level functions.

## Notes
This library uses a lot of ported code from the following repository: https://github.com/devi/Salt
