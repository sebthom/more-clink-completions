--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
]]--

local exports = {}

exports.contains_key = function(table, key)
  return table ~= nil and table[key] ~= nil
end

exports.misses_key = function(table, key)
  return table == nil or table[key] == nil
end

exports.contains_value = function(table, value)
  if table == nil then return false end
  for _, v in pairs(table) do
    if value == v then
      return true
    end
  end
  return false
end

exports.is_empty = function(table)
  return table == nil or  next(table) == nil
end

return exports
