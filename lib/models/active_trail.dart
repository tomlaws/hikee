import 'package:hikee/models/elevation.dart';
import 'package:hikee/utils/geo.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/models/trail.dart';
import 'package:json_annotation/json_annotation.dart';

part 'active_trail.g.dart';

@JsonSerializable()
class ActiveTrail {
  Trail trail;
  List<LatLng> decodedPath;
  late List<LatLng> userPath;
  late List<double> userElevation;
  int? startTime;
  late List<Elevation> elevations;

  bool get isStarted => startTime != null;

  int get elapsed {
    if (startTime == null) return 0;
    int e = DateTime.now().millisecondsSinceEpoch -
        (startTime ?? DateTime.now().millisecondsSinceEpoch);
    return ((e / 1000).floor());
  }

  double get walkedDistance {
    return GeoUtils.getPathLength(path: userPath);
  }

  double get speed {
    if (elapsed == 0) return 0.0;
    var kmps = (walkedDistance / elapsed);
    var s = kmps * 3600;
    return s;
  }

  int get estimatedFinishTime {
    var kmps = (walkedDistance / elapsed);
    if (elapsed == 0.0 || kmps == 0.0 || kmps.isInfinite || kmps.isNaN)
      return trail.duration * 60;
    else {
      var remamingLength = trail.length - walkedDistance;
      return (remamingLength * 0.001 / kmps).round(); // in secs
    }
  }

  ActiveTrail(
      {required this.trail,
      required this.decodedPath,
      this.startTime,
      List<Elevation>? elevations}) {
    this.userPath = [];
    this.userElevation = [];
    this.elevations = elevations ?? [];
  }

  factory ActiveTrail.fromJson(Map<String, dynamic> json) =>
      _$ActiveTrailFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveTrailToJson(this);
}
