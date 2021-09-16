import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localeProvider = StateNotifierProvider<HikeeLocale, Locale>((ref) {
  return HikeeLocale();
});

class HikeeLocale extends StateNotifier<Locale> {
  HikeeLocale() : super(Locale('zh'));

  set locale(Locale locale) {
    state = locale;
  }
  
  Locale get locale => state;
}
