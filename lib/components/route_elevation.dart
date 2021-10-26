import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/elevation_profile.dart';
import 'package:hikee/models/elevation.dart';
import 'package:hikee/pages/compass/compass_controller.dart';
import 'package:hikee/providers/route.dart';

class RouteElevationController extends GetxController
    with StateMixin<List<Elevation>> {}

class RouteElevation extends GetView<RouteElevationController> {
  final RouteElevationController controller =
      Get.put(RouteElevationController());
  final RouteProvider _routeProvider = Get.put(RouteProvider());
  final CompassController _compassController = Get.put(CompassController());

  final int routeId;

  RouteElevation({Key? key, required this.routeId}) : super(key: key) {
    controller.append(() => () => _routeProvider.getElevations(routeId));
  }

  @override
  Widget build(BuildContext context) {
    return controller.obx((state) {
      LatLng? _myLocation = _compassController.currentLocation.value;
      return ElevationProfile(elevations: state!, myLocation: _myLocation);
    },
        onLoading: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
