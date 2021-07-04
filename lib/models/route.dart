import 'package:google_maps_flutter/google_maps_flutter.dart';

class Route {
  final String name;
  final String name_en;
  final int difficulty;
  final double duration;
  final double length;
  final List<LatLng> polyline;
  final DateTime? updatedAt;

  Route(this.name, this.name_en, this.difficulty, this.duration, this.length,
      this.polyline, this.updatedAt);
  //\[(.*?),(.*?)\]
  Route.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        name_en = json['name_en'],
        difficulty = json['difficulty'],
        duration = json['duration'],
        length = json['length'],
        polyline =
            (json['polyline'] as List).map((e) => LatLng.fromJson(e) as LatLng).toList(),
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'name_en': name_en,
        'difficulty': difficulty,
        'duration': duration,
        'length': length,
        'polyline': polyline.map((e) => e.toJson()).toList(),
        'updatedAt': updatedAt,
      };
}
