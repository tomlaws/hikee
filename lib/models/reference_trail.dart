import 'package:get/get.dart';
import 'package:hikees/models/hk_datum.dart';
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
  List<Pin>? pins;
  List<LatLng>? path;
  List<HKDatum> heights;
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
      this.pins});

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
      {required List<HKDatum> heights}) {
    return ReferenceTrail(
        id: trail.id,
        regionId: trail.regionId,
        name_en: trail.name_en,
        name_zh: trail.name_zh,
        length: trail.length,
        duration: trail.duration,
        pins: trail.pins,
        path: GeoUtils.decodePath(trail.path),
        offline: trail.offline ?? false,
        heights: heights);
  }

  factory ReferenceTrail.fromJson(Map<String, dynamic> json) =>
      _$ReferenceTrailFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceTrailToJson(this);
}
