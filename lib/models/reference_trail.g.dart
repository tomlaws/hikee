// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceTrail _$ReferenceTrailFromJson(Map<String, dynamic> json) {
  return ReferenceTrail(
    id: json['id'] as int,
    regionId: json['regionId'] as int,
    name_en: json['name_en'] as String,
    name_zh: json['name_zh'] as String,
    length: json['length'] as int,
    duration: json['duration'] as int,
    path: (json['path'] as List<dynamic>?)
        ?.map((e) => LatLng.fromJson(e as Map<String, dynamic>))
        .toList(),
    elevations: (json['elevations'] as List<dynamic>)
        .map((e) => Elevation.fromJson(e as Map<String, dynamic>))
        .toList(),
    pins: (json['pins'] as List<dynamic>?)
        ?.map((e) => Pin.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ReferenceTrailToJson(ReferenceTrail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'regionId': instance.regionId,
      'name_zh': instance.name_zh,
      'name_en': instance.name_en,
      'length': instance.length,
      'duration': instance.duration,
      'pins': instance.pins,
      'path': instance.path,
      'elevations': instance.elevations,
    };
