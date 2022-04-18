import 'package:hikees/models/map_marker.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/models/region.dart';

class OfflineRecord extends Record {
  int dateInMs; // Store to sqlite

  int? regionId;

  int? referenceTrailId;

  OfflineRecord(
      {required int id,
      required int time,
      required DateTime date,
      required this.regionId,
      required String name,
      this.referenceTrailId,
      required String userPath,
      List<MapMarker>? markers})
      : dateInMs = date.millisecondsSinceEpoch,
        super(
            id: id,
            time: time,
            name: name,
            region: Region.getRegionById(regionId!),
            userPath: userPath,
            date: date,
            markers: markers);
}
