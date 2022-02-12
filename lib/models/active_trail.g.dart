// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveTrail _$ActiveTrailFromJson(Map<String, dynamic> json) {
  return ActiveTrail(
    trail: Trail.fromJson(json['trail'] as Map<String, dynamic>),
    decodedPath: (json['decodedPath'] as List<dynamic>)
        .map((e) => LatLng.fromJson(e as Map<String, dynamic>))
        .toList(),
    startTime: json['startTime'] as int?,
    elevations: (json['elevations'] as List<dynamic>?)
        ?.map((e) => Elevation.fromJson(e as Map<String, dynamic>))
        .toList(),
  )
    ..userPath = (json['userPath'] as List<dynamic>)
        .map((e) => LatLng.fromJson(e as Map<String, dynamic>))
        .toList()
    ..userElevation = (json['userElevation'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList();
}

Map<String, dynamic> _$ActiveTrailToJson(ActiveTrail instance) =>
    <String, dynamic>{
      'trail': instance.trail,
      'decodedPath': instance.decodedPath,
      'userPath': instance.userPath,
      'userElevation': instance.userElevation,
      'startTime': instance.startTime,
      'elevations': instance.elevations,
    };
