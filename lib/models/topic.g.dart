// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return Topic(
    id: json['id'] as int,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    title: json['title'] as String,
    content: json['content'] as String,
    likeCount: json['likeCount'] as int,
    replyCount: json['replyCount'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'title': instance.title,
      'content': instance.content,
      'likeCount': instance.likeCount,
      'replyCount': instance.replyCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
