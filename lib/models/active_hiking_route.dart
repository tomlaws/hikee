import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/utils/geo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveHikingRoute extends ChangeNotifier {
  int _id = 0;
  int get id => _id;

  HikingRoute? _route;
  HikingRoute? get route => _route;

  List<LatLng>? _decodedPath;
  List<LatLng>? get decodedPath => _decodedPath;

  int? _startTime;
  int? get startTime => _startTime;
  bool get isStarted => _startTime != null;

  ActiveHikingRoute() {
    _loadRoute();
  }

  void update(HikingRoute? route) {
    _id++;
    this._route = route;
    if (route != null) {
      _decodedPath = GeoUtils.decodePath(route.path);
    }
    _saveRoute();
    notifyListeners();
  }

  _loadRoute() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('activeRoute')) {
        String? json = prefs.getString('activeRoute');
        if (json != null) {
          _route = HikingRoute.fromJson(jsonDecode(json));
          _decodedPath = GeoUtils.decodePath(route!.path);
          _startTime = prefs.getInt('startTime');
          notifyListeners();
        }
      }
    } catch (ex) {
      print(ex);
      _route = null;
    }
  }

  _saveRoute() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_route != null) {
        String encoded = jsonEncode(_route!.toJson());
        prefs.setString('activeRoute', encoded);
      }
    } catch (ex) {
      print(ex);
    }
  }

  startRoute() async {
    try {
      _startTime = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('startTime', _startTime!);
    } catch (ex) {
      print(ex);
    }
  }

  quitRoute() async {
    try {
      _route = null;
      _decodedPath = null;
      _startTime = null;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('startTime');
      prefs.remove('activeRoute');
    } catch (ex) {
      print(ex);
    }
  }
}
