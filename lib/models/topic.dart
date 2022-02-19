import 'package:hikee/models/topic_base.dart';
import 'package:hikee/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic implements TopicBase {
  final int id;
  final User user;
  final String title;
  final String content;
  final List<String>? images;
  final bool? liked;
  final int likeCount;
  final int replyCount;
  final DateTime createdAt;
  //final List<TopicReply> replies;

  Topic({
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    this.images,
    this.liked,
    required this.likeCount,
    required this.replyCount,
    required this.createdAt,
    //required this.replies
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
