import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  static HomeController get to => Get.find();
  late PageController pageController;
  var currentTabIndex = 0.obs;
  late StreamSubscription _sub;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentTabIndex.value);
    WidgetsBinding.instance?.addObserver(this);
    // app links
    getInitialUri().then((uri) {
      if (uri != null) handleAppLink(uri);
    });
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleAppLink(uri);
      }
    }, onError: (err) {});
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
    _sub.cancel();
    super.onClose();
  }

  void handleAppLink(Uri link) {
    RegExp regExp = new RegExp(r'/(\w+)/(\d+)');
    if (link.path.length == 0) return;
    print('deep link detected');
    print(link.path);
    var matches = regExp.allMatches(link.path);
    if (matches.length > 0) {
      var m = matches.elementAt(0);
      if (m.groupCount == 2) {
        var res = m.group(1);
        var id = m.group(2);
        if (int.tryParse(id ?? '') == null) return;
        if (res == 'trails') {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            HomeController hc = Get.find<HomeController>();
            hc.switchTab(1);
            Get.toNamed('/trails/$id');
          });
        }
      }
    }
  }
}
