/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import clink.api.ArgMatcher;
import clink.api.ArgMatcher.ArgWithChoices;
import clink.api.Clink;
import clink.util.Suggest;
import more_clink_completions.util.Utils;

using clink.util.Strings;

/**
 * Build a lazy command tree from the installed Arduino CLI's English help.
 * Only validated subcommand names from help are executed; user input is never
 * passed to the shell. Each command's help is read once, when first visited.
 */
class ArduinoCli {
   public static function register() {
      Clink.argMatcher("arduino-cli").setDelayedInitializer((parser, _) -> init(parser, ""));
   }

   static function init(parser:ArgMatcher, command:String) {
      // Older CLI versions localize help using the locale configuration key.
      // Scope the environment override to the child shell (no user config writes).
      final lines = Utils.exec('set "ARDUINO_LOCALE=en" & 2>nul arduino-cli.exe $command --help');
      final commands = new Array<ArgWithChoices>();
      var section = "";
      for (line in lines) {
         if (line == "Available Commands:" || line == "Flags:" || line == "Global Flags:") {
            section = line;
            continue;
         }
         if (line == "") {
            section = "";
            continue;
         }
         if (section == "Available Commands:") {
            final name = line.findMatch("^  ([%w_-]+)%s");
            if (name != null) {
               final childName:String = name;
               final childCommand:String = command == "" ? childName : '$command $childName';
               final child = Clink.argMatcher().setDelayedInitializer((p, _) -> init(p, childCommand));
               commands.push({name: childName, choices: child});
            }
         } else if (section == "Flags:" || section == "Global Flags:") {
            final flag = line.findMatch("(%-%-[%w-]+)");
            if (flag == null)
               continue;
            final shortFlag = line.findMatch("^  (%-[%w]),");
            final flags:Array<String> = shortFlag == null ? [flag] : [shortFlag, flag];
            // A type immediately after the long flag indicates a value. Two
            // spaces separate a boolean flag (or its type) from the description.
            final valueType = line.findMatch("%-%-[%w-]+ ([%w]+)  ");
            if (valueType == null)
               parser.addFlags(flags);
            else if (flag == "--log-level")
               parser.addFlags(flags, ["trace", "debug", "info", "warn", "error", "fatal", "panic"]);
            else if (flag == "--log-format")
               parser.addFlags(flags, ["text", "json"]);
            else if (flag == "--config-file" || flag == "--input-file" || flag == "--log-file")
               parser.addFlags(flags, Suggest.files);
            else if (flag == "--config-dir" || flag == "--build-path" || flag == "--output-dir"
                  || flag == "--build-cache-path" || flag == "--libraries" || flag == "--library")
               parser.addFlags(flags, Suggest.dirs);
            else
               parser.addFlags(flags, "");
         }
      }
      if (commands.length > 0)
         parser.addArg(commands).noFiles();
      // Leaf commands retain filename completion for sketches and archives.
   }
}
