import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  late PageController pageController;
  var currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentTabIndex.value);
  }

  void switchTab(int i) {
    pageController.jumpToPage(i);
    currentTabIndex.value = i;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
