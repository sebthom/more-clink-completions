/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import clink.api.LineState;
import clink.api.ArgMatcher;
import clink.api.Clink;
import clink.util.Suggest;

class Maven {

   public static function register() {
      Clink.argMatcher("mvn").setDelayedInitializer(registerNow);
   }

   static final MAVEN_GOALS = [
      "pre-clean",
      "clean",
      "post-clean",
      //
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
      //
      "pre-site",
      "site",
      "post-site",
      "site-deploy",
      //
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
   ];

   static function colorizeMavenGoals(argIndex:Int, word:String, wordIndex:Int, lineState:LineState, classifications:WordClassifications) {
      if (MAVEN_GOALS.contains(word)) {
         classifications.classifyWord(wordIndex, ARGUMENT);
      }
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser //
         .addFlags(["-am", "--also-make"])
         .addFlags(["-amd", "--also-make-dependents"])
         .addFlags(["-B", "--batch-mode"])
         .addFlags(["-b", "--builder"], Suggest.nothing)
         .addFlags(["-C", "--strict-checksums"])
         .addFlags(["-c", "--lax-checksums"])
         .addFlags(["-D", "--define"], Suggest.nothing)
         .addFlags(["-e", "--errors"])
         .addFlags(["-emp", "--encrypt-master-password"], Suggest.nothing)
         .addFlags(["-ep", "--encrypt-password"], Suggest.nothing)
         .addFlags(["-f", "--file"], Suggest.filesEndingWith(".xml"))
         .addFlags(["-fae", "--fail-at-end"])
         .addFlags(["-ff", "--fail-fast"])
         .addFlags(["-fn", "--fail-never"])
         .addFlags(["-gs", "--global-settings"], Suggest.filesEndingWith(".xml"))
         .addFlags(["-gt", "--global-toolchains"], Suggest.filesEndingWith(".xml"))
         .addFlags(["-h", "--help"])
         .addFlags(["-l", "--log-file"], Suggest.files)
         .addFlags(["-llr", "--legacy-local-repository"])
         .addFlags(["-N", "--non-recursive"])
         .addFlags(["-npr", "--no-plugin-registry"])
         .addFlags(["-npu", "--no-plugin-updates"])
         .addFlags(["-nsu", "--no-snapshot-updates"])
         .addFlags(["-ntp", "--no-transfer-progress"])
         .addFlags(["-o", "--offline"])
         .addFlags(["-P", "--active-profiles"], Suggest.nothing)
         .addFlags(["-pl", "--projects"], Suggest.nothing)
         .addFlags(["-rf", "--resume-from"], Suggest.nothing)
         .addFlags(["-q", "--quiet"])
         .addFlags(["-s", "--settings"], Suggest.filesEndingWith(".xml"))
         .addFlags(["-t", "--toolchains"], Suggest.filesEndingWith(".xml"))
         .addFlags(["-T", "--threads"], [Suggest.range(1, 9)])
         .addFlags(["-U", "--update-snapshots"])
         .addFlags(["-up", "--update-plugins"])
         .addFlags(["-v", "--version"])
         .addFlags(["-V", "--show-version"])
         .addFlags(["-X", "--debug"])
            //
         .addFlags(["-DskipITs"])
         .addFlags(["-DskipTests"])
         .addFlags(["-Dmaven.test.skip=true"])
            //
         .addArg(MAVEN_GOALS) //
         .setClassifier(colorizeMavenGoals)
         .loop(1)
         .noFiles();
   }
}
