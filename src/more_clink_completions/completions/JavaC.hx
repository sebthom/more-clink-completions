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

class JavaC {

   public static function register() {
      Clink.argMatcher("javac").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser //
      // @<filename>
      // -Akey[=value]
         .addFlag("--add-modules", ["ALL-MODULE-PATH"])
            //
         .addFlags(["-bootclasspath", "--boot-class-path"], Suggest.filesEndingWith(".jar"))
         .addFlags(["-cp", "-classpath", "--class-path"], Suggest.filesEndingWith(".jar"))
            //
         .addFlag("-d", Suggest.dirs) //
         .addFlag("-deprecation")
         .addFlag("-enable-preview")
         .addFlag("encoding", "")
         .addFlag("-endorseddirs", Suggest.dirs)
         .addFlag("-extdirs", Suggest.dirs)
            //
         .addFlags([
            "-g",
            "-g:lines",
            "-g:source",
            "-g:vars",
            "-g:lines,vars",
            "-g:lines,source",
            "-g:lines,vars,source",
            "-g:none"])
            //
         .addFlag("-h", Suggest.dirs) //
         .addFlags(["-?", "-help", "--help"])
         .addFlags(["-X", "--help-extra"]) //
            //
         .addFlag("-implicit:none")
         .addFlag("-implicit:class") //
            //
            // -J<flag>
            //
         .addFlag("--limit-modules", "") //
         .addFlags(["-m", "--module"], "") //
            //
         .addFlags(["-p", "--module-path"], Suggest.dirs) //
         .addFlag("--module-source-path", Suggest.dirs) //
         .addFlag("--module-version", "") //
            //
         .addFlag("-nowarn")
         .addFlag("-parameters") //
            //
         .addFlag("-proc:none")
         .addFlag("-proc:only") //
            //
         .addFlag("-processor", "") //
         .addFlag("--processor-module-path", Suggest.dirs) //
         .addFlags(["-processorpath", "--processor-path"], Suggest.dirs) //
            //
         .addFlag("-profile", "") //
         .addFlag("--release", Suggest.range(7, 17)) //
         .addFlag("-s", Suggest.dirs) //
         .addFlags(["-source", "--source"], Suggest.range(7, 17)) //
         .addFlag("--system", ["none", Suggest.dirs]) //
         .addFlags(["-target", "--target"], Suggest.range(7, 17)) //
            //
         .addFlag("--upgrade-module-path", Suggest.dirs) //
            //
         .addFlag("-verbose")
         .addFlags(["-version", "--version"])
            //
         .addFlag("-Werror")
            //
         .addArg(Suggest.filesEndingWith(".java")) //
         .loop(1);
   }
}
