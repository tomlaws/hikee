import 'package:get/get.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/lang.dart';
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

  String get localizedName {
    if (Get.locale?.countryCode == 'CN') {
      return LangUtils.tcToSc(name);
    }
    return name;
  }

  // in m
  calculateDistance(LatLng loc) {
    return GeoUtils.calculateDistance(loc, location);
  }

  factory Facility.fromJson(Map<String, dynamic> json) =>
      _$FacilityFromJson(json);
  Map<String, dynamic> toJson() => _$FacilityToJson(this);
}
