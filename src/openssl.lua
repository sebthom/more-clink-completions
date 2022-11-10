--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "docker" command.

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local sys = require("mcc.sys")
local tables = require("mcc.tables")


local function extract_commands_from_help(help_command)
  local commands = {}

  for _,line in ipairs(sys.exec(help_command)) do
    if not line == "" and not string.find(line, "commands") then
      for command in string.gmatch(line, "[a-zA-Z0-9-_]+") do
        table.insert(commands, command)
      end
    end
  end

  return commands
end


local commands_cache = {}

local function main_commands(word, word_index, line_state)
  if tables.misses_key(commands_cache, "") then
    local commands = extract_commands_from_help('cmd /C "openssl help 2>&1"')
    if tables.is_empty(commands) then
      return nil
    end
    commands_cache[""] = commands
  end
  return commands_cache[""]
end


clink.argmatcher("openssl")
  :addarg(main_commands)
