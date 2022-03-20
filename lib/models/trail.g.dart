// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trail _$TrailFromJson(Map<String, dynamic> json) {
  return Trail(
    id: json['id'] as int,
    creator: json['creator'] == null
        ? null
        : User.fromJson(json['creator'] as Map<String, dynamic>),
    name_zh: json['name_zh'] as String,
    name_en: json['name_en'] as String,
    regionId: json['regionId'] as int,
    region: Region.fromJson(json['region'] as Map<String, dynamic>),
    description_zh: json['description_zh'] as String,
    description_en: json['description_en'] as String,
    image: json['image'] as String,
    images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    difficulty: json['difficulty'] as int,
    rating: json['rating'] as int,
    duration: json['duration'] as int,
    length: json['length'] as int,
    path: json['path'] as String,
    pins: (json['pins'] as List<dynamic>?)
        ?.map((e) => Pin.fromJson(e as Map<String, dynamic>))
        .toList(),
    bookmark: json['bookmark'] == null
        ? null
        : Bookmark.fromJson(json['bookmark'] as Map<String, dynamic>),
    offline: json['offline'] as bool?,
  );
}

Map<String, dynamic> _$TrailToJson(Trail instance) => <String, dynamic>{
      'id': instance.id,
      'creator': instance.creator,
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
      'bookmark': instance.bookmark,
      'pins': instance.pins,
      'offline': instance.offline,
    };
