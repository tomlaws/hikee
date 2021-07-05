import 'package:google_maps_flutter/google_maps_flutter.dart';

class HikingRoute {
  final String name;
  final String name_en;
  final String image;
  final int difficulty;
  final double duration;
  final double length;
  final List<LatLng> polyline;
  final DateTime? updatedAt;

  HikingRoute(this.name, this.name_en, this.image, this.difficulty, this.duration, this.length,
      this.polyline, this.updatedAt);
  //\[(.*?),(.*?)\]
  HikingRoute.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        name_en = json['name_en'],
        image = json['image'],
        difficulty = json['difficulty'],
        duration = json['duration'],
        length = json['length'],
        polyline =
            (json['polyline'] as List).map((e) => LatLng.fromJson(e) as LatLng).toList(),
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'name_en': name_en,
        'image': image,
        'difficulty': difficulty,
        'duration': duration,
        'length': length,
        'polyline': polyline.map((e) => e.toJson()).toList(),
        'updatedAt': updatedAt,
      };
}
