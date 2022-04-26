import 'package:get/get.dart';
import 'package:hikees/utils/lang.dart';
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

  static final all = [
    TrailCategory(id: 1, name_zh: "長途遠足徑", name_en: "Long-distance Trail"),
    TrailCategory(id: 2, name_zh: "郊遊徑", name_en: "Country Trail"),
    TrailCategory(id: 3, name_zh: "家樂徑", name_en: "Family Walk"),
    TrailCategory(id: 4, name_zh: "樹木研習徑", name_en: "Tree Walk"),
    TrailCategory(id: 5, name_zh: "自然教育徑", name_en: "Nature Trail"),
    TrailCategory(id: 6, name_zh: "地質步道", name_en: "Geo Route"),
    TrailCategory(id: 7, name_zh: "特色路徑", name_en: "Recommended Route"),
  ];

  factory TrailCategory.fromJson(Map<String, dynamic> json) =>
      _$TrailCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$TrailCategoryToJson(this);
}
