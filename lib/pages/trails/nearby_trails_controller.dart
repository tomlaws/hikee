import 'package:get/get.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/trail.dart';
import 'package:geolocator/geolocator.dart';

class NearbyTrailsController extends GetxController
    with StateMixin<List<Trail>?> {
  final _trailProvider = Get.put(TrailProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => _load);
  }

  Future<List<Trail>?> _load() async {
    Position pos = await _determinePosition();
    return _trailProvider.getNearbyTrails(pos.latitude, pos.longitude);
  }

  void refetch() {
    change(null, status: RxStatus.loading());
    append(() => _load);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
