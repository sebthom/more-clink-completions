/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import clink.api.ArgMatcher;
import clink.api.Clink;
import clink.util.LuaArray;
import clink.util.Suggest;
import more_clink_completions.util.Utils;

using clink.util.Strings;

class Haxe {

   public static function register() {
      Clink.argMatcher("haxe").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser //
      //------------------------
      // Target:
      //------------------------
         .addFlag("--js", Suggest.filesEndingWith(".js"))
         .addFlag("--lua", Suggest.filesEndingWith(".lua"))
         .addFlag("--swf", Suggest.filesEndingWith(".swf"))
         .addFlag("--neko", Suggest.filesEndingWith(".n"))
         .addFlag("--php", Suggest.dirs)
         .addFlag("--cpp", Suggest.dirs)
         .addFlag("--cppia", Suggest.filesEndingWith(".cppia"))
         .addFlag("--cs", Suggest.dirs)
         .addFlag("--java", Suggest.dirs)
         .addFlag("--jvm", Suggest.filesEndingWith(".class"))
         .addFlag("--python", Suggest.filesEndingWith(".py"))
         .addFlag("--hl", Suggest.filesEndingWith(".hl"))
         .addFlag("--interp")
         .addFlag("--run", Suggest.nothing) //
            //------------------------
            // Compilation:
            //------------------------
         .addFlags(["-p", "--classpath"], Suggest.dirs) //
         .addFlags(["-m", "--main"], Suggest.nothing) //
         .addFlags(["-L", "--library"], Suggest.nothing) //
         .addFlags(["-D", "--define"], suggestDefines) //
         .addFlags(["-R", "--resources"], Suggest.files) //
         .addFlag("--cmd", Suggest.nothing) //
         .addFlag("--remap", Suggest.nothing) //
         .addFlag("--macro", Suggest.nothing) //
         .addFlags(["-C", "--cwd"], Suggest.dirs) //
         .addFlag("--haxelib-global") //
            //------------------------
            // Optimization:
            //------------------------
         .addFlag("-dce", ["std", "full", "no"])
         .addFlag("--no-traces")
         .addFlag("--no-output")
         .addFlag("--no-inline")
         .addFlag("--no-opt") //
            //------------------------
            // Debug:
            //------------------------
         .addFlags(["-v", "--verbose"])
         .addFlag("--debug")
         .addFlag("--prompt")
         .addFlag("--times") //
            //------------------------
            // Batch:
            //------------------------
         .addFlag("--next")
         .addFlag("--each") //
            //------------------------
            // Services:
            //------------------------
         .addFlag("--display")
         .addFlag("--xml", Suggest.filesEndingWith(".xml")) //
         .addFlag("--json", Suggest.filesEndingWith(".json")) //
            //------------------------
            // Compilation Server:
            //------------------------
         .addFlag("--server-listen", Suggest.nothing) //
         .addFlag("--server-connect", Suggest.nothing) //
         .addFlag("--connect", Suggest.nothing) //
            //------------------------
            // Target-specific:
            //------------------------
         .addFlag("--swf-version", Suggest.nothing) //
         .addFlag("--swf-header", Suggest.nothing) //
         .addFlag("--flash-strict") //
         .addFlag("--swf-lib", Suggest.filesEndingWith(".swf"))
         .addFlag("--swf-lib-extern", Suggest.filesEndingWith(".swf"))
         .addFlag("--jar-lib", Suggest.filesEndingWith(".jar"))
         .addFlag("--jar-lib-extern", Suggest.filesEndingWith(".jar"))
         .addFlag("--net-lib", Suggest.filesEndingWith(".dll"))
         .addFlag("--net-std", Suggest.filesEndingWith(".dll"))
         .addFlag("--c-arg", Suggest.nothing) //
            //------------------------
            // Miscellaneous:
            //------------------------
         .addFlag("--version")
         .addFlags(["-h", "--help"])
         .addFlag("--help-defines")
         .addFlag("--help-metas")
            //
         .addArg([Suggest.filesEndingWith(".hxml")])
         .noFiles();
   }

   static function suggestDefines():LuaArray<String> {
      final result = new LuaArray<String>();
      for (line in Utils.exec("haxe --help-defines")) {
         final define = line.findMatch("%s([a-zA-Z-_]+)%s+:");
         if (define != null) {
            result.add(define);
         }
      }
      return result;
   }
}
