// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Live _$LiveFromJson(Map<String, dynamic> json) => Live(
      id: json['id'] as int?,
      path: json['path'] as String?,
      hours: json['hours'] as int?,
      secret: json['secret'] as String?,
    );

Map<String, dynamic> _$LiveToJson(Live instance) => <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'hours': instance.hours,
      'secret': instance.secret,
    };
