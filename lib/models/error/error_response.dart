import 'package:collection/collection.dart';
import 'package:hikees/models/error/field_error.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  int statusCode;
  dynamic message; // either List<FieldError> or String
  String? error;
  List<FieldError>? get fieldErrors {
    if (statusCode == 422 && message is List) {
      return (message as List).map((m) => FieldError.fromJson(m)).toList();
    } else {
      return null;
    }
  }

  String? getFieldError(String key) {
    var err = fieldErrors;
    if (err == null) {
      return null;
    }
    var message =
        err.firstWhereOrNull((element) => element.field == key)?.message ??
            null;
    return message;
  }

  ErrorResponse(
      {required this.statusCode, required this.message, required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
