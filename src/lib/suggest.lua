--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
]]--

local strings = require("strings")

local exports = {}

exports.from = function(...) return clink.argmatcher():addarg(...) end

exports.nothing = clink.argmatcher():nofiles()

exports.dirs = clink.argmatcher():addarg(clink.dirmatches)

exports.files = clink.argmatcher():addarg(clink.filematches)

exports.files_with = function(suffix)
  return exports.from(function(match_word)
    local matches = clink.filematches(match_word)
    local matches_filtered = {}
    for _,entry in ipairs(matches) do
      if strings.starts_with(entry.type, "dir") or strings.ends_with(entry.match, suffix) then
        table.insert(matches_filtered, entry)
      end
    end
    return matches_filtered
  end)
end

return exports
