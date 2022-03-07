import 'package:hikees/models/topic.dart';
import 'package:hikees/models/topic_base.dart';
import 'package:hikees/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_reply.g.dart';

@JsonSerializable()
class TopicReply implements TopicBase {
  final int id;
  final User user;
  final String content;
  final List<String>? images;
  final DateTime createdAt;

  TopicReply(
      {required this.id,
      required this.user,
      required this.content,
      this.images,
      required this.createdAt});

  factory TopicReply.fromJson(Map<String, dynamic> json) =>
      _$TopicReplyFromJson(json);
  Map<String, dynamic> toJson() => _$TopicReplyToJson(this);
}
