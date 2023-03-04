/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions;

import more_clink_completions.util.Macros;

class Main {

   static function main():Void {
      Macros.registerCommandCompletions();

      #if register_dummy_command
         clink.util.DummyCommand.registerAs("foo");
      #end
   }
}
