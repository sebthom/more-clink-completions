--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Add the lib folder to Lua's package path.
]]--
package.path = debug.getinfo(1, "S").source:match("[^@].*[%\\/]").."lib/?.lua;"..package.path
