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
    name: json['name'] as String?,
    regionId: json['regionId'] as int?,
    startTime: json['startTime'] as int?,
  )
    ..userPath = (json['userPath'] as List<dynamic>)
        .map((e) => LatLng.fromJson(e as Map<String, dynamic>))
        .toList()
    ..userHeights = (json['userHeights'] as List<dynamic>)
        .map((e) => HeightData.fromJson(e as Map<String, dynamic>))
        .toList()
    ..markers = (json['markers'] as List<dynamic>)
        .map((e) => MapMarker.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ActiveTrailToJson(ActiveTrail instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userPath': instance.userPath,
      'userHeights': instance.userHeights,
      'markers': instance.markers,
      'startTime': instance.startTime,
      'regionId': instance.regionId,
      'trail': instance.trail,
    };
