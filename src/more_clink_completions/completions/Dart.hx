/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import clink.api.LineState;
import clink.util.LuaArray;
import clink.api.ArgMatcher;
import clink.api.Clink;
import more_clink_completions.util.Utils;

using clink.util.Strings;

class Dart {

   public static function register() {
      Clink.argMatcher("dart").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser.addFlags([
         "-h", "--help",
         "-v", "--verbose",
         "--version",
         "--enable-analytics",
         "--disable-analytics"
      ])
         .addArg(suggestMainCommands)
         .addArg(suggestSubCommands)
         .noFiles();
   }

   static final COMMANDS_CACHE = new Map<String, LuaArray<String>>();

   static function extractCommandsFromHelp(helpCommand:String, commandSectionMarker:String):LuaArray<String> {
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
         } else if (line.hasMatch(commandSectionMarker))
            isCommandsSection = true;
      }
      return commands;
   }

   static function suggestMainCommands():LuaArray<String> {
      var mainCommands = COMMANDS_CACHE[""];
      if (mainCommands == null) {
         mainCommands = extractCommandsFromHelp("dart --help", "Available commands:");
         if (mainCommands.length() > 0) {
            COMMANDS_CACHE[""] = mainCommands;
         }
      }
      return mainCommands;
   }

   static function suggestSubCommands(word:String, wordIndex:Int, lineState:LineState):LuaArray<String> {
      suggestMainCommands(); // trigger cache population

      var mainCommand = lineState.getWord(wordIndex - 1);
      if (@:nullSafety(Off) !COMMANDS_CACHE[""].contains(mainCommand)) {
         return [];
      }

      var subCommands = COMMANDS_CACHE[mainCommand];
      if (subCommands == null) {
         subCommands = extractCommandsFromHelp('dart ${mainCommand} --help', "Available subcommands:");
         if (subCommands.length() > 0) {
            COMMANDS_CACHE[mainCommand] = subCommands;
         }
      }
      return subCommands;
   }
}
