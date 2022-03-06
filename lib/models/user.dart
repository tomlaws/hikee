import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String? email;
  final bool isPrivate;
  final String? _nickname;
  final String? icon;
  //
  final int? minutes;
  final int? trailCount;
  final int? meters;
  final int? eventCount;

  User(
      {required this.id,
      this.email,
      required this.isPrivate,
      required String? nickname,
      this.icon,
      this.minutes,
      this.trailCount,
      this.meters,
      this.eventCount})
      : _nickname = nickname;

  String get nickname {
    return _nickname ?? 'unnamed'.tr;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
