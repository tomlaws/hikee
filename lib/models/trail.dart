import 'package:get/get.dart';
import 'package:hikees/models/bookmark.dart';
import 'package:hikees/models/map_marker.dart';
import 'package:hikees/models/pin.dart';
import 'package:hikees/models/user.dart';
import 'package:hikees/utils/lang.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hikees/models/region.dart';

part 'trail.g.dart';

@JsonSerializable()
class Trail {
  final int id;
  final User? creator;
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
  final int length; //meters
  final String path;
  Bookmark? bookmark;
  final List<MapMarker>? markers;
  bool? offline;

  Trail(
      {required this.id,
      this.creator,
      required this.name_zh,
      required this.name_en,
      required this.regionId,
      required this.region,
      required this.description_zh,
      required this.description_en,
      required this.image,
      required this.images,
      required this.difficulty,
      required this.rating,
      required this.duration,
      required this.length,
      required this.path,
      this.markers,
      this.bookmark,
      this.offline = false});

  factory Trail.fromJson(Map<String, dynamic> json) => _$TrailFromJson(json);
  Map<String, dynamic> toJson() => _$TrailToJson(this);

  get name {
    if (Get.locale?.languageCode.toLowerCase() == 'zh') {
      if (Get.locale?.countryCode == 'CN') {
        return LangUtils.tcToSc(name_zh);
      }
      return name_zh;
    }
    return name_en;
  }

  get description {
    if (Get.locale?.languageCode.toLowerCase() == 'zh') {
      if (Get.locale?.countryCode == 'CN') {
        return LangUtils.tcToSc(description_zh);
      }
      return description_zh;
    }
    return description_en;
  }
}
