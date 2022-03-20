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
import 'package:hikees/models/hk_datum.dart';
import 'package:hikees/models/reference_trail.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/shared/base.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/location_callback_handler.dart';
import 'package:hikees/utils/location_service_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'package:collection/collection.dart';

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
  final altitudes = RxList<double>();
  bool tracking = false;

  bool get recordMode {
    if (activeTrail.value == null) return false;
    return activeTrail.value!.trail == null;
  }

  @override
  void onInit() {
    super.onInit();
    _load();
    activeTrail.listen((_) {
      _save();
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

  Future<void> _startLocationTracking() async {
    if (!await _checkLocationPermission()) {
      print('Location permission denied');
      return;
    }
    Map<String, dynamic> data = {'countInit': 1};

    await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 1),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 1,
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
      if (activeTrail.value!.userPath.last != latlng) {
        activeTrail.update((t) {
          t?.addPoint(latlng);
        });
      }

      updateNotification();
    }
    if (activeTrail.value?.trail?.path != null) {
      isCloseToStart.value = GeoUtils.isCloseToPoint(
          currentLocation.value!.latLng, activeTrail.value!.trail!.path!.first);
      isCloseToGoal.value = GeoUtils.isCloseToPoint(
          currentLocation.value!.latLng, activeTrail.value!.trail!.path!.last);
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
    if (!prefs.containsKey('activeTrail')) return;
    String serialized = prefs.getString('activeTrail')!;
    dynamic decoded = jsonDecode(serialized);
    if (decoded == null) return;
    activeTrail.value = ActiveTrail.fromJson(decoded);
  }

  Future<void> _save() async {
    String serialized = jsonEncode(activeTrail);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('activeTrail', serialized);
  }

  Future<void> select(Trail trail) async {
    try {
      var decodedPath = GeoUtils.decodePath(trail.path);
      // get elevations
      List<HKDatum> heights = [];
      try {
        heights = await GeoUtils.getHKDPs(decodedPath);
      } catch (ex) {
        print(ex);
      }
      activeTrail.value = ActiveTrail(
          trail: ReferenceTrail.fromTrail(trail, heights: heights),
          startTime: null);
      isCloseToStart.value = GeoUtils.isCloseToPoint(
          currentLocation.value!.latLng, activeTrail.value!.trail!.path![0]);
      isCloseToGoal.value = GeoUtils.isCloseToPoint(
          currentLocation.value!.latLng, activeTrail.value!.trail!.path!.last);
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
    activeTrail.value = ActiveTrail(startTime: null);
    updateNotification();
  }

  quit() async {
    activeTrail.value = null;
  }
}
