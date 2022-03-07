import 'package:get/get.dart';
import 'package:hikees/utils/lang.dart';
import 'package:latlong2/latlong.dart';

class Region {
  final int id;
  final String name_zh;
  final String name_en;
  final LatLng? center;

  Region(
      {required this.id,
      required this.name_zh,
      required this.name_en,
      this.center});

  Region.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name_zh = json['name_zh'],
        name_en = json['name_en'],
        center = json['center'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name_zh': name_zh, 'name_en': name_en, 'center': center};

  get name {
    if (Get.locale?.languageCode.toLowerCase() == 'zh') {
      if (Get.locale?.countryCode == 'CN') {
        return LangUtils.tcToSc(name_zh);
      }
      return name_zh;
    }
    return name_en;
  }

  static Set<Region> allRegions() {
    return {
      Region(
          id: 1,
          name_zh: "新界北區",
          name_en: "North New Territories",
          center: LatLng(22.499439, 114.172902)),
      Region(
          id: 2,
          name_zh: "港島區",
          name_en: "Hong Kong Island",
          center: LatLng(22.261978, 114.191099)),
      Region(
          id: 3,
          name_zh: "新界中區",
          name_en: "Central New Territories",
          center: LatLng(22.378211, 114.174719)),
      Region(
          id: 4,
          name_zh: "西貢區",
          name_en: "Sai Kung",
          center: LatLng(22.371269, 114.290473)),
      Region(
          id: 5,
          name_zh: "新界西區",
          name_en: "West New Territories",
          center: LatLng(22.416217, 114.033229)),
      Region(
          id: 6,
          name_zh: "大嶼山區",
          name_en: "Lantau",
          center: LatLng(22.267425, 113.945013))
    };
  }
}
