// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) {
  return Bookmark(
    id: json['id'] as int,
    userId: json['userId'] as int,
    routeId: json['routeId'] as int,
    route: json['route'] == null
        ? null
        : HikingRoute.fromJson(json['route'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'routeId': instance.routeId,
      'route': instance.route,
    };
