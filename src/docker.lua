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


local function extract_commands_from_help(help_command)
  local commands = {}
  local is_command_definition = false

  for i,line in ipairs(sys.exec(help_command)) do
    if is_command_definition then
      local command = strings.trim(line):match("^(%S+) ")

      if not strings.is_empty(command) then
        table.insert(commands, command)
      end
    end

    if string.match(line, "Commands:") then
      is_command_definition = true
    end

    if string.match(line, "Run 'docker") then
      is_command_definition = false
    end
  end

  return commands
end


local commands_cache = {}

local function docker_main_commands(word, word_index, line_state)
  if commands_cache[""] == nil then
    local commands = extract_commands_from_help("docker --help")
    if next(commands) == nil then
      return nil
    end
    commands_cache[""] = commands
  end
  return commands_cache[""]
end


local function docker_sub_commands(word, word_index, line_state)
  local main_command = line_state:getword(word_index -1)
  if commands_cache[main_command] == nil then
    local commands = extract_commands_from_help("docker "..main_command.." --help")
    if next(commands) == nil then
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
  :addarg(docker_main_commands)
  :addarg(docker_sub_commands)
