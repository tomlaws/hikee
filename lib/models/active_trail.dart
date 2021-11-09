import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/utils/geo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveTrail {
  Trail trail;
  List<LatLng> decodedPath;

  int? startTime;
  bool get isStarted => startTime != null;

  ActiveTrail({required this.trail, required this.decodedPath, this.startTime});
}
