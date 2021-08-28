import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Localization {
  static String translate(BuildContext context, String Function(AppLocalizations l) selector) {
    return selector(AppLocalizations.of(context)!);
  }
}