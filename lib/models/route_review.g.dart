// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteReview _$RouteReviewFromJson(Map<String, dynamic> json) {
  return RouteReview(
    id: json['id'] as int,
    userId: json['userId'] as int,
    routeId: json['routeId'] as int,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    content: json['content'] as String,
    rating: json['rating'] as int,
  );
}

Map<String, dynamic> _$RouteReviewToJson(RouteReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'routeId': instance.routeId,
      'user': instance.user,
      'content': instance.content,
      'rating': instance.rating,
    };
