import 'package:flutter/material.dart';
import 'package:hikees/utils/color.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_marker.g.dart';

@JsonSerializable()
@ColorConverter()
class MapMarker {
  late List<double> location;
  Color? color;
  String title;
  String? message;

  MapMarker(
      {List<double>? location,
      LatLng? locationInLatLng,
      required this.title,
      this.color = Colors.indigo,
      this.message}) {
    assert(location != null || locationInLatLng != null);
    if (location != null) {
      this.location = location;
    } else {
      this.location = [locationInLatLng!.longitude, locationInLatLng.latitude];
    }
  }

  LatLng get locationInLatLng {
    return LatLng(location[1], location[0]);
  }

  factory MapMarker.fromJson(Map<String, dynamic> json) =>
      _$MapMarkerFromJson(json);
  Map<String, dynamic> toJson() => _$MapMarkerToJson(this);
}
