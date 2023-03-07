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
import more_clink_completions.util.Utils;

using clink.util.Strings;

/**
 * Clink command line completions for "curl" command (C:\Windows\system32\curl.exe).
 */
class Curl {

   public static function register() {
      if (Clink.getArgMatcher("curl") == null)
         Clink.argMatcher("curl").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      for (line in Utils.exec("curl --help all")) {
         final optionShort = line.findMatch("%s([-][%a%d]),?%s.*");
         final optionLong = line.findMatch("%s([-][-][%a%d][%a-%d]+)%s.*");
         final optionArg = line.findMatch("%s(%b<>)%s");
         switch (optionArg) {
            case "<file>", "<filename>", "<file name>", "<path>":
               if (optionShort != null) parser.addFlag(optionShort, Suggest.files);
               if (optionLong != null) parser.addFlag(optionLong, Suggest.files);
            case "<dir>":
               if (optionShort != null) parser.addFlag(optionShort, Suggest.dirs);
               if (optionLong != null) parser.addFlag(optionLong, Suggest.dirs);
            case null: // flag
               if (optionShort != null) parser.addFlag(optionShort);
               if (optionLong != null) parser.addFlag(optionLong);
            default: // option with unknown argument type
               if (optionShort != null) parser.addFlag(optionShort, "");
               if (optionLong != null) parser.addFlag(optionLong, "");
         }
      }
      parser.noFiles();
   }
}
