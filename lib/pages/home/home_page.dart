import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/keep_alive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    var pageView = PageView(
        controller: controller.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          5,
          (index) => KeepAlivePage(
              child: WillPopScope(
            onWillPop: () async {
              var state = Get.nestedKey(index)!.currentState!;
              if (state.canPop()) {
                state.pop();
                return false;
              }
              return true;
            },
            child: Navigator(
              key: Get.nestedKey(index),
              initialRoute: '/',
              onGenerateRoute: controller.onGenerateRoute,
            ),
          )),
        ));

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: pageView,
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(LineAwesomeIcons.compass), label: 'Compass'),
              BottomNavigationBarItem(
                  icon: Icon(LineAwesomeIcons.book_open), label: 'Routes'),
              BottomNavigationBarItem(
                  icon: Icon(LineAwesomeIcons.globe), label: 'Events'),
              BottomNavigationBarItem(
                  icon: Icon(LineAwesomeIcons.comments), label: 'Topics'),
              BottomNavigationBarItem(
                  icon: Icon(LineAwesomeIcons.user), label: 'Account')
            ],
            currentIndex: controller.currentTabIndex.value,
            onTap: (i) {
              controller.switchTab(i);
            },
          ),
        ));
  }
}
