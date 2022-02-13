// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveTrail _$ActiveTrailFromJson(Map<String, dynamic> json) {
  return ActiveTrail(
    trail: json['trail'] == null
        ? null
        : ReferenceTrail.fromJson(json['trail'] as Map<String, dynamic>),
    startTime: json['startTime'] as int?,
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
      'userPath': instance.userPath,
      'userElevation': instance.userElevation,
      'startTime': instance.startTime,
    };
