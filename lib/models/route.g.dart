// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HikingRoute _$HikingRouteFromJson(Map<String, dynamic> json) {
  return HikingRoute(
    json['id'] as int,
    json['name_zh'] as String,
    json['name_en'] as String,
    json['regionId'] as int,
    Region.fromJson(json['region'] as Map<String, dynamic>),
    json['description_zh'] as String,
    json['description_en'] as String,
    json['image'] as String,
    (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    json['difficulty'] as int,
    json['rating'] as int,
    json['duration'] as int,
    json['length'] as int,
    json['path'] as String,
  );
}

Map<String, dynamic> _$HikingRouteToJson(HikingRoute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_zh': instance.name_zh,
      'name_en': instance.name_en,
      'regionId': instance.regionId,
      'region': instance.region,
      'description_zh': instance.description_zh,
      'description_en': instance.description_en,
      'image': instance.image,
      'images': instance.images,
      'difficulty': instance.difficulty,
      'rating': instance.rating,
      'duration': instance.duration,
      'length': instance.length,
      'path': instance.path,
    };
