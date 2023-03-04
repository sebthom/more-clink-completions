/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import clink.util.Suggest;
import clink.api.LineState;
import clink.util.LuaArray;
import clink.api.ArgMatcher;
import clink.api.Clink;
import more_clink_completions.util.Utils;

using clink.util.Strings;

class DockerMachine {

   public static function register() {
      Clink.argMatcher("docker-machine").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser
         .addFlags(["-D", "--debug"])
         .addFlag("--storage-path", Suggest.dirs)
         .addFlag("--tls-ca-cert", Suggest.files)
         .addFlag("--tls-ca-key", Suggest.files)
         .addFlag("--tls-client-cert", Suggest.files)
         .addFlag("--tls-client-key", Suggest.files)
         .addFlag("--github-api-token", Suggest.nothing)
         .addFlag("--native-ssh", Suggest.nothing)
         .addFlag("--bugsnag-api-token", Suggest.nothing)

         .addFlags(["-h", "--help"])
         .addFlags(["-v", "--version"])

         .addArg(suggestCommands)
         .noFiles()

         .setClassifier(colorizeCommands);
   }

   static var COMMANDS_CACHE = new LuaArray<String>();

   static function extractCommandsFromHelp(helpCommand:String):LuaArray<String> {
      final commands = new LuaArray<String>();
      var isCommandsSection = false;
      for (line in Utils.exec(helpCommand)) {
         if (isCommandsSection) {
            if (line == "")
               isCommandsSection = false;
            else {
               final command = line.findMatch("^%s+([a-zA-Z-_]+)");
               if (command != null)
                  commands.add(command);
            }
         } else if (line.hasMatch("Commands:"))
            isCommandsSection = true;
      }
      return commands;
   }

   static function suggestCommands():LuaArray<String> {
      if (COMMANDS_CACHE.length() == 0) {
         COMMANDS_CACHE = extractCommandsFromHelp("docker-machine --help");
      }
      return COMMANDS_CACHE;
   }

   static function colorizeCommands(argIndex:Int, word:String, wordIndex:Int, lineState:LineState, classifications:WordClassifications) {
      if (argIndex == 1) {
         suggestCommands(); // trigger cache population
          if (COMMANDS_CACHE.contains(word)) {
            classifications.classifyWord(wordIndex, ARGUMENT);
         }
      }
   }
}
