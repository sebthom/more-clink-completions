--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "docker" command.

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local function trim(str)
  return str:match("^%s*(.-)%s*$")
end

local function is_empty(str)
  return str == nil or str == ''
end

local function exec(command)
  local stdout = {}
  local process = io.popen(command)
  if process then
    for line in process:lines() do
      table.insert(stdout, line)
    end
    process:close()
  end
  return stdout
end

local function extract_commands_from_help(help_command)
  local commands = {}
  local is_command_definition = false

  for i,line in ipairs(exec(help_command)) do
    if is_command_definition then
      local command = trim(line):match("^(%S+) ")

      if not is_empty(command) then
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

local function docker_main_commands(word, word_index, line_state)
  return extract_commands_from_help("docker --help")
end

local function docker_sub_commands(word, word_index, line_state)
  local main_command = line_state:getword(word_index -1)
  return extract_commands_from_help("docker "..main_command.." --help")
end

local function suggest(...)
  return clink.argmatcher():addarg(...)
end

local suggest_nothing = clink.argmatcher():nofiles()
local suggest_dirs = clink.argmatcher():addarg(clink.dirmatches)
local suggest_files = clink.argmatcher():addarg(clink.filematches)


clink.argmatcher("docker")
  :addflags(
    "--config"..suggest_dirs,

    "-c"..suggest_nothing,
    "--context"..suggest_nothing,

    "-D",
    "--debug",

    "-H"..suggest_nothing,
    "--host"..suggest_nothing,

    "--help",

    "-l"..suggest("debug","info","warn","error","fatal"),
    "--log-level"..suggest("debug","info","warn","error","fatal"),

    "--tls",
    "--tlscacert"..suggest_files,
    "--tlscert"..suggest_files,
    "--tlskey"..suggest_files,
    "--tlsverify",

    "-v", "--version"
  )
  :addarg(docker_main_commands)
  :addarg(docker_sub_commands)
