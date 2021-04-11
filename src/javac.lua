--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "javac" command (Java Compiler).

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
local suggest_jars = clink.argmatcher():addarg(function(m) return get_dirs_or_files_with(m, ".jar") end)
local suggest_java = clink.argmatcher():addarg(function(m) return get_dirs_or_files_with(m, ".java") end)

local jvm_flags = {
  -- @<filename>
  -- -Akey[=value]
  "--add-modules"..suggest_nothing,

  "--boot-class-path"..suggest_jars,
  "-bootclasspath"..suggest_jars,

  "-cp"..suggest_jars,
  "-classpath"..suggest_jars,
  "--class-path"..suggest_jars,

  "-d"..suggest_dirs,
  "-deprecation",
  "-enable-preview",
  "-encoding"..suggest_nothing,
  "-endorseddirs"..suggest_dirs,

  "-g",
  "-g:lines",
  "-g:source",
  "-g:vars",
  "-g:lines,vars",
  "-g:lines,source",
  "-g:lines,vars,source",
  "-g:none",

  "-h"..suggest_dirs,

  "--help",
  "-help",
  "-?",

  "-help-extra",
  "-X",

  "-implicit:none",
  "-implicit:class",

  -- -J<flag>

  "--limit-modules"..suggest_nothing,
  "--module"..suggest_nothing,
  "-m"..suggest_nothing,

  "--module-path"..suggest_dirs,
  "-p"..suggest_dirs,
  "--module-source-path"..suggest_dirs,
  "--module-version"..suggest_nothing,

  "-nowarn",
  "-parameters",

  "-proc:none",
  "-proc:only",

  "-processor"..suggest_nothing,
  "--processor-module-path"..suggest_dirs,
  "--processor-path"..suggest_dirs,
  "-processorpath"..suggest_dirs,

  "-profile"..suggest_nothing,
  "--release"..suggest("6","7","8","9","10","11"),
  "-s"..suggest_dirs,
  "--source"..suggest("6","7","8","9","10","11"),
  "--system"..suggest_dirs,
  "--target"..suggest("6","7","8","9","10","11"),
  "--upgrade-module-path"..suggest_dirs,
  "-verbose",
  "-version",
  "--version",

  "-Werror"
}

clink.argmatcher("javac")
  :addflags(jvm_flags)
  :addarg(suggest_java)
  :loop(1)
