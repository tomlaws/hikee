// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
      id: json['id'] as int,
      userId: json['userId'] as int,
      trailId: json['trailId'] as int,
      trail: json['trail'] == null
          ? null
          : Trail.fromJson(json['trail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'trailId': instance.trailId,
      'trail': instance.trail,
    };
