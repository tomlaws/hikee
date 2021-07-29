import 'dart:convert';

import 'package:hikee/models/region.dart';

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

  HikingRoute.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name_zh = json['name_zh'],
        name_en = json['name_en'],
        regionId = json['regionId'],
        region = Region.fromJson(json['region']),
        description_zh = json['description_zh'],
        description_en = json['description_en'],
        image = json['image'],
        images = List<String>.from(json['images']),
        difficulty = json['difficulty'],
        rating = json['rating'],
        duration = json['duration'],
        length = json['length'],
        path = json['path'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_zh': name_zh,
        'name_en': name_en,
        'regionId': regionId,
        'region': region.toJson(),
        'description_zh': description_zh,
        'description_en': description_en,
        'image': image,
        'images': images.toString(),
        'difficulty': difficulty,
        'rating': rating,
        'duration': duration,
        'length': length,
        'path': path,
      };
}
