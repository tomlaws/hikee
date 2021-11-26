import 'package:latlong2/latlong.dart';

class Elevation {
  final double elevation;
  final LatLng location;

  Elevation(this.elevation, this.location);

  Elevation.fromJson(Map<String, dynamic> json)
      : elevation = json['elevation'],
        location = LatLng(json['location']['lat'], json['location']['lng']);

  Map<String, dynamic> toJson() => {
        'elevation': elevation,
        'location': {'lat': location.latitude, 'lng': location.longitude},
      };
}
