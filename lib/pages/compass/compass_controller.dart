import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/sliding_up_panel.dart';
import 'package:hikee/models/active_trail.dart';
import 'package:hikee/models/distance_post.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/record.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/location_callback_handler.dart';
import 'package:hikee/utils/location_service_repository.dart';
import 'package:hikee/utils/time.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:background_locator/background_locator.dart';

class CompassController extends GetxController
    with SingleGetTickerProviderMixin {
  Rxn<ActiveTrail> activeTrail = Rxn<ActiveTrail>();
  Completer<GoogleMapController> mapController = Completer();
  PanelController panelController = PanelController();
  PageController panelPageController = PageController(
    initialPage: 0,
  );

  // Data
  final currentLocation = Rxn<LatLng>();
  final nearestDistancePost = Rxn<DistancePost>();
  Timer? _timer;
  final elapsed = 0.obs;
  final walkedDistance = 0.0.obs;
  final walkedPath = RxList<LatLng>();
  final heading = 0.0.obs;
  final isCloseToStart = false.obs;
  final isCloseToGoal = false.obs;
  final started = false.obs;
  final altitudes = RxList<double>();
  final speed = 0.0.obs;
  final estimatedFinishTime = 0.obs;

  // UI
  final double collapsedPanelHeight = kBottomNavigationBarHeight;
  final panelPosition = 0.0.obs;
  final panelPage = 0.0.obs;
  final double panelHeaderHeight = 60;
  bool lockPosition = true;

  // tooltip
  late AnimationController tooltipController;
  late Animation<int> alpha;

  AuthProvider _authProvider = Get.put(AuthProvider());
  RecordProvider _recordProvider = Get.put(RecordProvider());

  ReceivePort port = ReceivePort();

  @override
  void onInit() {
    super.onInit();
    _loadTrail();
    print('load trail');
    panelPageController
      ..addListener(() {
        panelPage.value = panelPageController.page ?? 0;
      });
    // start timer when active trail is started
    activeTrail.listen((trail) {
      started.value = trail?.isStarted ?? false;
      if (trail == null || !trail.isStarted) {
        elapsed.value = 0;
        if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
      } else {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          int s = DateTime.now().millisecondsSinceEpoch -
              (activeTrail.value?.startTime ??
                  DateTime.now().millisecondsSinceEpoch);
          elapsed.value = ((s / 1000).floor());

          updateSpeed();
        });
      }
      // location tracking
      if (trail == null) {
        stopLocationTracking();
      } else {
        print('start tracking location in the background');
        startLocationTracking();
      }
    });

    tooltipController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    Animation<double> curve =
        CurvedAnimation(parent: tooltipController, curve: Curves.easeInOutSine);
    alpha = IntTween(begin: 0, end: 15).animate(curve);
    tooltipController.repeat(reverse: true);

    // For location tracking
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);
    port.listen((dynamic data) {
      if (data != null) onLocationChange(data);
    });
    initPlatformState();
  }

  @override
  void onClose() {
    panelPageController.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
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
          zoom: 17.0,
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

  void focusActiveTrail() async {
    var decodedPath = activeTrail.value!.decodedPath;
    lockPosition = false;
    print({
      'start': activeTrail.value!.decodedPath.first,
      'end': activeTrail.value!.decodedPath.last
    });
    final GoogleMapController controller = await mapController.future;
    controller.moveCamera(
        CameraUpdate.newLatLngBounds(GeoUtils.getPathBounds(decodedPath), 20));
  }

  _loadTrail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('activeTrail')) {
        String? json = prefs.getString('activeTrail');
        if (json != null) {
          var trail = Trail.fromJson(jsonDecode(json));
          var decodedPath = GeoUtils.decodePath(trail.path);
          var startTime = prefs.getInt('startTime');
          activeTrail.value = ActiveTrail(
              trail: trail, decodedPath: decodedPath, startTime: startTime);
        }
      }
      if (prefs.containsKey('walkedPath')) {
        String s = prefs.getString('walkedPath')!;
        walkedPath.value = (jsonDecode(s) as List<dynamic>)
            .map((e) => LatLng.fromJson(e)!)
            .toList();

        walkedDistance.value = GeoUtils.getPathLength(path: walkedPath);
      }
      if (prefs.containsKey('altitudes')) {
        String s = prefs.getString('altitudes')!;
        altitudes.value =
            (jsonDecode(s) as List<dynamic>).map((e) => e as double).toList();
      }
    } catch (ex) {
      print(ex);
    }
  }

  selectTrail(Trail trail) async {
    try {
      var decodedPath = GeoUtils.decodePath(trail.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String encoded = jsonEncode(trail.toJson());
      prefs.setString('activeTrail', encoded);
      activeTrail.value =
          ActiveTrail(trail: trail, decodedPath: decodedPath, startTime: null);
      isCloseToStart.value = GeoUtils.isCloseToPoint(
          currentLocation.value!, activeTrail.value!.decodedPath[0]);
    } catch (ex) {
      print(ex);
    }
  }

  startTrail() async {
    try {
      if (activeTrail.value == null) return;
      var startTime = DateTime.now().millisecondsSinceEpoch;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('startTime', startTime);
      activeTrail.value = ActiveTrail(
          trail: activeTrail.value!.trail,
          decodedPath: activeTrail.value!.decodedPath,
          startTime: startTime);
      isCloseToGoal.value = false;
      if (currentLocation.value != null) {
        isCloseToStart.value = GeoUtils.isCloseToPoint(
            currentLocation.value!, activeTrail.value!.decodedPath[0]);
        walkedPath.add(currentLocation.value!);
      }
      updateNotification(0);
    } catch (ex) {
      print(ex);
    }
  }

  quitTrail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('startTime');
      prefs.remove('activeTrail');
      activeTrail.value = null;
      panelPosition.value = 0;
    } catch (ex) {
      print(ex);
    }
  }

  finishTrail() async {
    try {
      if (_authProvider.loggedIn.value) {
        //upload stats
        var time = elapsed.value;
        var trailId = activeTrail.value!.trail.id;
        var trailName = activeTrail.value!.trail.name_en;
        var distance = activeTrail.value!.trail.length;
        var msse = activeTrail.value!.startTime!;
        var date = DateTime.fromMillisecondsSinceEpoch(msse);
        Record record = await _recordProvider.createRecord(
            date: date,
            time: time,
            name: trailName,
            path: activeTrail.value!.trail.path,
            userPath: walkedPath.toList(),
            altitudes: altitudes);
        Get.defaultDialog(
          title: "Congratulations, you've completed the trail!",
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Icon(
                        LineAwesomeIcons.award,
                        size: 48,
                        color: Colors.amber[700],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(trailName),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Start Time'),
                    Text(DateFormat('yyyy-MM-dd HH:mm').format(date))
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time Used'),
                    Text(TimeUtils.formatSeconds(elapsed.value))
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Distance'),
                    Text(
                      '${(distance / 1000).toString()}km',
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          actions: [
            Button(
              onPressed: () {
                Get.back();
              },
              child: Text('DISMISS'),
            )
          ],
        );
      }
    } catch (ex) {}
    await quitTrail();
  }

  void googleMapDir() {
    if (currentLocation.value == null) return;
    var origin =
        '${currentLocation.value!.latitude.toString()},${currentLocation.value!.longitude.toString()}';
    var destination =
        '${activeTrail.value!.decodedPath.first.latitude.toString()},${activeTrail.value!.decodedPath.first.longitude.toString()}';
    //print(
    //    'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=transit');
    launch(
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=transit');
  }

  Future<bool> _checkLocationPermission() async {
    final access = await Permission.location.status;
    switch (access) {
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        if (await Permission.locationAlways.request().isGranted) {
          return true;
        } else {
          return false;
        }
      case PermissionStatus.granted:
        return true;
      default:
        return false;
    }
  }

  Future<void> startLocationTracking() async {
    if (!await _checkLocationPermission()) {
      print('Location permission denied');
      return;
    }
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Hikee',
                notificationMsg: 'Hikee navigation is active',
                notificationBigMsg: 'Trail selected. Tap to see more details.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }

  void stopLocationTracking() {
    BackgroundLocator.unRegisterLocationUpdate();
    walkedPath.clear();
    walkedDistance.value = 0;
    speed.value = 0;
    SharedPreferences.getInstance().then((instance) {
      instance.remove('walkedPath');
      instance.remove('altitudes');
    });
  }

  Future<void> onLocationChange(LocationDto location) async {
    LatLng latlng = LatLng(location.latitude, location.longitude);
    currentLocation.value = latlng;
    heading.value = location.heading;
    if (started.value) {
      walkedPath.add(latlng);
      walkedDistance.value = GeoUtils.getPathLength(path: walkedPath);
      updateNotification(walkedDistance.value);
      if (location.altitude != 0) altitudes.add(location.altitude);
      SharedPreferences.getInstance().then((instance) {
        instance.setString('walkedPath',
            jsonEncode(walkedPath.map((element) => element.toJson()).toList()));
        instance.setString('altitudes', jsonEncode(altitudes));
      });
    }
    if (activeTrail.value != null) {
      isCloseToStart.value = GeoUtils.isCloseToPoint(
          currentLocation.value!, activeTrail.value!.decodedPath.first);
      isCloseToGoal.value = GeoUtils.isCloseToPoint(
          currentLocation.value!, activeTrail.value!.decodedPath.last);
    }
    if (lockPosition) {
      goToCurrentLocation();
    }
  }

  void updateNotification(double km) {
    BackgroundLocator.updateNotificationText(
        bigMsg: "You've walked ${km.toString()} km");
  }

  void updateSpeed() {
    var kmps = (walkedDistance.value / elapsed.value);
    if (elapsed.value == 0.0 || kmps == 0.0 || kmps.isInfinite || kmps.isNaN)
      estimatedFinishTime.value = activeTrail.value!.trail.duration * 60;
    else {
      speed.value = kmps * 3600; //km per sec to km per hour
      var remamingLength =
          activeTrail.value!.trail.length - walkedDistance.value;
      estimatedFinishTime.value =
          (remamingLength * 0.001 / kmps).round(); // in secs
    }
  }
}
