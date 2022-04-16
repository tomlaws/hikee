import 'package:hikees/models/height_data.dart';
import 'package:hikees/models/map_marker.dart';
import 'package:hikees/models/reference_trail.dart';
import 'package:hikees/utils/geo.dart';
import 'package:latlong2/latlong.dart';
import 'package:json_annotation/json_annotation.dart';

part 'active_trail.g.dart';

@JsonSerializable()
class ActiveTrail {
  String? name;
  List<LatLng> userPath;
  List<HeightData> userHeights;
  List<MapMarker> markers;
  int? startTime;
  int? regionId;
  ReferenceTrail? trail;

  bool get isStarted => startTime != null;

  int get elapsed {
    if (startTime == null) return 0;
    int e = DateTime.now().millisecondsSinceEpoch -
        (startTime ?? DateTime.now().millisecondsSinceEpoch);
    return ((e / 1000).floor());
  }

  // in m
  int get length {
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

  Future<void> addPoint(LatLng point) async {
    try {
      List<HeightData> heights = await GeoUtils.getHeights([point]);
      userPath.add(point);
      userHeights.add(heights.first);
    } catch (ex) {
      print(ex);
    }
  }

  ActiveTrail({this.trail, this.name, this.regionId, this.startTime})
      : userPath = [],
        userHeights = [],
        markers = [];
  factory ActiveTrail.fromJson(Map<String, dynamic> json) =>
      _$ActiveTrailFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveTrailToJson(this);
}
