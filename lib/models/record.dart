import 'package:hikee/models/trail.dart';
import 'package:json_annotation/json_annotation.dart';

part 'record.g.dart';

@JsonSerializable()
class Record {
  int id;
  DateTime date;
  int time;
  String name;
  Trail? referenceTrail;
  String userPath;
  List<double> altitudes;

  Record({
    required this.id,
    required this.time,
    required this.name,
    this.referenceTrail,
    required this.userPath,
    required this.altitudes,
    required this.date,
  });

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
  Map<String, dynamic> toJson() => _$RecordToJson(this);
}
