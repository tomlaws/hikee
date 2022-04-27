import 'package:hikees/models/height_data.dart';
import 'package:hikees/models/live.dart';
import 'package:hikees/models/map_marker.dart';
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

  int? referenceTrailId;
  int? originalLength;
  int? originalDuration;
  List<LatLng>? originalPath;
  List<HeightData>? originalHeights;

  Live? live;

  bool offline;

  bool get isStarted => startTime != null;

  // in sec
  int get elapsed {
    if (startTime == null) return 0;
    int e = DateTime.now().millisecondsSinceEpoch -
        (startTime ?? DateTime.now().millisecondsSinceEpoch);
    return ((e / 1000).floor());
  }

  // in meters
  int get length {
    return GeoUtils.getPathLength(path: userPath);
  }

  // meters/second
  int get speed {
    if (elapsed == 0) return 0;
    var mps = (length / elapsed).floor();
    var mph = mps * 3600;
    return mph;
  }

  // in second
  int get estimatedFinishTime {
    if (originalLength == null || originalDuration == null) return 0;
    if (elapsed == 0.0) return originalDuration! * 60;
    var mps = (length / elapsed).floor();
    if (mps == 0.0 || mps.isInfinite || mps.isNaN)
      return originalDuration! * 60;
    else {
      var remamingLength = originalLength! - length;
      return (remamingLength / mps).round(); // in secs
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

  ActiveTrail(
      {this.name,
      this.regionId,
      this.startTime,
      List<LatLng>? userPath,
      this.referenceTrailId,
      this.originalPath,
      this.offline = false})
      : userPath = userPath ?? [],
        userHeights = [],
        markers = [] {
    GeoUtils.getHeights(this.userPath)
        .then((value) => this.userHeights = value);
    if (this.originalPath != null) {
      GeoUtils.getHeights(originalPath!)
          .then((value) => this.originalHeights = value);
      GeoUtils.calculateLengthAndDuration(originalPath!).then((value) {
        this.originalLength = value.item1;
        this.originalDuration = value.item2;
      });
    }
  }
  factory ActiveTrail.fromJson(Map<String, dynamic> json) =>
      _$ActiveTrailFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveTrailToJson(this);
}
