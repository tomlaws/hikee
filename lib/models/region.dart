import 'package:flutter/material.dart';

class Region {
  final int id;
  final String name_zh;
  final String name_en;

  Region({
    required this.id,
    required this.name_zh,
    required this.name_en,
  });

  Region.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name_zh = json['name_zh'],
        name_en = json['name_en'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_zh': name_zh,
        'name_en': name_en,
      };
  // String name(WidgetRef ref) {
  //   var l = ref.read(localeProvider);
  //   if (l == Locale('en')) {
  //     return name_en;
  //   } else {
  //     return name_zh;
  //   }
  // }

  static Set<Region> allRegions() {
    return {
      Region(id: 1, name_zh: "新界北區", name_en: "North New Territories"),
      Region(id: 2, name_zh: "港島區", name_en: "Hong Kong Island"),
      Region(id: 3, name_zh: "新界中區", name_en: "Central New Territories"),
      Region(id: 4, name_zh: "西貢區", name_en: "Sai Kung"),
      Region(id: 5, name_zh: "新界西區", name_en: "West New Territories"),
      Region(id: 6, name_zh: "大嶼山區", name_en: "Lantau")
    };
  }
}
