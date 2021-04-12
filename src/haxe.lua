--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "haxe" command (Haxe Compiler).

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local strings = require("strings")
local suggest = require("suggest")
local sys = require("sys")


local suggest_haxe_defines_cache = {}
local suggest_haxe_defines = suggest.from(function(match_word)
  if next(suggest_haxe_defines_cache) == nil then
    for i,line in ipairs(sys.exec("haxe --help-defines")) do
      if line:match("%s[a-zA-Z-_]+%s+:") then
        local define=line:match("[a-zA-Z-_]+")
        table.insert(suggest_haxe_defines_cache, define)
      end
    end
  end
  return suggest_haxe_defines_cache
end)


local flags = {
  --------------------
  -- Target:
  --------------------
  "--js"..suggest.files_with(".js"),
  "--lua"..suggest.files_with(".lua"),
  "--swf"..suggest.files_with(".swf"),
  "--neko"..suggest.files_with(".n"),
  "--php"..suggest.dirs,
  "--cpp"..suggest.dirs,
  "--cppia"..suggest.files_with(".cppia"),
  "--cs"..suggest.dirs,
  "--java"..suggest.dirs,
  "--jvm"..suggest.files_with(".class"),
  "--python"..suggest.files_with(".py"),
  "--hl"..suggest.files_with(".hl"),
  "--interp",
  "--run"..suggest.nothing,

  --------------------
  -- Compilation:
  --------------------
  "-p"..suggest.dirs,
  "-class-path"..suggest.dirs,

  "-m"..suggest.dirs,
  "--main"..suggest.nothing,

  "-L"..suggest.dirs,
  "--library"..suggest.nothing,

  "-D"..suggest_haxe_defines,
  "--define"..suggest_haxe_defines,

  "-R"..suggest.files,
  "--resource"..suggest.files,

  "--cmd"..suggest.nothing,
  "--remap"..suggest.nothing,
  "--macro"..suggest.nothing,

  "-C"..suggest.dirs,
  "--cwd"..suggest.dirs,

  "--haxelib-global",

  --------------------
  -- Optimization:
  --------------------
  "-dce"..suggest.from("std","full","no"),
  "--no-traces",
  "--no-output",
  "--no-inline",
  "--no-opt",

  --------------------
  -- Debug:
  --------------------
  "-v",
  "--verbose",

  "--debug",
  "--prompt",
  "--times",

  --------------------
  -- Batch:
  --------------------
  "--next",
  "--each",

  --------------------
  -- Services:
  --------------------
  "--display",
  "--xml"..suggest.files_with(".xml"),
  "--json"..suggest.files_with(".xml"),

  --------------------
  -- Compilation Server:
  --------------------
  "--server-listen"..suggest.nothing,
  "--server-connect"..suggest.nothing,
  "--connect"..suggest.nothing,

  --------------------
  -- Target-specific:
  --------------------
  "--swf-version"..suggest.nothing,
  "--swf-header"..suggest.nothing,
  "--flash-strict",
  "--swf-lib"..suggest.files_with(".swf"),
  "--swf-lib-extern"..suggest.files_with(".swf"),
  "--jar-lib"..suggest.files_with(".jar"),
  "--jar-lib-extern"..suggest.files_with(".jar"),
  "--net-lib"..suggest.files_with(".dll"),
  "--net-std"..suggest.files_with(".dll"),
  "--c-arg"..suggest.nothing,

  --------------------
  -- Miscellaneous:
  --------------------
  "--version",

  "-h",
  "--help",

  "--help-defines",
  "--help-metas",
}


clink.argmatcher("haxe")
  :addflags(flags)
  :addarg(suggest.files_with(".hxml"))
