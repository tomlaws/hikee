import 'package:json_annotation/json_annotation.dart';
import 'package:hikee/models/region.dart';

part 'route.g.dart';

@JsonSerializable()
class HikingRoute {
  final int id;
  final String name_zh;
  final String name_en;
  final int regionId;
  final Region region;
  final String description_zh;
  final String description_en;
  final String image;
  final List<String> images;
  final int difficulty;
  final int rating;
  final int duration; // minutes
  final int length;
  final String path;

  HikingRoute(
      this.id,
      this.name_zh,
      this.name_en,
      this.regionId,
      this.region,
      this.description_zh,
      this.description_en,
      this.image,
      this.images,
      this.difficulty,
      this.rating,
      this.duration,
      this.length,
      this.path);

  factory HikingRoute.fromJson(Map<String, dynamic> json) =>
      _$HikingRouteFromJson(json);
  Map<String, dynamic> toJson() => _$HikingRouteToJson(this);
}
