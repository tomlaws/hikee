// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapMarker _$MapMarkerFromJson(Map<String, dynamic> json) => MapMarker(
      location: (json['location'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      locationInLatLng: json['locationInLatLng'] == null
          ? null
          : LatLng.fromJson(json['locationInLatLng'] as Map<String, dynamic>),
      title: json['title'] as String,
      color: json['color'] == null
          ? Colors.indigo
          : const ColorConverter().fromJson(json['color'] as String?),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MapMarkerToJson(MapMarker instance) => <String, dynamic>{
      'location': instance.location,
      'color': const ColorConverter().toJson(instance.color),
      'title': instance.title,
      'message': instance.message,
      'locationInLatLng': instance.locationInLatLng,
    };
