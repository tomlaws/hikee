import 'package:hikee/models/reference_trail.dart';
import 'package:hikee/utils/geo.dart';
import 'package:latlong2/latlong.dart';
import 'package:json_annotation/json_annotation.dart';

part 'active_trail.g.dart';

@JsonSerializable()
class ActiveTrail {
  ReferenceTrail? trail;
  String? name;
  late List<LatLng> userPath;
  late List<double> userElevation;
  int? startTime;

  bool get isStarted => startTime != null;

  int get elapsed {
    if (startTime == null) return 0;
    int e = DateTime.now().millisecondsSinceEpoch -
        (startTime ?? DateTime.now().millisecondsSinceEpoch);
    return ((e / 1000).floor());
  }

  // in km
  double get length {
    return GeoUtils.getPathLength(path: userPath);
  }

  double get speed {
    if (elapsed == 0) return 0.0;
    var kmps = (length / elapsed);
    var s = kmps * 3600;
    return s;
  }

  int get estimatedFinishTime {
    if (trail == null) return 0;
    var kmps = (length / elapsed);
    if (elapsed == 0.0 || kmps == 0.0 || kmps.isInfinite || kmps.isNaN)
      return trail!.duration * 60;
    else {
      var remamingLength = trail!.length - length;
      return (remamingLength * 0.001 / kmps).round(); // in secs
    }
  }

  ActiveTrail({this.trail, this.startTime}) {
    this.userPath = [];
    this.userElevation = [];
  }

  factory ActiveTrail.fromJson(Map<String, dynamic> json) =>
      _$ActiveTrailFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveTrailToJson(this);
}
