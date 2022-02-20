import 'package:hikee/models/bookmark.dart';
import 'package:hikee/models/pin.dart';
import 'package:hikee/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hikee/models/region.dart';

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
  final Bookmark? bookmark;
  final List<Pin>? pins;

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
      this.pins,
      this.bookmark});

  factory Trail.fromJson(Map<String, dynamic> json) => _$TrailFromJson(json);
  Map<String, dynamic> toJson() => _$TrailToJson(this);

  // String name(WidgetRef ref) {
  //   Locale l = ref.read(localeProvider);
  //   return {
  //     Locale('en'): name_en,
  //     Locale('zh'): name_zh
  //   }[l]!;
  // }

  // String description(WidgetRef ref) {
  //   Locale l = ref.read(localeProvider);
  //   return {
  //     Locale('en'): description_en,
  //     Locale('zh'): description_zh
  //   }[l]!;
  // }
}
