import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class CreateTrailController extends GetxController {
  final coordinates = RxList<LatLng>([]);
  final step = 0.obs;

  void addLocation(LatLng location) async {
    coordinates.add(location);
  }

  void updateMarkerPosition(int idx, LatLng location) async {
    coordinates[idx] = location;
  }
}
