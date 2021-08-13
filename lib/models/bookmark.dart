import 'package:hikee/models/route.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class Bookmark {
  int id;
  int userId;
  int routeId;
  HikingRoute? route;
  Bookmark(
      {required this.id,
      required this.userId,
      required this.routeId,
      this.route});
  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
