/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import clink.api.ArgMatcher;
import clink.api.Clink;
import clink.util.Suggest;

using clink.util.Strings;

class Lua {

   public static function register() {
      Clink.argMatcher("lua").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser //
         .addFlag("-e", "") //
         .addFlag("-i")
         .addFlag("-l", "") //
         .addFlag("-v")
         .addFlag("-E")
         .addArg(Suggest.filesEndingWith(".lua"));
   }
}
