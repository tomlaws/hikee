import 'package:latlong2/latlong.dart';
import 'package:json_annotation/json_annotation.dart';

part 'height_data.g.dart';

@JsonSerializable()
class HeightData {
  final int height;
  final LatLng location;

  HeightData(this.height, this.location);

  factory HeightData.fromJson(Map<String, dynamic> json) =>
      _$HeightDataFromJson(json);
  Map<String, dynamic> toJson() => _$HeightDataToJson(this);
}
