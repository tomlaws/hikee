import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(Locale('zh'));

  set locale(Locale locale) {
    state = locale;
  }
  
  Locale get locale => state;
}
