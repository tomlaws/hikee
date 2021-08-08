// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldError _$FieldErrorFromJson(Map<String, dynamic> json) {
  return FieldError(
    field: json['field'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$FieldErrorToJson(FieldError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
    };
