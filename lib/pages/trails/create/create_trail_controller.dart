import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class CreateTrailController extends GetxController {
  final prevCoordinates = RxList<LatLng>([]);
  var coordinates = RxList<LatLng>([]);
  final step = 0.obs;

  void addLocation(LatLng location) async {
    prevCoordinates.assignAll(coordinates);
    coordinates.add(location);
  }

  void remove(int i) {
    prevCoordinates.assignAll(coordinates);
    coordinates.removeAt(i);
  }

  void undo() {
    coordinates.assignAll(prevCoordinates);
    prevCoordinates.clear();
  }

  void updateMarkerPosition(int idx, LatLng location) async {
    coordinates[idx] = location;
  }
}
