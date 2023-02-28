--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
]]--

local strings = require("mcc.strings")

local exports = {}

exports.dump = function(obj, indention)
  local indent = string.rep("  ", indention or 0)
  if obj == null then
    print(indent..nil)
  end

  local objType = type(obj)
  if objType == "table" then
    print(indent..tostring(obj).." {")
  else
    print(indent..objType..": "..tostring(obj)..":".." {")
  end
  for key,value in pairs(objType == "table" and obj or getmetatable(obj)) do
    print(indent.."  "..tostring(key).." -> "..tostring(value))
  end
  print(indent.."}")

end

return exports
