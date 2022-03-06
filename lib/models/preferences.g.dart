// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) {
  return Preferences(
    language: _$enumDecode(_$LanguageEnumMap, json['language']),
    mapProvider: _$enumDecode(_$MapProviderEnumMap, json['mapProvider']),
  );
}

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'language': _$LanguageEnumMap[instance.language],
      'mapProvider': _$MapProviderEnumMap[instance.mapProvider],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

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
