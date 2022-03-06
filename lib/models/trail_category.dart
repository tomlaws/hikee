import 'package:get/get.dart';
import 'package:hikee/utils/lang.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trail_category.g.dart';

@JsonSerializable()
class TrailCategory {
  final int id;
  final String name_zh;
  final String name_en;

  get name {
    if (Get.locale?.languageCode.toLowerCase() == 'zh') {
      if (Get.locale?.countryCode == 'CN') {
        return LangUtils.tcToSc(name_zh);
      }
      return name_zh;
    }
    return name_en;
  }

  TrailCategory(
      {required this.id, required this.name_zh, required this.name_en});

  factory TrailCategory.fromJson(Map<String, dynamic> json) =>
      _$TrailCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$TrailCategoryToJson(this);
}
