import 'package:hikee/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_review.g.dart';

@JsonSerializable()
class RouteReview {
  int id;
  int reviewerId;
  int routeId;
  User reviewer;
  String content;
  int rating;

  RouteReview(
      {required this.id,
      required this.reviewerId,
      required this.routeId,
      required this.reviewer,
      required this.content,
      required this.rating});

  factory RouteReview.fromJson(Map<String, dynamic> json) =>
      _$RouteReviewFromJson(json);
  Map<String, dynamic> toJson() => _$RouteReviewToJson(this);
}
