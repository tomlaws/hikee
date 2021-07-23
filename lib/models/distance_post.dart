import 'package:google_maps_flutter/google_maps_flutter.dart';

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
}
