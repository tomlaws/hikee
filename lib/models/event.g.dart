// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    route: HikingRoute.fromJson(json['route'] as Map<String, dynamic>),
    date: DateTime.parse(json['date'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'route': instance.route,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
