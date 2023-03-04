/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.util;

import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;

class Macros {

   macro static public function registerCommandCompletions() {
      var commandRegistrations = new Array<Expr>();
      for (haxeFile in FileSystem.readDirectory("src/more_clink_completions/completions")) {
         final className = 'more_clink_completions.completions.${haxeFile.split(".")[0]}';
         trace('Registering command completions [$className]...');
         commandRegistrations.push(Context.parse('${className}.register()', Context.currentPos()));
      }
      return macro $b{commandRegistrations};
   }
}
