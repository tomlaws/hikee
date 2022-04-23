import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Preferences {
  Language language;
  MapProvider mapProvider;
  MapProvider? offlineMapProvider;
  int flatSpeedInKm;
  int climbSpeedInM;

  Preferences(
      {required this.language,
      required this.mapProvider,
      this.offlineMapProvider,
      required this.flatSpeedInKm,
      required this.climbSpeedInM});

  Locale get locale {
    switch (language) {
      case Language.DEFAULT:
        return Get.deviceLocale ?? Locale('en', 'US');
      case Language.EN:
        return Locale('en', 'US');
      case Language.ZH_HK:
        return Locale('zh', 'HK');
      case Language.ZH_CN:
        return Locale('zh', 'CN');
    }
  }

  static Preferences defaultPreferences() {
    return Preferences(
        language: Language.DEFAULT,
        mapProvider: MapProvider.LandsDepartment,
        offlineMapProvider: null,
        flatSpeedInKm: 5,
        climbSpeedInM: 600);
  }

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}

enum MapProvider { OpenStreetMap, OpenStreetMapCyclOSM, LandsDepartment }
enum Language { DEFAULT, EN, ZH_HK, ZH_CN }

extension MapProviderExtension on MapProvider {
  String get readableString {
    switch (this) {
      case MapProvider.OpenStreetMap:
        return 'OpenStreetMap';
      case MapProvider.OpenStreetMapCyclOSM:
        return 'OpenStreetMap CyclOSM';
      case MapProvider.LandsDepartment:
        return 'Lands Department @ HKGOV';
    }
  }

  String get resIdentifier {
    return this.toString().split('.').last;
  }
}

extension LanguageExtension on Language {
  String get readableString {
    switch (this) {
      case Language.EN:
        return 'English';
      case Language.ZH_HK:
        return '繁體中文';
      case Language.ZH_CN:
        return '简体中文';
      case Language.DEFAULT:
        return 'Default';
    }
  }
}
