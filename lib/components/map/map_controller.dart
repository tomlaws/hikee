import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:hikees/components/map/mbtiles_provider.dart';
import 'package:hikees/models/hk_datum.dart';
import 'package:hikees/models/preferences.dart';
import 'package:hikees/providers/map_tiles.dart';
import 'package:hikees/providers/preferences.dart';
import 'package:hikees/utils/geo.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

class HikeeMapController extends GetxController {
  final imagery = false.obs;
  final centerOnLocationUpdate = false.obs;
  MapController? mapController;
  Stream<LocationMarkerPosition?>? positionStream;
  late StreamController<double?> centerCurrentLocationStreamController;
  StreamSubscription<LocationMarkerPosition?>? subscription;
  final heights = Rxn<List<HKDatum>>();
  final showHeights = false.obs;
  final applicationDocumentsDirectory = Rxn<String>();
  final _preferencesProvider = Get.find<PreferencesProvider>();
  final mapTilesProvider = Get.put(MapTilesProvider());
  final offlineTrail = false.obs;

  @override
  void onInit() {
    super.onInit();
    centerCurrentLocationStreamController = StreamController<double?>();
    getApplicationDocumentsDirectory().then((value) {
      applicationDocumentsDirectory.value = value.path;
    });
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

  Future<List<HKDatum>> getHeights(List<LatLng> path) async {
    showHeights.value = !showHeights.value;
    if (heights.value == null) {
      heights.value = await GeoUtils.getHKDPs(path);
    }
    if (heights.value == null) return [];
    return heights.value!;
  }

  MapProvider? get offlineMapProvider {
    return _preferencesProvider.preferences.value?.offlineMapProvider;
  }

  MapProvider? get mapProvider {
    return _preferencesProvider.preferences.value?.mapProvider;
  }

  bool get tms {
    // save by hikees, wtms
    return false;
  }

  MBTilesProvider? get offlineTrailProvider {
    // offline map of the trail
    if (offlineTrail.value) {
      return MBTilesProvider.fromDatabase(
          mapTilesProvider.loadTrailsDb(), false);
    }
    return null;
  }

  Future<void> loadFallbackTile(Tile tile) async {
    if (offlineTrail.value) return;
    if (offlineMapProvider == null) return;
    var coords = tile.coords;
    var img = await mapTilesProvider.loadTileFromOfflineMap(offlineMapProvider!,
        coords.z.toInt(), coords.x.toInt(), coords.y.toInt());
    if (img != null) {
      tile.imageProvider = img;
      tile.loadTileImage();
    }
  }
}
