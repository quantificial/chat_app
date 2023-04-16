import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// wrapper class for easier access the language string
// edit app_en.arb and app_zh.arb for the language
// and call flutter gen-l10n

// or add auto gen for vs code setting
// "emeraldwalk.runonsave": {
//     "commands": [
//       {
//         "match": "\\.arb$",
//         "cmd": "flutter gen-l10n"
//       }
//     ]
//   },

class S {
  static AppLocalizations? of(BuildContext context) =>
      AppLocalizations.of(context);
}
