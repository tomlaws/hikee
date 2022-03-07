import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikees/models/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends GetLifeCycle {
  final preferences = Rxn<Preferences>(null);

  @override
  void onInit() {
    super.onInit();
    preferences.listen((p) {
      if (p != null) {
        if (p.locale != Get.locale) {
          Get.updateLocale(p.locale);
        }
        _save();
      }
    });
    _load();
  }

  @override
  void onClose() {
    preferences.close();
    super.onClose();
  }

  Future<void> _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('preferences', jsonEncode(preferences));
  }

  Future<void> _load() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final config = prefs.getString('preferences');
      preferences.value = Preferences.fromJson(jsonDecode(config!));
    } catch (ex) {
      preferences.value = Preferences.defaultPreferences();
    }
  }
}
