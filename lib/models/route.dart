import 'package:google_maps_flutter/google_maps_flutter.dart';

class HikingRoute {
  final int id;
  final String name;
  final String name_en;
  final String district;
  final String district_en;
  final String image;
  final double difficulty;
  final double rating;
  final double duration;
  final double length;
  final List<LatLng> polyline;
  final DateTime? updatedAt;

  HikingRoute(
      this.id,
      this.name,
      this.name_en,
      this.district,
      this.district_en,
      this.image,
      this.difficulty,
      this.rating,
      this.duration,
      this.length,
      this.polyline,
      this.updatedAt);

  HikingRoute.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        name_en = json['name_en'],
        district = json['district'],
        district_en = json['district_en'],
        image = json['image'],
        difficulty = json['difficulty'],
        rating = json['rating'],
        duration = json['duration'],
        length = json['length'],
        polyline = (json['polyline'] as List)
            .map((e) => LatLng.fromJson(e) as LatLng)
            .toList(),
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_en': name_en,
        'district': district,
        'district_en': district_en,
        'image': image,
        'difficulty': difficulty,
        'rating': rating,
        'duration': duration,
        'length': length,
        'polyline': polyline.map((e) => e.toJson()).toList(),
        'updatedAt': updatedAt,
      };
}
