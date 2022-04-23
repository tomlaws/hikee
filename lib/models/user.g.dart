// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      email: json['email'] as String?,
      isPrivate: json['isPrivate'] as bool,
      nickname: json['nickname'] as String?,
      icon: json['icon'] as String?,
      minutes: json['minutes'] as int?,
      trailCount: json['trailCount'] as int?,
      meters: json['meters'] as int?,
      eventCount: json['eventCount'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'isPrivate': instance.isPrivate,
      'icon': instance.icon,
      'minutes': instance.minutes,
      'trailCount': instance.trailCount,
      'meters': instance.meters,
      'eventCount': instance.eventCount,
      'nickname': instance.nickname,
    };
