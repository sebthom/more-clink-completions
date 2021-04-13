--[[
  SPDX-FileCopyrightText: Copyright 2021 by Sebastian Thomschke and contributors
  SPDX-License-Identifier: MIT
  SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions

  Clink command line completions for "mvn" command.

  See https://chrisant996.github.io/clink/clink.html#extending-clink for clink API.
]]--

local suggest = require("suggest")
local suggest_xmls = suggest.files_with(".xml")
local tables = require("tables")


local flags = {
  "-am", "--also-make",
  "-amd", "--also-make-dependents",
  "-B", "--batch-mode",
  "-b"..suggest.nothing, "--builder"..suggest.nothing,
  "-C", "--strict-checksums",
  "-c", "--lax-checksums",
  "-cpu", "--check-plugin-updates",
  "--define"..suggest.nothing, -- "-D"
  "-e", "--errors",
  "-emp"..suggest.nothing, "--encrypt-master-password"..suggest.nothing,
  "-ep"..suggest.nothing, "--encrypt-password"..suggest.nothing,
  "-f"..suggest_xmls, "--file"..suggest_xmls,
  "-fae", "--fail-at-end",
  "-ff", "--fail-fast",
  "-fn", "--fail-never",
  "-gs"..suggest_xmls, "--global-settings"..suggest_xmls,
  "-gt"..suggest_xmls, "--global-toolchains"..suggest_xmls,
  "-h", "--help",
  "-l"..suggest.files, "--log-file"..suggest.files,
  "-llr", "--legacy-local-repository",
  "-N", "--non-recursive",
  "-npr", "--no-plugin-registry",
  "-npu", "--no-plugin-updates",
  "-nsu", "--no-snapshot-updates",
  "-ntp", "--no-transfer-progress",
  "-o", "--offline",
  "-P"..suggest.nothing, "--activate-profiles"..suggest.nothing,
  "-pl"..suggest.nothing, "--projects"..suggest.nothing,
  "-rf"..suggest.nothing, "--resume-from"..suggest.nothing,
  "-q", "--quiet",
  "-s"..suggest_xmls, "--settings"..suggest_xmls,
  "-t"..suggest_xmls, "--toolchains"..suggest_xmls,
  "--threads"..suggest.nothing, -- "-T"
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

  if tables.contains_key(maven_goals, word) then
    classifications:classifyword(word_index, "a")
  end
end


clink.argmatcher("mvn")
  :addflags(flags)
  :addarg(maven_goals)
  :setclassifier(colorize_maven_goals)
  :loop(1)
