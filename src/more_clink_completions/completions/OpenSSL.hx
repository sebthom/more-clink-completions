/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import clink.util.LuaArray;
import clink.api.ArgMatcher;
import clink.api.Clink;
import more_clink_completions.util.Utils;

using clink.util.Strings;

class OpenSSL {

   public static function register() {
      if (Clink.getArgMatcher("openssl") == null)
         Clink.argMatcher("openssl").setDelayedInitializer(registerNow);
   }


   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser.addArg(suggestCommands);
   }

   static function suggestCommands():LuaArray<String> {
      final commands = new LuaArray<String>();
      for (line in Utils.exec('cmd /C "openssl help 2>&1"')) {
         for (command in line.findMatches("[a-zA-Z0-9-_]+")) {
            commands.add(command);
         }
      }
      return commands;
   }
}
