import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/current_location.dart';
import 'package:hikee/utils/geo.dart';

class HikingStat extends ChangeNotifier {
  ActiveHikingRoute route;
  CurrentLocation location;
  Timer? timer;
  int elapsed = 0;

  HikingStat(this.route, this.location, {this.elapsed = 0}) {
    if (!route.isStarted) {
      elapsed = 0;
      timer = null;
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), tick);
    }
  }

  void update(ActiveHikingRoute route, CurrentLocation loc) {
    this.route = route;
    this.location = loc;
    if (!route.isStarted) {
      elapsed = 0;
      timer = null;
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), tick);
    }
  }

  bool get isFarAwayFromStart {
    if (location.location == null) {
      print('location null');
      return true;
    }
    LatLng current =
        LatLng(location.location!.latitude, location.location!.longitude);
    return GeoUtils.isFarWayFromPoint(current, route.decodedPath[0]);
  }

  double get walkedDistance {
    if (location.location == null) return 0.0;
    LatLng current =
        LatLng(location.location!.latitude, location.location!.longitude);
    double walked = GeoUtils.getWalkedLength(current, route.decodedPath);
    //print(current.toString());
    return walked;
  }

  void tick(_) {
    int s = DateTime.now().millisecondsSinceEpoch -
        (route.startTime ?? DateTime.now().millisecondsSinceEpoch);
    elapsed = ((s / 1000).floor());
    notifyListeners();
  }
}
