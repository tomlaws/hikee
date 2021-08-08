import 'package:json_annotation/json_annotation.dart';

part 'field_error.g.dart';

@JsonSerializable()
class FieldError {
  String field;
  String message;

  FieldError({required this.field, required this.message});

  factory FieldError.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorFromJson(json);
  Map<String, dynamic> toJson() => _$FieldErrorToJson(this);
}