/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import more_clink_completions.completions.Docker;
import sys.FileSystem;
import clink.util.Suggest;
import clink.util.LuaArray;
import clink.api.ArgMatcher;
import clink.api.Clink;

using clink.util.Strings;

/**
 * Clink command line completions for "act". See https://github.com/nektos/act
 */
class Act {

   public static function register() {
      Clink.argMatcher("act").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser
         .addFlags(["-a", "--actor"], "")
         .addFlag("--artifact-server-addr", "")
         .addFlag("--artifact-server-path", "")
         .addFlag("--artifact-server-port", "")
         .addFlags(["-b", "--bind"])
         .addFlag("--bug-report")
         .addFlag("--container-architecture", "")
         .addFlag("--container-cap-add", Docker.Capabilities.getConstructors())
         .addFlag("--container-cap-drop", Docker.Capabilities.getConstructors())
         .addFlag("--container-daemon-socket", "")
         .addFlag("--container-options", "")
         .addFlag("--defaultbranch", "")
         .addFlag("--detect-event")
         .addFlags(["-C", "--diretory"], Suggest.dirs)
         .addFlags(["-n", "--dryrun"])
         .addFlag("--env", "")
         .addFlag("--env-file", Suggest.files)
         .addFlags(["-e", "--eventpath"], Suggest.filesEndingWith(".json"))
         .addFlag("--github-instance", "")
         .addFlags(["-g", "--graph"])
         .addFlags(["-h", "--help"])
         .addFlag("--input", "")
         .addFlag("--input-file", "")
         .addFlag("--insecure-secrets")
         .addFlags(["-j", "--jobs"], suggestJobIds)
         .addFlag("--json")
         .addFlags(["-l", "--list"])
         .addFlag("--no-recurse")
         .addFlag("--no-skip-checkout")
         .addFlags(["-P", "--platform"], "")
         .addFlag("--privileged")
         .addFlags(["-p", "--pull"])
         .addFlags(["-q", "--quiet"])
         .addFlag("--rebuild")
         .addFlag("--remote-name", "")
         .addFlag("--replace-ghe-action-token-with-github-com", "")
         .addFlag("--replace-ghe-action-with-github-com", "")
         .addFlags(["-r", "--reuse"])
         .addFlag("-rm")
         .addFlags(["-s", "--secret"], "")
         .addFlag("--secret-file", "")
         .addFlag("--use-gitignore")
         .addFlags(["-v", "--verbose"])
         .addFlag("--version")
         .addFlags(["-w", "--watch"])
         .addFlags(["-W", "--workflows"], Suggest.filesEndingWith(".yml", ".yaml"))
         .noFiles();
   }

   static function suggestJobIds():LuaArray<String> {
      final jobIds = new LuaArray<String>();
      for (file in FileSystem.readDirectory(".github/workflows")) {

         if (file.endsWith(".yml") || file.endsWith(".yaml")) {
            // poor man's YAML parsing
            final content = sys.io.File.getContent('.github/workflows/$file');
            if (content == null)
               continue;
            var isJobsSection = false;
            var jobsIndention = -1;
            for (line in @:nullSafety(Off) content.split("\n")) {
               if (!isJobsSection) {
                  if (line.startsWith("jobs:")) {
                     isJobsSection = true;
                  }
                  continue;
               }
               if (line == "")
                  continue;
               if (!line.hasMatch("^[%s#]")) {
                  isJobsSection = false;
                  continue;
               }
               final match = line.findMatch("^[%s]+([%w_-]+):");
               if (match != null) {
                  if (jobsIndention == -1) {
                     jobsIndention = line.indexOf(match);
                     jobIds.add(match);
                  } else if (line.indexOf(match) == jobsIndention) {
                     jobIds.add(match);
                  }
               }
            }
         }
      }
      return jobIds;
   }
}
