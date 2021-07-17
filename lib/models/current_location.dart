import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/utils/geo.dart';
import 'package:location/location.dart';

class CurrentLocation extends ChangeNotifier {
  LocationData? _locationData;
  LocationData? get locationData => _locationData;

  CurrentLocation() {
    var location = Location();
    _first(location);
    Stream<LocationData> stream = location.onLocationChanged;
    stream.listen((LocationData currentLocation) {
      var notify = false;
      if (_locationData == null) {
        notify = true;
      }
      if (notify ||
          currentLocation.latitude != _locationData?.latitude ||
          currentLocation.longitude != _locationData?.longitude) {
        _locationData = currentLocation;
        notifyListeners();
        print('notify');
      }
    });
  }

  void _first(Location location) async {
    _locationData = await GeoUtils.getCurrentLocation();
  }

  LatLng? get location {
    if (_locationData == null) return null;
    return LatLng(_locationData!.latitude!, locationData!.longitude!);
  }
}
