// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicReply _$TopicReplyFromJson(Map<String, dynamic> json) {
  return TopicReply(
    id: json['id'] as int,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    content: json['content'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$TopicReplyToJson(TopicReply instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
