/*
 * SPDX-FileCopyrightText: © Sebastian Thomschke and contributors
 * SPDX-FileContributor: Sebastian Thomschke
 * SPDX-License-Identifier: MIT
 * SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/more-clink-completions
 */
package more_clink_completions.completions;

import haxe.ds.ReadOnlyArray;
import clink.util.Suggest;
import clink.api.LineState;
import clink.util.LuaArray;
import clink.api.ArgMatcher;
import clink.api.Clink;
import more_clink_completions.util.Utils;

using clink.util.Strings;

class Docker {

   public static function register() {
      Clink.argMatcher("docker").setDelayedInitializer(registerNow);
   }

   static function registerNow(parser:ArgMatcher, commandWord:String) {
      parser
         .addFlags(["-h", "--help"])
         .addFlag("--config", Suggest.dirs)
         .addFlags(["-c", "--context"], Suggest.dirs)
         .addFlags(["-D", "--debug"])
         .addFlags(["-H", "--hosts"], "")
         .addFlags(["-l", "--log-level"], ["debug", "info", "warn", "error", "fatal"])

         .addFlag("-tls")
         .addFlag("-tlscacert", Suggest.files)
         .addFlag("-tlscert", Suggest.files)
         .addFlag("-tlskey", Suggest.files)
         .addFlag("-tlsverify")

         .addFlags(["-v", "--version"])

         .addArg(suggestMainCommands)
         .addArg(suggestSubCommands)
         .noFiles()

         .setClassifier(colorizeCommands);
   }

   static final COMMANDS_CACHE = new Map<String, LuaArray<String>>();

   static function extractCommandsFromHelp(helpCommand:String):LuaArray<String> {
      final commands = new LuaArray<String>();
      var isCommandsSection = false;
      for (line in Utils.exec(helpCommand)) {
         if (isCommandsSection) {
            if (line == "")
               isCommandsSection = false;
            else {
               final command = line.findMatch("^%s+([a-zA-Z-_]+)");
               if (command != null)
                  commands.add(command);
            }
         } else if (line.hasMatch("Commands:"))
            isCommandsSection = true;
      }
      return commands;
   }

   static function suggestMainCommands():LuaArray<String> {
      var mainCommands = COMMANDS_CACHE[""];
      if (mainCommands == null) {
         mainCommands = extractCommandsFromHelp("docker --help");
         if (mainCommands.length() > 0) {
            COMMANDS_CACHE[""] = mainCommands;
         }
      }
      return mainCommands;
   }

   static function suggestSubCommands(word:String, wordIndex:Int, lineState:LineState):LuaArray<String> {
      suggestMainCommands(); // trigger cache population

      final mainCommand = lineState.getWord(wordIndex - 1);
      if (@:nullSafety(Off) !COMMANDS_CACHE[""].contains(mainCommand)) {
         return [];
      }

      var subCommands = COMMANDS_CACHE[mainCommand];
      if (subCommands == null) {
         subCommands = extractCommandsFromHelp('docker ${mainCommand} --help');
         if (subCommands.length() > 0) {
            COMMANDS_CACHE[mainCommand] = subCommands;
         }
      }
      return subCommands;
   }

   static function colorizeCommands(argIndex:Int, word:String, wordIndex:Int, lineState:LineState, classifications:WordClassifications) {
      if (argIndex > 2) return;

      if (argIndex == 2) {
         suggestMainCommands(); // trigger cache population
         suggestSubCommands(word, wordIndex, lineState); // trigger cache population
         if (COMMANDS_CACHE[word] != null) {
            classifications.classifyWord(wordIndex, ARGUMENT);
         }
      }
   }
}


/**
 * see https://man7.org/linux/man-pages/man7/capabilities.7.html
 */
enum Capabilities {
   AUTID_CONTROL;
   AUDIT_READ;
   AUDIT_WRITE;
   BLOCL_SUSPEND;
   BPF;
   CHECKPOINT_RESTORE;
   CHOWN;
   DAC_OVERRIDE;
   DAC_READ_SEARCH;
   FOWNER;
   FSETID;
   IPC_LOCK;
   IPC_OWNER;
   KILL;
   LEASE;
   LINUX_IMMUTABLE;
   MAC_ADMIN;
   MAC_OVERRIDE;
   MKNOD;
   NET_ADMIN;
   NET_BIND_SERVICE;
   NET_BROADCAST;
   NET_RAW;
   PERFMON;
   SETGID;
   SETFCAP;
   SETPCAP;
   SETUID;
   SYS_ADMIN;
   SYS_BOOT;
   SYS_CHROOT;
   SYS_MODULE;
   SYS_NICE;
   SYS_PACCT;
   SYS_PTRACE;
   SYS_RAWIO;
   SYS_RESOURCE;
   SYS_TIME;
   SYS_TTY_CONFIG;
   SYSLOG;
   WAKE_ALARM;
}
