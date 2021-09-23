import 'package:flutter/material.dart';
import 'package:hikee/old_providers/locale.dart';
import 'package:hikee/riverpods/locale.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';

class Region {
  final int id;
  final String name_zh;
  final String name_en;

  Region(
    this.id,
    this.name_zh,
    this.name_en,
  );

  Region.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name_zh = json['name_zh'],
        name_en = json['name_en'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_zh': name_zh,
        'name_en': name_en,
      };
  String name(WidgetRef ref) {
    var l = ref.read(localeProvider);
    if (l == Locale('en')) {
      return name_en;
    } else {
      return name_zh;
    }
  }
}
