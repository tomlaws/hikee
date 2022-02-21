// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapMarker _$MapMarkerFromJson(Map<String, dynamic> json) {
  return MapMarker(
    location: LatLng.fromJson(json['location'] as Map<String, dynamic>),
    title: json['title'] as String,
    color: const ColorConverter().fromJson(json['color'] as String),
    message: json['message'] as String?,
  );
}

Map<String, dynamic> _$MapMarkerToJson(MapMarker instance) => <String, dynamic>{
      'location': instance.location,
      'color': const ColorConverter().toJson(instance.color),
      'title': instance.title,
      'message': instance.message,
    };
