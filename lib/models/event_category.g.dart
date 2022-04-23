// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventCategory _$EventCategoryFromJson(Map<String, dynamic> json) =>
    EventCategory(
      id: json['id'] as int,
      name_zh: json['name_zh'] as String,
      name_en: json['name_en'] as String,
    );

Map<String, dynamic> _$EventCategoryToJson(EventCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_zh': instance.name_zh,
      'name_en': instance.name_en,
    };
