// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventParticipation _$EventParticipationFromJson(Map<String, dynamic> json) =>
    EventParticipation(
      eventId: json['eventId'] as int,
      participantId: json['participantId'] as int,
      participant: User.fromJson(json['participant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventParticipationToJson(EventParticipation instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'participantId': instance.participantId,
      'participant': instance.participant,
    };
