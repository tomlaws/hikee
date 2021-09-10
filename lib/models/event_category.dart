import 'package:json_annotation/json_annotation.dart';

part 'event_category.g.dart';

@JsonSerializable()
class EventCategory {
  final int id;
  final String name_zh;
  final String name_en;

  EventCategory(
      {required this.id, required this.name_zh, required this.name_en});

  factory EventCategory.fromJson(Map<String, dynamic> json) =>
      _$EventCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$EventCategoryToJson(this);
}
