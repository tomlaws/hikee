// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pin _$PinFromJson(Map<String, dynamic> json) => Pin(
      location: LatLng.fromJson(json['location'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PinToJson(Pin instance) => <String, dynamic>{
      'location': instance.location,
      'message': instance.message,
    };
