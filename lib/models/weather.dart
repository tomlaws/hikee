import 'package:hikee/models/temperature.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  final List<int> icon;
  final List<String> warningMessage;
  final int temperature;

  Weather(
      {required this.icon,
      required this.warningMessage,
      required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
