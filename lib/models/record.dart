import 'package:hikee/models/route.dart';
import 'package:json_annotation/json_annotation.dart';

part 'record.g.dart';

@JsonSerializable()
class Record {
  int id;
  int time;
  DateTime date;
  HikingRoute route;

  Record(
      {required this.id,
      required this.time,
      required this.date,
      required this.route});

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
  Map<String, dynamic> toJson() => _$RecordToJson(this);
}
