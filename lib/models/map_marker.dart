import 'package:flutter/widgets.dart';
import 'package:hikee/utils/color.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_marker.g.dart';

@JsonSerializable()
@ColorConverter()
class MapMarker {
  LatLng location;
  Color color;
  String title;
  String? message;

  MapMarker(
      {required this.location,
      required this.title,
      required this.color,
      this.message});

  factory MapMarker.fromJson(Map<String, dynamic> json) =>
      _$MapMarkerFromJson(json);
  Map<String, dynamic> toJson() => _$MapMarkerToJson(this);
}
