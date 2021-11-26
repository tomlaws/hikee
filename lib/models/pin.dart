import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
part 'pin.g.dart';

@JsonSerializable()
class Pin {
  LatLng location;
  String? message;

  Pin({
    required this.location,
    this.message,
  });
  factory Pin.fromJson(Map<String, dynamic> json) => _$PinFromJson(json);
  Map<String, dynamic> toJson() => _$PinToJson(this);
}
