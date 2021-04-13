--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "dart" command (Dart compiler).

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local strings = require("strings")
local sys = require("sys")
local tables = require("tables")


local function extract_commands_from_help(help_command, marker)
  local commands = {}
  local is_command_definition = false

  for _,line in ipairs(sys.exec(help_command)) do
    if is_command_definition then
      local command = strings.trim(line):match("^[a-zA-Z-_]+")

      if not strings.is_empty(command) then
        table.insert(commands, command)
      end
    end

    if string.match(line, marker) then
      is_command_definition = true
    end

    if line == "" then
      is_command_definition = false
    end
  end

  return commands
end


local commands_cache = {}

local function main_commands(word, word_index, line_state)
  if tables.misses_key(commands_cache, "") then
    local commands = extract_commands_from_help("dart --help", "Available commands:")
    if tables.is_empty(commands) then
      return nil
    end
    commands_cache[""] = commands
  end
  return commands_cache[""]
end


local function sub_commands(word, word_index, line_state)
  local main_command = line_state:getword(word_index -1)
  if tables.misses_key(commands_cache, main_command) then
    local commands = extract_commands_from_help("dart "..main_command.." --help", "Available subcommands:")
    if tables.is_empty(commands) then
      return nil
    end
    commands_cache[main_command] = commands
  end
  return commands_cache[main_command]
end


local flags = {
  "-h",
  "--help",

  "-v",
  "--verbose",
  "--version",

  "--enable-analytics",
  "--disable-analytics"
}


clink.argmatcher("dart")
  :addflags(flags)
  :addarg(main_commands)
  :addarg(sub_commands)
