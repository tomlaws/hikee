import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchController<U> extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final searched = false.obs;
  final showHistory = true.obs;
  RxList<String> history = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    searchController.text = '';
    searchController.addListener(() {
      showHistory.value = searchController.text.length == 0;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void loadHistory(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(key) ?? [];
    history.value = list;
  }

  void addHistory(String key, String q) async {
    var list = history;
    List<String> newList = list.toList();
    newList.remove(q);
    newList.insert(0, q);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, newList);
    newList = newList.take(10).toList();
    history.value = newList;
  }
}
