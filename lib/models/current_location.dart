import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CurrentLocation extends ChangeNotifier {
  LocationData? _locationData;
  LocationData? get locationData => _locationData;
  late Stream<LocationData> _stream;
  Stream<LocationData> get stream => _stream;

  CurrentLocation() {
    var location = Location();
    _stream = location.onLocationChanged;
    _stream.listen((LocationData currentLocation) {
      var notify = false;
      if (_locationData == null) {
        notify = true;
      }
      if (notify ||
          currentLocation.latitude != _locationData?.latitude ||
          currentLocation.longitude != _locationData?.longitude) {
        _locationData = currentLocation;
        notifyListeners();
      }
    });
  }


  LatLng? get location {
    if (_locationData == null) return null;
    return LatLng(_locationData!.latitude!, locationData!.longitude!);
  }
}
