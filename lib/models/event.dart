import 'package:hikee/models/route.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final int id;
  final String name;
  final String description;
  final HikingRoute route;
  final DateTime date;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.route,
    required this.date,
    required this.createdAt
  });

  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
