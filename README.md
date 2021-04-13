# more-clink-completions

[![Build Status](https://github.com/sebthom/more-clink-completions/workflows/Build/badge.svg "GitHub Actions")](https://github.com/sebthom/more-clink-completions/actions?query=workflow%3A%22Build%22)
[![License](https://img.shields.io/github/license/sebthom/more-clink-completions.svg?color=blue)](LICENSE.txt)

1. [What is it?](#what-is-it)
1. [Installation](#installation)
1. [License](#license)


## <a name="what-is-it"></a>What is it?

This repository contains Windows command line auto-completion functions to be used with [chrisant996](https://github.com/chrisant996)'s [clink](https://github.com/chrisant996/clink) fork.

Currently completions for the following commands are available:
- [curl.lua](src/curl.lua) for `curl` command - the [cURL](https://techcommunity.microsoft.com/t5/containers/tar-and-curl-come-to-windows/ba-p/382409) HTTP command line client
- [docker.lua](src/docker.lua) for `docker` command - the [Docker](https://docs.docker.com/engine/reference/commandline/cli/) command line client
- [dart.lua](src/dart.lua) for `dart` command - [Dart](https://dart.dev/) compiler
- [haxe.lua](src/haxe.lua) for `haxe` command - [Haxe compiler](https://haxe.org/manual/compiler-usage.html)
- [java.lua](src/java.lua) for `java` command - [Java](https://www.oracle.com/java/technologies/javase-downloads.html) runtime
- [javac.lua](src/javac.lua) for `javac` command - [Java](https://docs.oracle.com/en/java/javase/index.html) compiler
- [mvn.lua](src/mvn.lua) for `mvn` command - [Apache Maven](https://maven.apache.org) build tool
- [openssl.lua](src/openssl.lua) for `openssl` command - [OpenSSL](https://github.com/openssl/openssl) command line tool

You need other completions? Try https://github.com/vladimir-kotikov/clink-completions

You want to create your own completions? Read https://chrisant996.github.io/clink/clink.html#extending-clink


## Installation

1. Download and install latest clink release from https://github.com/chrisant996/clink/releases
1. Git clone or download this repo to your local machine
1. Open command prompt
1. Load clink using `<clink_install_dir>\clink.bat inject`
1. Run `clink installscripts "[PATH_YOU_SELECTED]\more-clink-completions\src"` to load the auto-completion scripts


## <a name="license"></a>License

All files are released under the [MIT License](LICENSE.txt).

Individual files contain the following tag instead of the full license text:
```
SPDX-License-Identifier: MIT
```

This enables machine processing of license information based on the SPDX License Identifiers that are available here: https://spdx.org/licenses/.
