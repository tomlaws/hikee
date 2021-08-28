import 'package:flutter/material.dart';
import 'package:hikee/models/bookmark.dart';
import 'package:hikee/providers/locale.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hikee/models/region.dart';
import 'package:provider/provider.dart';

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
  final Bookmark? bookmark;

  HikingRoute(
      {required this.id,
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
      this.bookmark});

  factory HikingRoute.fromJson(Map<String, dynamic> json) =>
      _$HikingRouteFromJson(json);
  Map<String, dynamic> toJson() => _$HikingRouteToJson(this);

  String name(BuildContext context) {
    var l = context.read<LocaleProvider>().locale;
    if (l.countryCode == 'en') {
      return name_en;
    } else {
      return name_zh;
    }
  }

  String description(BuildContext context) {
    var l = context.read<LocaleProvider>().locale;
    if (l.countryCode == 'en') {
      return description_en;
    } else {
      return description_zh;
    }
  }
}
