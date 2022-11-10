--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
]]--

local exports = {}

exports.ends_with = function(str, suffix)
  if str == nil then return false end
  return str:sub(-string.len(suffix)) == suffix
end

exports.starts_with = function(str, prefix)
  if str == nil then return false end
  return str:sub(1, string.len(prefix)) == prefix
end

exports.is_empty = function(str)
  return str == nil or str == ''
end

exports.trim = function(str)
  if str == nil then return nil end
  return str:match("^%s*(.-)%s*$")
end

return exports
