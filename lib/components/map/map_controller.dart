import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hikee/models/active_trail.dart';
import 'package:hikee/providers/active_trail.dart';
import 'package:hikee/utils/geo.dart';
import 'package:latlong2/latlong.dart';

class HikeeMapController extends GetxController {
  final imagery = false.obs;
  final centerOnLocationUpdate = false.obs;
  MapController? mapController;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    print('close map controller');
    super.onClose();
  }

  void focus(LatLng point, {double? zoom}) {
    if (mapController == null) return;
    centerOnLocationUpdate.value = false;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      mapController!.move(point, zoom ?? mapController!.zoom);
    });
  }

  void focusPath(List<LatLng> path, {double? zoom}) {
    if (mapController == null) return;
    var result = mapController!.centerZoomFitBounds(
        GeoUtils.getPathBounds(path),
        options: FitBoundsOptions(padding: EdgeInsets.all(80)));
    focus(result.center, zoom: result.zoom);
  }

  void focusCurrentLocation() {
    var p = Get.find<ActiveTrailProvider>();
    if (p.currentLocation.value != null) focus(p.currentLocation.value!.latLng);
  }
}
