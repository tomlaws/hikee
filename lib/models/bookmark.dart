import 'package:hikees/models/trail.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class Bookmark {
  int id;
  int userId;
  int trailId;
  Trail? trail;
  Bookmark(
      {required this.id,
      required this.userId,
      required this.trailId,
      this.trail});
  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
