// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveTrail _$ActiveTrailFromJson(Map<String, dynamic> json) => ActiveTrail(
      name: json['name'] as String?,
      regionId: json['regionId'] as int?,
      startTime: json['startTime'] as int?,
      userPath: (json['userPath'] as List<dynamic>?)
          ?.map((e) => LatLng.fromJson(e as Map<String, dynamic>))
          .toList(),
      referenceTrailId: json['referenceTrailId'] as int?,
      originalPath: (json['originalPath'] as List<dynamic>?)
          ?.map((e) => LatLng.fromJson(e as Map<String, dynamic>))
          .toList(),
      offline: json['offline'] as bool? ?? false,
    )
      ..userHeights = (json['userHeights'] as List<dynamic>)
          .map((e) => HeightData.fromJson(e as Map<String, dynamic>))
          .toList()
      ..markers = (json['markers'] as List<dynamic>)
          .map((e) => MapMarker.fromJson(e as Map<String, dynamic>))
          .toList()
      ..originalLength = json['originalLength'] as int?
      ..originalDuration = json['originalDuration'] as int?
      ..originalHeights = (json['originalHeights'] as List<dynamic>?)
          ?.map((e) => HeightData.fromJson(e as Map<String, dynamic>))
          .toList()
      ..live = json['live'] == null
          ? null
          : Live.fromJson(json['live'] as Map<String, dynamic>);

Map<String, dynamic> _$ActiveTrailToJson(ActiveTrail instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userPath': instance.userPath,
      'userHeights': instance.userHeights,
      'markers': instance.markers,
      'startTime': instance.startTime,
      'regionId': instance.regionId,
      'referenceTrailId': instance.referenceTrailId,
      'originalLength': instance.originalLength,
      'originalDuration': instance.originalDuration,
      'originalPath': instance.originalPath,
      'originalHeights': instance.originalHeights,
      'live': instance.live,
      'offline': instance.offline,
    };
