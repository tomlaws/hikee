import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:hikee/components/map/map_controller.dart';
import 'package:hikee/models/facility.dart';
import 'package:hikee/providers/active_trail.dart';
import 'package:hikee/providers/geodata.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/components/sliding_up_panel.dart';
import 'package:hikee/models/active_trail.dart';
import 'package:hikee/models/distance_post.dart';
import 'package:url_launcher/url_launcher.dart';

class CompassController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final activeTrailProvider = Get.find<ActiveTrailProvider>();
  final _geodataProvider = Get.put(GeodataProvider());
  final panelController = PanelController();
  final panelPageController = Rxn<PageController>(null);
  late StreamSubscription<ActiveTrail?> subscription;
  HikeeMapController? mapController;

  // UI
  final double collapsedPanelHeight = kBottomNavigationBarHeight;
  final panelPosition = 0.0.obs;
  final panelPage = 0.0.obs;
  final double panelHeaderHeight = 60;
  final lockPosition = false.obs;
  final nearbyFacilities = Rxn<List<Facility>>();
  final pinnedFacility = Rxn<Facility>();
  final nearestDistancePost = Rxn<DistancePost>();

  // tooltip
  late AnimationController tooltipController;
  late Animation<int> alpha;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    subscription = activeTrailProvider.activeTrail.listen((trail) {
      if (trail != null) {
        if (panelPageController.value == null) {
          panelPageController.value = PageController(
            initialPage: 0,
          )..addListener(() {
              panelPage.value = panelPageController.value!.page ?? 0;
            });
        }
      } else {
        if (panelPageController.value != null) {
          panelPageController.value!.dispose();
          panelPageController.value = null;
        }
      }
    });

    tooltipController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    Animation<double> curve =
        CurvedAnimation(parent: tooltipController, curve: Curves.easeInOutSine);
    alpha = IntTween(begin: 0, end: 15).animate(curve);
    tooltipController.repeat(reverse: true);
  }

  @override
  void onClose() {
    _timer?.cancel();
    subscription.cancel();
    panelPageController.value?.dispose();
    tooltipController.dispose();
    super.onClose();
  }

  RxBool get isCloseToStart {
    return activeTrailProvider.isCloseToStart;
  }

  Rxn<ActiveTrail> get activeTrail {
    return activeTrailProvider.activeTrail;
  }

  Rxn<LocationMarkerHeading> get currentHeading {
    return activeTrailProvider.currentHeading;
  }

  Rxn<LocationMarkerPosition> get currentLocation {
    return activeTrailProvider.currentLocation;
  }

  List<LatLng>? get userPath {
    return activeTrailProvider.activeTrail.value?.userPath;
  }

  double? get speed {
    return activeTrailProvider.activeTrail.value?.speed;
  }

  int? get estimatedFinishTime {
    return activeTrailProvider.activeTrail.value?.estimatedFinishTime;
  }

  Future<void> showDistancePost(DistancePost dp) async {
    try {
      lockPosition.value = false;
      nearestDistancePost.value = dp;
    } catch (e) {
      print(e);
    }
  }

  finishTrail() async {
    // try {
    //   if (_authProvider.loggedIn.value) {
    //     //upload stats
    //     var time = elapsed.value;
    //     var trailId = activeTrail.value!.trail.id;
    //     var trailName = activeTrail.value!.trail.name_en;
    //     var distance = activeTrail.value!.trail.length;
    //     var msse = activeTrail.value!.startTime!;
    //     var regionId = activeTrail.value!.trail.regionId;
    //     var date = DateTime.fromMillisecondsSinceEpoch(msse);
    //     Record record = await _recordProvider.createRecord(
    //         date: date,
    //         time: time,
    //         name: trailName,
    //         referenceTrailId: trailId,
    //         regionId: regionId,
    //         length: (GeoUtils.getPathLength(path: walkedPath.toList()) * 1000)
    //             .truncate(),
    //         userPath: walkedPath.toList(),
    //         altitudes: altitudes);
    //     DialogUtils.showDialog(
    //         "Congratulations",
    //         Column(
    //           children: [
    //             Text("You've completed the trail!"),
    //             SizedBox(
    //               height: 8,
    //             ),
    //             Container(
    //               padding: EdgeInsets.all(8),
    //               decoration: BoxDecoration(
    //                   color: Color(0xFFF5F5F5),
    //                   borderRadius: BorderRadius.circular(16)),
    //               child: Row(
    //                 children: [
    //                   Icon(
    //                     LineAwesomeIcons.award,
    //                     size: 48,
    //                     color: Colors.amber[700],
    //                   ),
    //                   Expanded(
    //                     child: Column(
    //                       children: [
    //                         Text(
    //                           trailName,
    //                           maxLines: 2,
    //                           overflow: TextOverflow.ellipsis,
    //                         ),
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //               child: Column(
    //                 children: [
    //                   SizedBox(
    //                     height: 16,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text('Start Time'),
    //                       Text(DateFormat('yyyy-MM-dd HH:mm').format(date))
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 16,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text('Time Used'),
    //                       Text(TimeUtils.formatSeconds(elapsed.value))
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 16,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text('Distance'),
    //                       Text(
    //                         '${(distance / 1000).toString()}km',
    //                       )
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 8,
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ));
    //   }
    // } catch (ex) {}
    // await quitTrail();
  }

  void googleMapDir() {
    if (currentLocation.value == null) return;
    var origin =
        '${currentLocation.value!.latitude.toString()},${currentLocation.value!.longitude.toString()}';
    var destination =
        '${activeTrail.value!.decodedPath.first.latitude.toString()},${activeTrail.value!.decodedPath.first.longitude.toString()}';
    launch(
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=transit');
  }

  Future<void> discoverNearbyFacilities() async {
    if (currentLocation.value == null) {
      nearbyFacilities.value = [];
      return;
    }
    nearbyFacilities.value = await _geodataProvider
        .getNearbyFacilities(currentLocation.value!.latLng);
  }
}
