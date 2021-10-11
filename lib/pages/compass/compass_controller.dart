import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/sliding_up_panel.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/distance_post.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/utils/geo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompassController extends GetxController {
  Rxn<ActiveHikingRoute> activeRoute = Rxn<ActiveHikingRoute>();
  Completer<GoogleMapController> mapController = Completer();
  PanelController panelController = PanelController();
  PageController panelPageController = PageController(
    initialPage: 0,
  );
  late StreamSubscription<Position> _positionStream;

  // Data
  final currentLocation = Rxn<LatLng>();
  final nearestDistancePost = Rxn<DistancePost>();
  Timer? _timer;
  final elapsed = 0.obs;
  final walkedDistance = 0.0.obs;
  final isCloseToStart = false.obs;
  final isCloseToGoal = false.obs;

  // UI
  final double collapsedPanelHeight = kBottomNavigationBarHeight;
  final panelPosition = 0.0.obs;
  final panelPage = 0.0.obs;
  final double panelHeaderHeight = 60;
  bool lockPosition = true;

  @override
  void onInit() {
    super.onInit();
    _loadRoute();
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      currentLocation.value = LatLng(position.latitude, position.longitude);
      if (activeRoute.value != null) {
        isCloseToStart.value = GeoUtils.isCloseToPoint(
            currentLocation.value!, activeRoute.value!.decodedPath.first);
        isCloseToGoal.value = GeoUtils.isCloseToPoint(
            currentLocation.value!, activeRoute.value!.decodedPath.last);
      }
      if (lockPosition) {
        goToCurrentLocation();
      }
    });
    panelPageController
      ..addListener(() {
        panelPage.value = panelPageController.page ?? 0;
      });

    // start timer when active route is started
    activeRoute.listen((route) {
      if (route == null || !route.isStarted) {
        elapsed.value = 0;
        if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
      } else {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          int s = DateTime.now().millisecondsSinceEpoch -
              (activeRoute.value?.startTime ??
                  DateTime.now().millisecondsSinceEpoch);
          elapsed.value = ((s / 1000).floor());
          if (currentLocation.value != null)
            walkedDistance.value = GeoUtils.getWalkedLength(
                currentLocation.value!, activeRoute.value!.decodedPath);
        });
      }
    });
  }

  @override
  void onClose() {
    _positionStream.cancel();
    panelPageController.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  Future<void> goToCurrentLocation() async {
    try {
      lockPosition = true;
      if (currentLocation.value == null) return;
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: currentLocation.value!,
          zoom: 14.0,
        ),
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> showDistancePost(DistancePost dp) async {
    try {
      lockPosition = false;
      var location = dp.location;
      nearestDistancePost.value = dp;
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: location,
          zoom: 16.0,
        ),
      ));
    } catch (e) {
      print(e);
    }
  }

  void focusActiveRoute() async {
    var decodedPath = activeRoute.value!.decodedPath;
    lockPosition = false;
    print({
      'start': activeRoute.value!.decodedPath.first,
      'end': activeRoute.value!.decodedPath.last
    });
    final GoogleMapController controller = await mapController.future;
    controller.moveCamera(
        CameraUpdate.newLatLngBounds(GeoUtils.getPathBounds(decodedPath), 20));
  }

  _loadRoute() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('activeRoute')) {
        String? json = prefs.getString('activeRoute');
        if (json != null) {
          var route = HikingRoute.fromJson(jsonDecode(json));
          var decodedPath = GeoUtils.decodePath(route.path);
          var startTime = prefs.getInt('startTime');
          activeRoute.value = ActiveHikingRoute(
              route: route, decodedPath: decodedPath, startTime: startTime);
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  selectRoute(HikingRoute route) async {
    try {
      var decodedPath = GeoUtils.decodePath(route.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String encoded = jsonEncode(route.toJson());
      prefs.setString('activeRoute', encoded);
      activeRoute.value = ActiveHikingRoute(
          route: route, decodedPath: decodedPath, startTime: null);
      isCloseToStart.value = GeoUtils.isCloseToPoint(
          currentLocation.value!, activeRoute.value!.decodedPath[0]);
    } catch (ex) {
      print(ex);
    }
  }

  startRoute() async {
    try {
      if (activeRoute.value == null) return;
      var startTime = DateTime.now().millisecondsSinceEpoch;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('startTime', startTime);
      activeRoute.value = ActiveHikingRoute(
          route: activeRoute.value!.route,
          decodedPath: activeRoute.value!.decodedPath,
          startTime: startTime);
      isCloseToGoal.value = false;
      if (currentLocation.value != null)
        isCloseToStart.value = GeoUtils.isCloseToPoint(
            currentLocation.value!, activeRoute.value!.decodedPath[0]);
    } catch (ex) {
      print(ex);
    }
  }

  quitRoute() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('startTime');
      prefs.remove('activeRoute');
      activeRoute.value = null;
      panelPosition.value = 0;
    } catch (ex) {
      print(ex);
    }
  }

  finishRoute() async {
    //upload stats

    //elapsed;
    // walkedDistanc
    quitRoute();
  }
}
