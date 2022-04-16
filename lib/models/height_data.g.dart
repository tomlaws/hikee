// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'height_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeightData _$HeightDataFromJson(Map<String, dynamic> json) {
  return HeightData(
    json['height'] as int,
    LatLng.fromJson(json['location'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HeightDataToJson(HeightData instance) =>
    <String, dynamic>{
      'height': instance.height,
      'location': instance.location,
    };
