// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      title: json['title'] as String,
      content: json['content'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      liked: json['liked'] as bool?,
      likeCount: json['likeCount'] as int,
      replyCount: json['replyCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'title': instance.title,
      'content': instance.content,
      'images': instance.images,
      'liked': instance.liked,
      'likeCount': instance.likeCount,
      'replyCount': instance.replyCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
