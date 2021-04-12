--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "curl" command (C:\Windows\system32\curl.exe).

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local strings = require("strings")
local suggest = require("suggest")
local sys = require("sys")

local flags = {}
for i,line in ipairs(sys.exec("curl --help")) do
  if line:match("^%s+-") then
    local short_flag = strings.trim(line:match("%s%-[a-zA-Z0-9]"))
    local long_flag = line:match("%-%-[a-zA-Z0-9-_]+")
    local arg =line:match("<.*>")

    if arg == "<file>" or arg == "<filename>" or arg == "<path>" then
      if short_flag ~= nil then table.insert(flags, short_flag..suggest.files) end
      if long_flag  ~= nil then table.insert(flags, long_flag ..suggest.files) end
    elseif arg == "<dir>" then
      if short_flag ~= nil then table.insert(flags, short_flag..suggest.dirs) end
      if long_flag  ~= nil then table.insert(flags, long_flag ..suggest.dirs) end
    elseif arg ~= nil then
      if short_flag ~= nil then table.insert(flags, short_flag..suggest.nothing) end
      if long_flag  ~= nil then table.insert(flags, long_flag ..suggest.nothing) end
    else
      if short_flag ~= nil then table.insert(flags, short_flag) end
      if long_flag  ~= nil then table.insert(flags, long_flag) end
    end
  end
end

clink.argmatcher("curl")
  :addflags(flags)
  :nofiles()
