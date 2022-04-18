import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:hikees/models/active_trail.dart';
import 'package:hikees/models/height_data.dart';
import 'package:hikees/models/reference_trail.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/offline.dart';
import 'package:hikees/providers/shared/base.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/location_callback_handler.dart';
import 'package:hikees/utils/location_service_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart' as vmath;

// Core Provider
class ActiveTrailProvider extends BaseProvider {
  ReceivePort port = ReceivePort();

  final activeTrail = Rxn<ActiveTrail>(null);
  // GPS dependent
  final currentLocation = Rxn<LocationMarkerPosition>();
  final currentHeading = Rxn<LocationMarkerHeading>();
  final isCloseToStart = false.obs;
  final isCloseToGoal = false.obs;

  Timer? _timer;
  final tick = 0.obs;
  final heights = RxList<double>();
  bool tracking = false;

  bool get recordMode {
    if (activeTrail.value == null) return false;
    return activeTrail.value!.referenceTrailId == null;
  }

  @override
  void onInit() {
    super.onInit();
    _load();
    activeTrail.listen((_) {
      _update();
      if (activeTrail.value == null || !activeTrail.value!.isStarted) {
        if (_timer != null) {
          tick.value = 0;
          _timer!.cancel();
          _timer = null;
        }
      } else {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          // update
          tick.value += 1;
        });
      }
      // location tracking
      if (activeTrail.value == null) {
        if (tracking) {
          _stopLocationTracking();
        }
      } else {
        if (!tracking) {
          _startLocationTracking();
        }
      }
    });

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
    BackgroundLocator.initialize();
  }

  @override
  void onClose() {
    activeTrail.close();
    IsolateNameServer.removePortNameMapping(
        LocationServiceRepository.isolateName);
    port.close();
    super.onClose();
  }

  Future<void> _startLocationTracking() async {
    Map<String, dynamic> data = {'countInit': 1};
    double distanceFilter = 6.0; // 6meters
    await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            distanceFilter: distanceFilter),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: distanceFilter,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Hikee',
                notificationMsg: 'Hikee navigation is active',
                notificationBigMsg: notificationText,
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
    tracking = true;
  }

  void _stopLocationTracking() {
    BackgroundLocator.unRegisterLocationUpdate();
    tracking = false;
  }

  Future<void> onLocationChange(LocationDto location) async {
    currentLocation.value = LocationMarkerPosition(
        latitude: location.latitude,
        longitude: location.longitude,
        accuracy: location.accuracy);
    currentHeading.value = LocationMarkerHeading(
        heading: vmath.radians(location.heading), accuracy: 1.0);

    if (activeTrail.value?.isStarted == true) {
      LatLng latlng = LatLng(location.latitude, location.longitude);
      if (activeTrail.value!.userPath.length > 0 &&
          activeTrail.value!.userPath.last != latlng) {
        activeTrail.update((t) {
          t?.addPoint(latlng);
        });
      }

      updateNotification();
    }
    if (activeTrail.value?.originalPath != null) {
      isCloseToStart.value = GeoUtils.isCloseToPoint(
          currentLocation.value!.latLng,
          activeTrail.value!.originalPath!.first);
      isCloseToGoal.value = GeoUtils.isCloseToPoint(
          currentLocation.value!.latLng, activeTrail.value!.originalPath!.last);
    }
  }

  String get notificationText {
    return activeTrail.value?.isStarted == true
        ? "You've walked ${activeTrail.value!.length.toString()} km"
        : (recordMode
            ? 'You\'re in recording mode. Tap to see more details.'
            : 'Trail selected. Tap to see more details.');
  }

  Future<void> updateNotification() async {
    if (tracking) {
      BackgroundLocator.updateNotificationText(bigMsg: notificationText);
    }
  }

  Future<void> _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('activeTrail')) {
      activeTrail.value =
          ActiveTrail.fromJson(jsonDecode(prefs.getString('activeTrail')!));
    }
  }

  Future<void> _update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (activeTrail.value == null) {
      prefs.remove('activeTrail');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('activeTrail', jsonEncode(activeTrail.value!.toJson()));
    }
  }

  Future<void> select(Trail trail) async {
    try {
      var decodedPath = GeoUtils.decodePath(trail.path);
      // get elevations
      // List<HeightData> heights = [];
      // try {
      //   heights = await GeoUtils.getHeights(decodedPath);
      // } catch (ex) {
      //   print(ex);
      // }
      activeTrail.value = ActiveTrail(
          name: trail.name,
          regionId: trail.regionId,
          referenceTrailId: trail.id,
          originalPath: GeoUtils.decodePath(trail.path));

      isCloseToStart.value = GeoUtils.isCloseToPoint(
          currentLocation.value!.latLng, activeTrail.value!.originalPath![0]);
      isCloseToGoal.value = GeoUtils.isCloseToPoint(
          currentLocation.value!.latLng, activeTrail.value!.originalPath!.last);
      updateNotification();
    } catch (ex) {
      print(ex);
    }
  }

  start() async {
    try {
      if (activeTrail.value == null) return;
      var startTime = DateTime.now().millisecondsSinceEpoch;
      activeTrail.update((t) {
        t?.startTime = startTime;
      });
      if (currentLocation.value != null) {
        activeTrail.update((t) {
          t?.addPoint(currentLocation.value!.latLng);
        });
      }

      updateNotification();
    } catch (ex) {
      print(ex);
    }
  }

  record() async {
    final _offlineProvider = Get.find<OfflineProvider>();
    activeTrail.value = ActiveTrail();
    updateNotification();
  }

  quit() async {
    activeTrail.value = null;
  }
}
