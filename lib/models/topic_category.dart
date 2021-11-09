import 'package:json_annotation/json_annotation.dart';

part 'topic_category.g.dart';

@JsonSerializable()
class TopicCategory {
  final int? id;
  final String name_zh;
  final String name_en;

  TopicCategory(
      {required this.id, required this.name_zh, required this.name_en});

  factory TopicCategory.fromJson(Map<String, dynamic> json) =>
      _$TopicCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$TopicCategoryToJson(this);
}
