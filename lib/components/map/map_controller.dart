import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:hikees/utils/geo.dart';
import 'package:latlong2/latlong.dart';

class HikeeMapController extends GetxController {
  final imagery = false.obs;
  final centerOnLocationUpdate = false.obs;
  MapController? mapController;
  Stream<LocationMarkerPosition?>? positionStream;
  late StreamController<double?> centerCurrentLocationStreamController;
  StreamSubscription<LocationMarkerPosition?>? subscription;

  @override
  void onInit() {
    super.onInit();
    centerCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void onClose() {
    centerCurrentLocationStreamController.close();
    subscription?.cancel();
    super.onClose();
  }

  void focusCurrentLocationOnce(Stream<LocationMarkerPosition?>? stream) {
    positionStream = stream;
    subscription?.cancel();
    subscription = positionStream?.listen((event) {
      focusCurrentLocation();
      subscription?.cancel();
      subscription = null;
    });
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
    centerCurrentLocationStreamController.add(17.0);
  }
}
