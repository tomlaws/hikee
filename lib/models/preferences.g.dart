// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      language: $enumDecode(_$LanguageEnumMap, json['language']),
      mapProvider: $enumDecode(_$MapProviderEnumMap, json['mapProvider']),
      offlineMapProvider:
          $enumDecodeNullable(_$MapProviderEnumMap, json['offlineMapProvider']),
      flatSpeedInKm: json['flatSpeedInKm'] as int,
      climbSpeedInM: json['climbSpeedInM'] as int,
    );

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'language': _$LanguageEnumMap[instance.language],
      'mapProvider': _$MapProviderEnumMap[instance.mapProvider],
      'offlineMapProvider': _$MapProviderEnumMap[instance.offlineMapProvider],
      'flatSpeedInKm': instance.flatSpeedInKm,
      'climbSpeedInM': instance.climbSpeedInM,
    };

const _$LanguageEnumMap = {
  Language.DEFAULT: 'DEFAULT',
  Language.EN: 'EN',
  Language.ZH_HK: 'ZH_HK',
  Language.ZH_CN: 'ZH_CN',
};

const _$MapProviderEnumMap = {
  MapProvider.OpenStreetMap: 'OpenStreetMap',
  MapProvider.OpenStreetMapCyclOSM: 'OpenStreetMapCyclOSM',
  MapProvider.LandsDepartment: 'LandsDepartment',
};
