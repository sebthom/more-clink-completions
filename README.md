# more-clink-completions

1. [What is it?](#what-is-it)
1. [Installation](#installation)
1. [License](#license)


## <a name="what-is-it"></a>What is it?

This repository contains Windows command line auto-completion functions to be used with [chrisant996](https://github.com/chrisant996)'s [clink](https://github.com/chrisant996/clink) fork.

Currently completions for the following commands are available:
- [docker.lua](src/docker.lua) for `docker` command - the Docker command line client
- [java.lua](src/java.lua) for `java` command - Java Runtime
- [javac.lua](src/javac.lua) for `javac` command - Java Compiler
- [mvn.lua](src/mvn.lua) for `mvn` command - Apache Maven build tool

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
