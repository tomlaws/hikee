// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) {
  return Record(
    id: json['id'] as int,
    time: json['time'] as int,
    name: json['name'] as String,
    date: DateTime.parse(json['date'] as String),
    userPath: json['userPath'] as String,
    altitudes: (json['altitudes'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList(),
  );
}

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'userPath': instance.userPath,
      'altitudes': instance.altitudes,
    };
