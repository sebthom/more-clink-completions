--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "javac" command (Java Compiler).

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local suggest = require("suggest")
local suggest_jars = suggest.files_with(".jar")


local jvm_flags = {
  -- @<filename>
  -- -Akey[=value]
  "--add-modules"..suggest.nothing,

  "--boot-class-path"..suggest_jars,
  "-bootclasspath"..suggest_jars,

  "-cp"..suggest_jars,
  "-classpath"..suggest_jars,
  "--class-path"..suggest_jars,

  "-d"..suggest.dirs,
  "-deprecation",
  "-enable-preview",
  "-encoding"..suggest.nothing,
  "-endorseddirs"..suggest.dirs,

  "-g",
  "-g:lines",
  "-g:source",
  "-g:vars",
  "-g:lines,vars",
  "-g:lines,source",
  "-g:lines,vars,source",
  "-g:none",

  "-h"..suggest.dirs,

  "--help",
  "-help",
  "-?",

  "-help-extra",
  "-X",

  "-implicit:none",
  "-implicit:class",

  -- -J<flag>

  "--limit-modules"..suggest.nothing,
  "--module"..suggest.nothing,
  "-m"..suggest.nothing,

  "--module-path"..suggest.dirs,
  "-p"..suggest.dirs,
  "--module-source-path"..suggest.dirs,
  "--module-version"..suggest.nothing,

  "-nowarn",
  "-parameters",

  "-proc:none",
  "-proc:only",

  "-processor"..suggest.nothing,
  "--processor-module-path"..suggest.dirs,
  "--processor-path"..suggest.dirs,
  "-processorpath"..suggest.dirs,

  "-profile"..suggest.nothing,
  "--release"..suggest.from("6","7","8","9","10","11"),
  "-s"..suggest.dirs,
  "--source"..suggest.from("6","7","8","9","10","11"),
  "--system"..suggest.dirs,
  "--target"..suggest.from("6","7","8","9","10","11"),
  "--upgrade-module-path"..suggest.dirs,
  "-verbose",
  "-version",
  "--version",

  "-Werror"
}


clink.argmatcher("javac")
  :addflags(jvm_flags)
  :addarg(suggest.files_with(".java"))
  :loop(1)
