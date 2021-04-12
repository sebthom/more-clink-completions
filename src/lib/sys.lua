--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
]]--

local exports = {}

exports.exec = function(command)
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

return exports
