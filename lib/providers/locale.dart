import 'package:flutter/cupertino.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('zh');
  Locale get locale => _locale;
  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}