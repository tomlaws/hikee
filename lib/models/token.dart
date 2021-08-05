import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  String accessToken;
  String refreshToken;

  Token({required this.accessToken, required this.refreshToken});

  void updateAccessToken(String token) {
    this.accessToken = token;
  }

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
