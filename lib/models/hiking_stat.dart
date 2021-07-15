import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/current_location.dart';
import 'package:hikee/utils/geo.dart';

class HikingStat extends ChangeNotifier {
  ActiveHikingRoute route;
  CurrentLocation location;

  late int id;
  late Stream<int> _clockStream;
  Stream<int> get clockStream => _clockStream;
  bool _isCounting = false;

  HikingStat(this.route, this.location,
      {Stream<int>? clockStream, bool reset = false}) {
    // timer
    id = route.id;
    if (reset) {
      _clockStream = _timedCounter(const Duration(seconds: 1));
    } else
      _clockStream = clockStream ?? _timedCounter(const Duration(seconds: 1));
  }

  bool get isFarAway {
    if (route.decodedPath == null) return true;
    if (location.locationData == null) return true;
    LatLng current = LatLng(
        location.locationData!.latitude!, location.locationData!.longitude!);
    return GeoUtils.isFarWayFromPath(current, route.decodedPath!);
  }

  double get walkedDistance {
    if (route.decodedPath == null) return 0.0;
    LatLng current = LatLng(
        location.locationData!.latitude!, location.locationData!.longitude!);
    double walked = GeoUtils.getWalkedLength(current, route.decodedPath!);
    return walked;
  }

  Stream<int> _timedCounter(Duration interval) {
    late StreamController<int> controller;
    Timer? timer;
    int counter = 0;

    void tick(_) {
      if (!isFarAway) {
        // close enough, start counting
        _isCounting = true;
      }
      if (_isCounting) {
        counter++;
        controller.add(counter);
      }
    }

    void startTimer() {
      timer = Timer.periodic(interval, tick);
    }

    void stopTimer() {
      timer?.cancel();
      timer = null;
    }

    controller = StreamController<int>.broadcast(
        onListen: startTimer, onCancel: stopTimer);

    return controller.stream;
  }
}
