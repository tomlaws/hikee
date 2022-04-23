// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrailReview _$TrailReviewFromJson(Map<String, dynamic> json) => TrailReview(
      id: json['id'] as int,
      reviewerId: json['reviewerId'] as int,
      trailId: json['trailId'] as int,
      reviewer: User.fromJson(json['reviewer'] as Map<String, dynamic>),
      content: json['content'] as String,
      rating: json['rating'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TrailReviewToJson(TrailReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewerId': instance.reviewerId,
      'trailId': instance.trailId,
      'reviewer': instance.reviewer,
      'content': instance.content,
      'rating': instance.rating,
      'createdAt': instance.createdAt.toIso8601String(),
    };
