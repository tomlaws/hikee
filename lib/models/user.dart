import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String email;
  final String? _nickname;
  final String? icon;

  User(
      {required this.id,
      required this.email,
      required String? nickname,
      this.icon})
      : _nickname = nickname;

  String get nickname {
    return _nickname ?? 'Unnamed';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
