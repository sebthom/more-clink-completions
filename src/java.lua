--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "java" command.

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local suggest = require("suggest")
local suggest_jars = suggest.files_with(".jar")

local flags = {
  "-cp"..suggest_jars,
  "-classpath"..suggest_jars,
  "--class-path"..suggest_jars,

  "-p"..suggest.dirs,
  "--module-path"..suggest.dirs,
  "--upgrade-module-path"..suggest.dirs,

  "--add-modules"..suggest.from("ALL-DEFAULT", "ALL-SYSTEM", "ALL-MODULE-PATH"),
  "--list-modules",

  "-d"..suggest.nothing,
  "--describe-module"..suggest.nothing,

  "--dry-run",
  "--validate-modules",
  -- -D<name>=<value>

  "-verbose:class",
  "-verbose:module",
  "-verbose:gc",
  "-verbose:jni",

  "-version",
  "--version",
  "-showversion",
  "--show-version",

  "-?",
  "-h",
  "-help",
  "--help",

  "-X",
  "--help-extra",

  -- -ea[:<packagename>...|:<classname>]
  -- -enableassertions[:<packagename>...|:<classname>]
  -- -da[:<packagename>...|:<classname>]
  -- -disableassertions[:<packagename>...|:<classname>]

  "-esa",
  "-enablesystemassertions",

  "-dsa",
  "-disablesystemassertions",

  -- -agentlib:<libname>[=<options>]
  -- -agentpath:<pathname>[=<options>]
  -- -javaagent:<jarpath>[=<options>]
  -- -splash:<imagepath>
  -- @argument files
  -- -disable-@files

  "--enable-preview"
}

local flags2 = {
  "-jar"..suggest_jars,
  "-m"..suggest.nothing,
  "--module"..suggest.nothing,
}


clink.argmatcher("java")
  :addflags(flags)
  :addflags(flags2)

