--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "mvn" command.

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local function starts_with(str, prefix)
  return str:sub(1, string.len(prefix)) == prefix
end

local function ends_with(str, suffix)
  return str:sub(-string.len(suffix)) == suffix
end

local function get_dirs_or_files_with(match_word, suffix)
  local matches = clink.filematches(match_word)
  local matches_filtered = {}
  for index, entry in ipairs(matches) do
    if starts_with(entry.type, "dir") or ends_with(entry.match, suffix) then
      table.insert(matches_filtered, entry)
    end
  end
  return matches_filtered
end

local suggest_nothing = clink.argmatcher():nofiles()
local suggest_files = clink.argmatcher():addarg(clink.filematches)
local suggest_xmls = clink.argmatcher():addarg(function(m) return get_dirs_or_files_with(m, ".xml") end)


local maven_flags = {
  "-am", "--also-make",
  "-amd", "--also-make-dependents",
  "-B", "--batch-mode",
  "-b"..suggest_nothing, "--builder"..suggest_nothing,
  "-C", "--strict-checksums",
  "-c", "--lax-checksums",
  "-cpu", "--check-plugin-updates",
  "--define"..suggest_nothing, -- "-D"
  "-e", "--errors",
  "-emp"..suggest_nothing, "--encrypt-master-password"..suggest_nothing,
  "-ep"..suggest_nothing, "--encrypt-password"..suggest_nothing,
  "-f"..suggest_xmls, "--file"..suggest_xmls,
  "-fae", "--fail-at-end",
  "-ff", "--fail-fast",
  "-fn", "--fail-never",
  "-gs"..suggest_xmls, "--global-settings"..suggest_xmls,
  "-gt"..suggest_xmls, "--global-toolchains"..suggest_xmls,
  "-h", "--help",
  "-l"..suggest_files, "--log-file"..suggest_files,
  "-llr", "--legacy-local-repository",
  "-N", "--non-recursive",
  "-npr", "--no-plugin-registry",
  "-npu", "--no-plugin-updates",
  "-nsu", "--no-snapshot-updates",
  "-ntp", "--no-transfer-progress",
  "-o", "--offline",
  "-P"..suggest_nothing, "--activate-profiles"..suggest_nothing,
  "-pl"..suggest_nothing, "--projects"..suggest_nothing,
  "-rf"..suggest_nothing, "--resume-from"..suggest_nothing,
  "-q", "--quiet",
  "-s"..suggest_xmls, "--settings"..suggest_xmls,
  "-t"..suggest_xmls, "--toolchains"..suggest_xmls,
  "--threads"..suggest_nothing, -- "-T"
  "-U", "--update-snapshots",
  "-up", "--update-plugins",
  "-v", "--version",
  "-V", "--show-version",
  "-X", "--debug",

  "-DskipITs",
  "-DskipTests",
  "-Dmaven.test.skip=true"
}


local maven_goals = {
  "pre-clean",
  "clean",
  "post-clean",

  "install",
  "validate",
  "initialize",
  "generate-sources",
  "process-sources",
  "generate-resources",
  "process-resources",
  "compile",
  "process-classes",
  "generate-test-sources",
  "process-test-sources",
  "generate-test-resources",
  "process-test-resources",
  "test-compile",
  "process-test-classes",
  "test",
  "prepare-package",
  "package",
  "pre-integration-test",
  "integration-test",
  "post-integration-test",
  "verify",
  "install",
  "deploy",

  "pre-site",
  "site",
  "post-site",
  "site-deploy",

  "archetype:generate",
  "dependency:tree",
  "exec:exec",
  "help:active-profiles",
  "help:all-profiles",
  "help:describe",
  "help:effective-pom",
  "help:effective-settings",
  "help:evaluate",
  "help:expressions",
  "help:help",
  "help:system",
  "plugin:help",
  "versions:display-dependency-updates",
  "versions:display-plugin-updates"
}


local function colorize_maven_goals(arg_index, word, word_index, line_state, classifications)
  -- see https://chrisant996.github.io/clink/clink.html#word_classifications
  -- see https://github.com/chrisant996/clink/blob/e28c70fe2018ddfd5998bda4a587fb13825ca5b9/clink/app/scripts/self.lua#L221

  if maven_goals[word] ~= nil then
    classifications:classifyword(word_index, "a")
  end
end


clink.argmatcher("mvn")
  :setclassifier(colorize_maven_goals)
  :addflags(maven_flags)
  :addarg(maven_goals)
  :loop(1)
