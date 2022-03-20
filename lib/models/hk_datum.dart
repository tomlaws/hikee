import 'package:latlong2/latlong.dart';

class HKDatum {
  final int datum;
  final LatLng location;

  HKDatum(this.datum, this.location);

  HKDatum.fromJson(Map<String, dynamic> json)
      : datum = json['datum'],
        location = LatLng(json['location']['lat'], json['location']['lng']);

  Map<String, dynamic> toJson() => {
        'datum': datum,
        'location': {'lat': location.latitude, 'lng': location.longitude},
      };
}
