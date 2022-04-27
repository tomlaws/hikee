import 'package:json_annotation/json_annotation.dart';

part 'live.g.dart';

@JsonSerializable()
class Live {
  final int? id;
  final String? path;
  final int? hours;
  final String? secret;

  Live({this.id, this.path, this.hours, this.secret});

  factory Live.fromJson(Map<String, dynamic> json) => _$LiveFromJson(json);
  Map<String, dynamic> toJson() => _$LiveToJson(this);
}
