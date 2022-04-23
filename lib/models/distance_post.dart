import 'package:get/get.dart';
import 'package:hikees/utils/lang.dart';
import 'package:latlong2/latlong.dart';

class DistancePost {
  final String no;
  final String trail_name_en;
  final String trail_name_zh;
  final LatLng location;
  DistancePost(
      {required this.no,
      required this.trail_name_en,
      required this.trail_name_zh,
      required this.location});

  get name {
    if (Get.locale?.languageCode.toLowerCase() == 'zh') {
      if (Get.locale?.countryCode == 'CN') {
        return LangUtils.tcToSc(trail_name_zh);
      }
      return trail_name_zh;
    }
    return trail_name_en;
  }
}
