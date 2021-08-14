import 'package:hikee/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_review.g.dart';

@JsonSerializable()
class RouteReview {
  int id;
  int userId;
  int routeId;
  User user;
  String content;
  int rating;

  RouteReview(
      {required this.id,
      required this.userId,
      required this.routeId,
      required this.user,
      required this.content,
      required this.rating});

  factory RouteReview.fromJson(Map<String, dynamic> json) =>
      _$RouteReviewFromJson(json);
  Map<String, dynamic> toJson() => _$RouteReviewToJson(this);
}
