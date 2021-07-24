import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends ChangeNotifier {
  LatLng? _location;
  LatLng? get location => _location;

  StreamController<LatLng> _onLocationChanged =
      StreamController.broadcast();
  Stream get onLocationChanged => _onLocationChanged.stream;

  late StreamSubscription<Position> _positionStream;

  CurrentLocation() {
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      LatLng? current;
      current = LatLng(position.latitude, position.longitude);
      if (_location == null ||
          _location!.latitude != current.latitude ||
          _location!.longitude != current.longitude) {
        _location = current;
        if (_location != null) _onLocationChanged.add(_location!);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _onLocationChanged.close();
    _positionStream.cancel();
    super.dispose();
  }
}
