import 'package:hikee/models/elevation.dart';
import 'package:hikee/models/pin.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/utils/geo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'reference_trail.g.dart';

@JsonSerializable()
class ReferenceTrail {
  int id;
  int regionId;
  String name_zh;
  String name_en;
  int length;
  int duration;
  List<Pin>? pins;
  List<LatLng>? path;
  List<Elevation> elevations;

  ReferenceTrail(
      {required this.id,
      required this.regionId,
      required this.name_en,
      required this.name_zh,
      required this.length,
      required this.duration,
      required this.path,
      required this.elevations,
      this.pins});

  static ReferenceTrail fromTrail(Trail trail,
      {required List<Elevation> elevations}) {
    return ReferenceTrail(
        id: trail.id,
        regionId: trail.regionId,
        name_en: trail.name_en,
        name_zh: trail.name_zh,
        length: trail.length,
        duration: trail.duration,
        pins: trail.pins,
        path: GeoUtils.decodePath(trail.path),
        elevations: elevations);
  }

  factory ReferenceTrail.fromJson(Map<String, dynamic> json) =>
      _$ReferenceTrailFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceTrailToJson(this);
}
