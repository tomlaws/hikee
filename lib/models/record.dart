import 'package:hikees/models/map_marker.dart';
import 'package:hikees/models/region.dart';
import 'package:hikees/models/trail.dart';
import 'package:json_annotation/json_annotation.dart';

part 'record.g.dart';

@JsonSerializable()
class Record {
  int id;

  DateTime date;

  int time;

  String name;

  Region? region;

  Trail? referenceTrail;

  String userPath;

  List<MapMarker>? markers;

  Record(
      {required this.id,
      required this.time,
      this.region,
      required this.name,
      this.referenceTrail,
      required this.userPath,
      required this.date,
      this.markers});

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
  Map<String, dynamic> toJson() => _$RecordToJson(this);
}
