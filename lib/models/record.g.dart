// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) {
  return Record(
    id: json['id'] as int,
    time: json['time'] as int,
    date: DateTime.parse(json['date'] as String),
    route: HikingRoute.fromJson(json['route'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'date': instance.date.toIso8601String(),
      'route': instance.route,
    };
