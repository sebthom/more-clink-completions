/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.util;

import lua.NativeIterator;
import lua.FileHandle;
import lua.Io;

class Utils {

   /**
    * Replacement for sys.io.Process
    * -> which requires Ereg
    *    -> which requires rex_pcre
    *       -> which is missing from clink's Lua interpreter
    */
   public static function exec(cmd:String):Array<String> {
      final p:FileHandle = Io.popen(cmd);
      final output = new Array<String>();
      if (p != null) {
         // https://github.com/HaxeFoundation/haxe/pull/10974
         final lines:NativeIterator<String> = untyped __lua__("{0}:lines()", p);
         for (line in lines) {
            output.push(line);
         }
         p.close();
      }
      return output;
   }

   public static function which(cmd:String):Null<String> {
      final lines = exec('which $cmd');
      if (lines.length == 0)
         return null;
      return lines[0];
   }
}
