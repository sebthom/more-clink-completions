--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "docker" command.

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local strings = require("strings")
local suggest = require("suggest")
local sys = require("sys")
local tables = require("tables")


local function extract_commands_from_help(help_command)
  local commands = {}
  local is_command_definition = false

  for _,line in ipairs(sys.exec(help_command)) do
    if string.match(line, "Commands:") then
      is_command_definition = true
    elseif string.match(line, "Run 'docker") then
      is_command_definition = false
    elseif is_command_definition then
      local command = strings.trim(line):match("^(%S+) ")
      if not strings.is_empty(command) then
        table.insert(commands, command)
      end
    end
  end

  return commands
end


local commands_cache = {}

local function main_commands(word, word_index, line_state)
  if tables.misses_key(commands_cache, "") then
    local commands = extract_commands_from_help("docker --help")
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
    local commands = extract_commands_from_help("docker "..main_command.." --help")
    if tables.is_empty(commands) then
      return nil
    end
    commands_cache[main_command] = commands
  end
  return commands_cache[main_command]
end


local flags = {
  "--config"..suggest.dirs,

  "-c"..suggest.nothing,
  "--context"..suggest.nothing,

  "-D",
  "--debug",

  "-H"..suggest.nothing,
  "--host"..suggest.nothing,

  "--help",

  "-l"..suggest.from("debug","info","warn","error","fatal"),
  "--log-level"..suggest.from("debug","info","warn","error","fatal"),

  "--tls",
  "--tlscacert"..suggest.files,
  "--tlscert"..suggest.files,
  "--tlskey"..suggest.files,
  "--tlsverify",

  "-v", "--version"
}


clink.argmatcher("docker")
  :addflags(flags)
  :addarg(main_commands)
  :addarg(sub_commands)
