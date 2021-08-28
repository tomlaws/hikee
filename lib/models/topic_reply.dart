import 'package:hikee/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_reply.g.dart';

@JsonSerializable()
class TopicReply {
  final int id;
  final User user;
  final String content;
  final DateTime createdAt;
  
  TopicReply({required this.id, required this.user, required this.content, required this.createdAt});
  
  factory TopicReply.fromJson(Map<String, dynamic> json) => _$TopicReplyFromJson(json);
  Map<String, dynamic> toJson() => _$TopicReplyToJson(this);
}
