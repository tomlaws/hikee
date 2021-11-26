import 'package:latlong2/latlong.dart';
import 'package:hikee/models/trail.dart';

class ActiveTrail {
  Trail trail;
  List<LatLng> decodedPath;

  int? startTime;
  bool get isStarted => startTime != null;

  ActiveTrail({required this.trail, required this.decodedPath, this.startTime});
}
