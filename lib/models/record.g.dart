// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
      id: json['id'] as int,
      time: json['time'] as int,
      region: json['region'] == null
          ? null
          : Region.fromJson(json['region'] as Map<String, dynamic>),
      name: json['name'] as String,
      referenceTrail: json['referenceTrail'] == null
          ? null
          : Trail.fromJson(json['referenceTrail'] as Map<String, dynamic>),
      userPath: json['userPath'] as String,
      date: DateTime.parse(json['date'] as String),
      markers: (json['markers'] as List<dynamic>?)
          ?.map((e) => MapMarker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'name': instance.name,
      'region': instance.region,
      'referenceTrail': instance.referenceTrail,
      'userPath': instance.userPath,
      'markers': instance.markers,
    };
