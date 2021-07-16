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

  HikingStat(this.route, this.location) {
    // timer
    id = route.id;
    if (route.isStarted) {
      _clockStream = _timedCounter(const Duration(seconds: 1));
    }
  }

  bool get isFarAwayFromStart {
    if (route.decodedPath == null) return true;
    if (location.locationData == null) return true;
    LatLng current = LatLng(
        location.locationData!.latitude!, location.locationData!.longitude!);
    return GeoUtils.isFarWayFromPoint(current, route.decodedPath![0]);
  }

  double get walkedDistance {
    if (route.decodedPath == null) return 0.0;
    if (location.locationData == null) return 0.0;
    LatLng current = LatLng(
        location.locationData!.latitude!, location.locationData!.longitude!);
    double walked = GeoUtils.getWalkedLength(current, route.decodedPath!);
    print(current.toString());
    return walked;
  }

  Stream<int> _timedCounter(Duration interval) {
    late StreamController<int> controller;
    Timer? timer;

    void tick(_) {
      int elapsed = DateTime.now().millisecondsSinceEpoch -
          (route.startTime ?? DateTime.now().millisecondsSinceEpoch);
      controller.add((elapsed / 1000).floor());
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
