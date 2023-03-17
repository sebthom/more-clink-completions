# more-clink-completions (v2)

[![Build Status](https://github.com/sebthom/more-clink-completions/workflows/Build/badge.svg "GitHub Actions")](https://github.com/sebthom/more-clink-completions/actions?query=workflow%3A%22Build%22)
[![License](https://img.shields.io/github/license/sebthom/more-clink-completions.svg?color=blue)](LICENSE.txt)

**Contributions are highly welcome!**

1. [What is it?](#what-is-it)
1. [Installation](#installation)
1. [License](#license)


## <a name="what-is-it"></a>What is it?

This repository contains Windows command line auto-completion functions to be used with [chrisant996](https://github.com/chrisant996)'s awesome [clink](https://github.com/chrisant996/clink) fork.

The completions are programmed in the strictly typed programming language [Haxe](https://haxe.org) and transpiled to [Lua](https://www.lua.org/).

Currently completions for the following commands are available:
- [Act.hx](src/more_clink_completions/completions/Act.hx) for `act` command - [nektos/act](https://github.com/nektos/act) local GitHub actions runner.
- [Curl.hx](src/more_clink_completions/completions/Curl.hx) for `curl` command - [cURL](https://techcommunity.microsoft.com/t5/containers/tar-and-curl-come-to-windows/ba-p/382409) HTTP command line client
- [Dart.hx](src/more_clink_completions/completions/Dart.hx) for `dart` command - [Dart](https://dart.dev/) compiler
- [Docker.hx](src/more_clink_completions/completions/Docker.hx) for `docker` command - [Docker](https://docs.docker.com/engine/reference/commandline/cli/) command line client
- [DockerMachine.hx](src/more_clink_completions/completions/DockerMachine.hx) for `docker-machine` command - [Docker Machine](https://github.com/kaosagnt/docker-machine) command line client
- [Haxe.hx](src/more_clink_completions/completions/Haxe.hx) for `haxe` command - [Haxe compiler](https://haxe.org/manual/compiler-usage.html)
- [Java.hx](src/more_clink_completions/completions/Java.hx) for `java` command - [Java](https://www.oracle.com/java/technologies/javase-downloads.html) runtime
- [JavaC.hx](src/more_clink_completions/completions/JavaC.hx) for `javac` command - [Java](https://docs.oracle.com/en/java/javase/index.html) compiler
- [Lua.hx](src/more_clink_completions/completions/Lua.hx) for `lua` command - [Lua interpreter](lua.org/)
- [Maven.hx](src/more_clink_completions/completions/Maven.hx) for `mvn` command - [Apache Maven](https://maven.apache.org) build tool
- [OpenSSL.hx](src/more_clink_completions/completions/OpenSSL.hx) for `openssl` command - [OpenSSL](https://github.com/openssl/openssl) command line tool

You need other completions? Try https://github.com/vladimir-kotikov/clink-completions

You want to create your own completions ...
- using [Lua](https://www.lua.org/)? Read https://chrisant996.github.io/clink/clink.html#extending-clink
- using [Haxe](https://haxe.org)? Use https://github.com/vegardit/haxe-clink-externs


## Installation

### 1. Installing clink

Install clink according to https://chrisant996.github.io/clink/clink.html#usage, e.g.
1. Open a Windows command prompt
1. Download and install the latest clink release from https://github.com/chrisant996/clink/releases
1. Load clink using `[CLINK_INSTALL_DIR]\clink.bat inject`

### 2. Install more-clink-completions

1. Using git
    1. Open a Windows command prompt
    1. Git clone the [v2-release](https://github.com/sebthom/more-clink-completions/tree/v2-releases) branch, .e.g
       ```batch
       git clone https://github.com/sebthom/more-clink-completions --branch v2-release --single-branch [REPO_PATH]
       ```
    1. Run
       ```batch
       clink installscripts "[REPO_PATH]" to load the auto-completion scripts
       ```

1. Using curl or manual download
    1. Open a Windows command prompt
    1. Download the latest version of [more-clink-completions.lua](https://github.com/sebthom/more-clink-completions/releases/download/latest-v2/more-clink-completions.lua),
       via the Browser or via the command line e.g.
       ```batch
       curl -o "[DOWNLOAD_DIR]\more-clink-completions.lua" https://github.com/sebthom/more-clink-completions/releases/download/latest-v2/more-clink-completions.lua
       ```
    1. Register the completions with clink using
       ```batch
       clink installscripts "[DOWNLOAD_DIR]"
       ```


## <a name="license"></a>License

All files are released under the [MIT License](LICENSE.txt).

Individual files contain the following tag instead of the full license text:
```
SPDX-License-Identifier: MIT
```

This enables machine processing of license information based on the SPDX License Identifiers that are available here: https://spdx.org/licenses/.

An exception is made for:
1. files in readable text which contain their own license information, or
2. files in a directory containing a separate `LICENSE.txt` file, or
3. files where an accompanying file exists in the same directory with a `.LICENSE.txt` suffix added to the base-name of the original file.
   For example `foobar.js` is may be accompanied by a `foobar.LICENSE.txt` license file.
