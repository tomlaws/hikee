import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/elevation_profile.dart';
import 'package:hikee/models/elevation.dart';
import 'package:hikee/pages/compass/compass_controller.dart';
import 'package:hikee/providers/trail.dart';

class TrailElevationController extends GetxController
    with StateMixin<List<Elevation>> {}

class TrailElevation extends GetView<TrailElevationController> {
  final TrailElevationController controller =
      Get.put(TrailElevationController());
  final TrailProvider _trailProvider = Get.put(TrailProvider());
  final CompassController _compassController = Get.put(CompassController());

  final int trailId;

  TrailElevation({Key? key, required this.trailId}) : super(key: key) {
    controller.append(() => () => _trailProvider.getElevations(trailId));
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
