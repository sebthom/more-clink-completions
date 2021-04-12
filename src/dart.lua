--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "dart" command (Dart compiler).

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local strings = require("strings")
local sys = require("sys")

local function extract_commands_from_help(help_command, marker)
  local commands = {}
  local is_command_definition = false

  for i,line in ipairs(sys.exec(help_command)) do
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

local function dart_main_commands(word, word_index, line_state)
  if commands_cache[""] == nil then
    local commands = extract_commands_from_help("dart --help", "Available commands:")
    if next(commands) == nil then
      return nil
    end
    commands_cache[""] = commands
  end
  return commands_cache[""]
end

local function dart_sub_commands(word, word_index, line_state)
  local main_command = line_state:getword(word_index -1)
  if commands_cache[main_command] == nil then
    local commands = extract_commands_from_help("dart "..main_command.." --help", "Available subcommands:")
    if next(commands) == nil then
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
  :addarg(dart_main_commands)
  :addarg(dart_sub_commands)
