import 'package:hikee/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trail_review.g.dart';

@JsonSerializable()
class TrailReview {
  int id;
  int reviewerId;
  int trailId;
  User reviewer;
  String content;
  int rating;
  DateTime createdAt;

  TrailReview(
      {required this.id,
      required this.reviewerId,
      required this.trailId,
      required this.reviewer,
      required this.content,
      required this.rating,
      required this.createdAt});

  factory TrailReview.fromJson(Map<String, dynamic> json) =>
      _$TrailReviewFromJson(json);
  Map<String, dynamic> toJson() => _$TrailReviewToJson(this);
}
