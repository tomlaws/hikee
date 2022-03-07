import 'package:hikees/models/event_category.dart';
import 'package:hikees/models/trail.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final int id;
  final String name;
  final List<EventCategory> categories;
  final String description;
  final Trail trail;
  int participantCount;
  bool? joined;
  final DateTime date;
  final DateTime createdAt;

  Event(
      {required this.id,
      required this.name,
      required this.categories,
      required this.description,
      required this.trail,
      required this.participantCount,
      this.joined,
      required this.date,
      required this.createdAt});

  bool get isExpired {
    return DateTime.now().compareTo(date) > 0;
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
