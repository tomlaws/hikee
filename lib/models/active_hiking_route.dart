import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/utils/geo.dart';

class ActiveHikingRoute extends ChangeNotifier {
  int _id = 0;
  HikingRoute? _route;
  int get id => _id;
  HikingRoute? get route => _route;

  List<LatLng>? _decodedPath;
  List<LatLng>? get decodedPath => _decodedPath;

  void update(HikingRoute? route) {
    _id++;
    this._route = route;
    if (route != null) _decodedPath = GeoUtils.decodePath(route.path);
    notifyListeners();
  }
}
