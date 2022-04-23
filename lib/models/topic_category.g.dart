// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicCategory _$TopicCategoryFromJson(Map<String, dynamic> json) =>
    TopicCategory(
      id: json['id'] as int?,
      name_zh: json['name_zh'] as String,
      name_en: json['name_en'] as String,
    );

Map<String, dynamic> _$TopicCategoryToJson(TopicCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_zh': instance.name_zh,
      'name_en': instance.name_en,
    };
