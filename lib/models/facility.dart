import 'package:hikee/utils/geo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';

part 'facility.g.dart';

@JsonSerializable()
class Facility {
  final String address;
  final String name;
  double x;
  double y;

  Facility({
    required this.address,
    required this.name,
    required this.x,
    required this.y,
  });

  LatLng get location {
    return GeoUtils.convertFromEPSG2326(Tuple2(x, y));
  }

  calculateDistance(LatLng loc) {
    return GeoUtils.calculateDistance(loc, location);
  }

  factory Facility.fromJson(Map<String, dynamic> json) =>
      _$FacilityFromJson(json);
  Map<String, dynamic> toJson() => _$FacilityToJson(this);
}
