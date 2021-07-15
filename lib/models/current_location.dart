import 'package:flutter/widgets.dart';
import 'package:location/location.dart';

class CurrentLocation extends ChangeNotifier {
  LocationData? _locationData;
  LocationData? get locationData => _locationData;

  CurrentLocation() {
    var location = Location();
    _first(location);
    Stream<LocationData> stream = location.onLocationChanged;
    stream.listen((LocationData currentLocation) {
      _locationData = currentLocation;
      notifyListeners();
    });
  }

  void _first(Location location) async {
    _locationData = await location.getLocation();
  }
}
