
import 'package:json_annotation/json_annotation.dart';

part 'temperature.g.dart';
@JsonSerializable()
class Temperature {
  final String place;
  final double value;
  Temperature({required this.place, required this.value});

   factory Temperature.fromJson(Map<String, dynamic> json) => _$TemperatureFromJson(json);
  Map<String, dynamic> toJson() => _$TemperatureToJson(this);
}
