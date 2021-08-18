// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteReview _$RouteReviewFromJson(Map<String, dynamic> json) {
  return RouteReview(
    id: json['id'] as int,
    reviewerId: json['reviewerId'] as int,
    routeId: json['routeId'] as int,
    reviewer: User.fromJson(json['reviewer'] as Map<String, dynamic>),
    content: json['content'] as String,
    rating: json['rating'] as int,
  );
}

Map<String, dynamic> _$RouteReviewToJson(RouteReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewerId': instance.reviewerId,
      'routeId': instance.routeId,
      'reviewer': instance.reviewer,
      'content': instance.content,
      'rating': instance.rating,
    };
