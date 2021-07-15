import 'package:google_maps_flutter/google_maps_flutter.dart';

class Elevation {
  final double elevation;
  final LatLng location;

  Elevation(this.elevation, this.location);

  Elevation.fromJson(Map<String, dynamic> json)
      : elevation = json['elevation'],
        location = LatLng.fromJson([json['location']['lat'], json['location']['lng']])!;

  Map<String, dynamic> toJson() => {
        'elevation': elevation,
        'location': {
          'lat': location.latitude,
          'lng': location.longitude
        },
      };
}