/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions;

import clink.api.Clink;
import more_clink_completions.util.Macros;

class Main {

   static function main():Void {
      final clinkVersion = Clink.versionMajor * 1000000 + Clink.versionMinor * 1000 + Clink.versionPatch;
      if (clinkVersion < 1004024 /*1.004.024*/) {
         Sys.println("WARNING: Clink version too old! more-clinks-completions requires clink 1.4.24 or higher.");
         return;
      }

      Macros.registerCommandCompletions();

      #if register_dummy_command
         clink.util.DummyCommand.registerAs("foo");
      #end
   }
}
