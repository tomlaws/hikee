import 'package:json_annotation/json_annotation.dart';

part 'record.g.dart';

@JsonSerializable()
class Record {
  int id;
  int time;
  String name;
  DateTime date;
  String userPath;
  List<double> altitudes;

  Record(
      {required this.id,
      required this.time,
      required this.name,
      required this.date,
      required this.userPath,
      required this.altitudes});

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
  Map<String, dynamic> toJson() => _$RecordToJson(this);
}
