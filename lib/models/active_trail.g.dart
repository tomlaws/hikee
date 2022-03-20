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
    ..name = json['name'] as String?
    ..userPath = (json['userPath'] as List<dynamic>)
        .map((e) => LatLng.fromJson(e as Map<String, dynamic>))
        .toList()
    ..userHeights = (json['userHeights'] as List<dynamic>)
        .map((e) => HKDatum.fromJson(e as Map<String, dynamic>))
        .toList()
    ..markers = (json['markers'] as List<dynamic>)
        .map((e) => MapMarker.fromJson(e as Map<String, dynamic>))
        .toList()
    ..regionId = json['regionId'] as int?;
}

Map<String, dynamic> _$ActiveTrailToJson(ActiveTrail instance) =>
    <String, dynamic>{
      'trail': instance.trail,
      'name': instance.name,
      'userPath': instance.userPath,
      'userHeights': instance.userHeights,
      'markers': instance.markers,
      'startTime': instance.startTime,
      'regionId': instance.regionId,
    };
