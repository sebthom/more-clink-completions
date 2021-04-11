--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "java" command.

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local function starts_with(str, prefix)
  return str:sub(1, string.len(prefix)) == prefix
end

local function ends_with(str, suffix)
  return str:sub(-string.len(suffix)) == suffix
end

local function get_dirs_or_files_with(match_word, suffix)
  local matches = clink.filematches(match_word)
  local matches_filtered = {}
  for index, entry in ipairs(matches) do
    if starts_with(entry.type, "dir") or ends_with(entry.match, suffix) then
      table.insert(matches_filtered, entry)
    end
  end
  return matches_filtered
end

local function suggest(...)
  return clink.argmatcher():addarg(...)
end

local suggest_nothing = clink.argmatcher():nofiles()
local suggest_dirs = clink.argmatcher():addarg(clink.dirmatches)
local suggest_files = clink.argmatcher():addarg(clink.filematches)
local suggest_jars = clink.argmatcher():addarg(function(m) return get_dirs_or_files_with(m, ".jar") end)

local jvm_flags1 = {
  "-cp"..suggest_jars,
  "-classpath"..suggest_jars,
  "--class-path"..suggest_jars,

  "-p"..suggest_dirs,
  "--module-path"..suggest_dirs,
  "--upgrade-module-path"..suggest_dirs,

  "--add-modules"..suggest("ALL-DEFAULT", "ALL-SYSTEM", "ALL-MODULE-PATH"),
  "--list-modules",

  "-d"..suggest_nothing,
  "--describe-module"..suggest_nothing,

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

local jvm_flags2 = {
  "-jar"..suggest_jars,
  "-m"..suggest_nothing,
  "--module"..suggest_nothing,
}

clink.argmatcher("java")
  :addflags(jvm_flags1)
  :addflags(jvm_flags2)
