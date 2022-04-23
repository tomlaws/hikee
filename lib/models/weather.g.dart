// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      icon: (json['icon'] as List<dynamic>).map((e) => e as int).toList(),
      warningMessage: (json['warningMessage'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      temperature: json['temperature'] as int,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'icon': instance.icon,
      'warningMessage': instance.warningMessage,
      'temperature': instance.temperature,
    };
