// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as int,
      name: json['name'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => EventCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String,
      trail: Trail.fromJson(json['trail'] as Map<String, dynamic>),
      participantCount: json['participantCount'] as int,
      joined: json['joined'] as bool?,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categories': instance.categories,
      'description': instance.description,
      'trail': instance.trail,
      'participantCount': instance.participantCount,
      'joined': instance.joined,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
