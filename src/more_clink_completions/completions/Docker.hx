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

class Docker {

   public static function register() {
      Clink.argMatcher("docker").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser
         .addFlags(["-h", "--help"])
         .addFlag("--config", Suggest.dirs)
         .addFlags(["-c", "--context"], Suggest.dirs)
         .addFlags(["-D", "--debug"])
         .addFlags(["-H", "--hosts"], "")
         .addFlags(["-l", "--log-level"], ["debug", "info", "warn", "error", "fatal"])

         .addFlag("-tls")
         .addFlag("-tlscacert", Suggest.files)
         .addFlag("-tlscert", Suggest.files)
         .addFlag("-tlskey", Suggest.files)
         .addFlag("-tlsverify")

         .addFlags(["-v", "--version"])

         .addArg(suggestMainCommands)
         .addArg(suggestSubCommands)
         .noFiles()

         .setClassifier(colorizeCommands);
   }

   static final COMMANDS_CACHE = new Map<String, LuaArray<String>>();

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

   static function suggestMainCommands():LuaArray<String> {
      var commands = COMMANDS_CACHE[""];
      if (commands == null) {
         commands = extractCommandsFromHelp("docker --help");
         if (commands.length() > 0) {
            COMMANDS_CACHE[""] = commands;
         }
      }
      return commands;
   }

   static function suggestSubCommands(word:String, wordIndex:Int, lineState:LineState):LuaArray<String> {
      var mainCommand = lineState.getWord(wordIndex - 1);
      var commands = COMMANDS_CACHE[mainCommand];
      if (commands == null) {
         commands = extractCommandsFromHelp('docker ${mainCommand} --help');
         if (commands.length() > 0) {
            COMMANDS_CACHE[mainCommand] = commands;
         }
      }
      return commands;
   }

   static function colorizeCommands(argIndex:Int, word:String, wordIndex:Int, lineState:LineState, classifications:WordClassifications) {
      if (argIndex > 2) return;

      if (argIndex == 2) {
         suggestMainCommands(); // trigger cache population
         suggestSubCommands(word, wordIndex, lineState); // trigger cache population
         if (COMMANDS_CACHE[word] != null) {
            classifications.classifyWord(wordIndex, ARGUMENT);
         }
      }
   }

}
