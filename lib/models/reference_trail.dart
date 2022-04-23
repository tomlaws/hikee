import 'package:get/get.dart';
import 'package:hikees/models/height_data.dart';
import 'package:hikees/models/map_marker.dart';
import 'package:hikees/models/pin.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/lang.dart';
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
  List<MapMarker>? markers;
  List<LatLng>? path;
  List<HeightData> heights;
  bool offline;

  ReferenceTrail(
      {required this.id,
      required this.regionId,
      required this.name_en,
      required this.name_zh,
      required this.length,
      required this.duration,
      required this.path,
      required this.heights,
      this.offline = false,
      this.markers});

  get name {
    if (Get.locale?.languageCode.toLowerCase() == 'zh') {
      if (Get.locale?.countryCode == 'CN') {
        return LangUtils.tcToSc(name_zh);
      }
      return name_zh;
    }
    return name_en;
  }

  static ReferenceTrail fromTrail(Trail trail,
      {required List<HeightData> heights}) {
    return ReferenceTrail(
        id: trail.id,
        regionId: trail.regionId,
        name_en: trail.name_en,
        name_zh: trail.name_zh,
        length: trail.length,
        duration: trail.duration,
        markers: trail.markers,
        path: GeoUtils.decodePath(trail.path),
        offline: trail.offline ?? false,
        heights: heights);
  }

  factory ReferenceTrail.fromJson(Map<String, dynamic> json) =>
      _$ReferenceTrailFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceTrailToJson(this);
}
