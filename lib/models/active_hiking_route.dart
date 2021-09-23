import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/utils/geo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveHikingRoute {
  HikingRoute route;
  List<LatLng> decodedPath;

  int? startTime;
  bool get isStarted => startTime != null;

  ActiveHikingRoute(
      {required this.route, required this.decodedPath, this.startTime});
}
