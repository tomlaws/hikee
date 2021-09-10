import 'package:hikee/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_participation.g.dart';

@JsonSerializable()
class EventParticipation {
  final int eventId;
  final int participantId;
  final User participant;

  EventParticipation(
      {required this.eventId,
      required this.participantId,
      required this.participant});

  factory EventParticipation.fromJson(Map<String, dynamic> json) =>
      _$EventParticipationFromJson(json);
  Map<String, dynamic> toJson() => _$EventParticipationToJson(this);
}
