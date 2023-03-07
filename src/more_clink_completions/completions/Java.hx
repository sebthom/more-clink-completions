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

class Java {

   public static function register() {
      Clink.argMatcher("java").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser //
         .addFlags(["-cp", "-classpath", "--class-path"], Suggest.filesEndingWith(".jar"))
         .addFlags(["-p", "--module-path", "--upgrade-module-path"], Suggest.dirs) //
            //
         .addFlag("--add-modules", ["ALL-DEFAULT", "ALL-SYSTEM", "ALL-MODULE-PATH"])
         .addFlag("--enable-native-access", "") //
         .addFlag("--list-modules")
         .addFlags(["-d", "--describe-module", "--upgrade-module-path"], "") //
            //
         .addFlag("--dry-run")
         .addFlag("--validate-modules") //
            //
            // -D<name>=<value>
            //
         .addFlags(["-verbose:class", "-verbose:module", "-verbose:gc", "-verbose:jni"])
            //
         .addFlags(["-version", "--version", "-showversion", "--show-version"])
         .addFlag("--show-module-resolution")
         .addFlags(["-?", "-h", "-help", "--help"])
         .addFlags(["-X", "--help-extra"]) //
            //
            // -ea[:<packagename>...|:<classname>]
            // -enableassertions[:<packagename>...|:<classname>]
            // -da[:<packagename>...|:<classname>]
            // -disableassertions[:<packagename>...|:<classname>]
            //
         .addFlags(["-esa", "-enablesystemassertions"])
         .addFlags(["-dsa", "-disablesystemassertions"]) //
            //
            // -agentlib:<libname>[=<options>]
            // -agentpath:<pathname>[=<options>]
            // -javaagent:<jarpath>[=<options>]
            // -splash:<imagepath>
            // @argument files
            // -disable-@files
            //
         .addFlag("--enable-preview")
            //
         .addFlag("-jar", Suggest.filesEndingWith(".jar"))
         .addFlags(["-m", "--module"], "");
   }
}
