import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  static HomeController get to => Get.find();
  late PageController pageController;
  var currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentTabIndex.value);
    WidgetsBinding.instance?.addObserver(this);
  }

  void switchTab(int i) {
    pageController.jumpToPage(i);
    currentTabIndex.value = i;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }
}
