import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Preferences {
  Language language;
  MapProvider mapProvider;

  Preferences({required this.language, required this.mapProvider});

  Locale get locale {
    switch (language) {
      case Language.DEFAULT:
        return Get.deviceLocale ?? Locale('en', 'US');
      case Language.EN:
        return Locale('en', 'US');
      case Language.ZH:
        return Locale('zh');
      case Language.ZH_CN:
        return Locale('zh', 'CN');
    }
  }

  static Preferences defaultPreferences() {
    return Preferences(
        language: Language.DEFAULT, mapProvider: MapProvider.OpenStreetMap);
  }

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}

enum MapProvider { OpenStreetMap, OpenStreetMapCyclOSM, LandsDepartment }
enum Language { DEFAULT, EN, ZH, ZH_CN }

extension MapProviderExtension on MapProvider {
  String get readableString {
    switch (this) {
      case MapProvider.OpenStreetMap:
        return 'OpenStreetMap';
      case MapProvider.OpenStreetMapCyclOSM:
        return 'OpenStreetMap CyclOSM';
      case MapProvider.LandsDepartment:
        return 'HKGOV - Lands Department';
    }
  }
}

extension LanguageExtension on Language {
  String get readableString {
    switch (this) {
      case Language.EN:
        return 'English';
      case Language.ZH:
        return '繁體中文';
      case Language.ZH_CN:
        return '简体中文';
      case Language.DEFAULT:
        return 'Default';
    }
  }
}
