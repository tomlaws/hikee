import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/keep_alive.dart';
import 'package:hikee/pages/events/event_categories.dart';
import 'package:hikee/pages/account/account_controller.dart';
import 'package:hikee/pages/account/account_page.dart';
import 'package:hikee/pages/compass/compass_controller.dart';
import 'package:hikee/pages/compass/compass_page.dart';
import 'package:hikee/pages/compass/weather_controller.dart';
import 'package:hikee/pages/events/events_controller.dart';
import 'package:hikee/pages/events/events_page.dart';
import 'package:hikee/pages/trails/featured_trail_controller.dart';
import 'package:hikee/pages/trails/popular_trails_controller.dart';
import 'package:hikee/pages/trails/trails_page.dart';
import 'package:hikee/pages/topics/topics_controller.dart';
import 'package:hikee/pages/topics/topics_page.dart';
import 'package:hikee/providers/active_trail.dart';
import 'package:hikee/providers/auth.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  final _authProvider = Get.find<AuthProvider>();
  final _activeTrailProvider = Get.put(ActiveTrailProvider());

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CompassController());
    Get.lazyPut(() => WeatherController());
    Get.lazyPut(() => PopularTrailsController());
    Get.lazyPut(() => FeaturedTrailController());
    Get.lazyPut(() => EventsController());
    Get.lazyPut(() => EventCategoriesController());
    Get.lazyPut(() => TopicsController());
    Get.lazyPut(() => AccountController());
    var tabs = [
      KeepAlivePage(child: CompassPage()),
      TrailsPage(),
      EventsPage(),
      TopicsPage(),
      AccountPage()
    ];
    var pageView = PageView.builder(
        controller: controller.pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tabs.length,
        onPageChanged: (i) {
          if (i == 0)
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        },
        itemBuilder: (context, index) => tabs[index]);
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Obx(() {
          // ensures rebuild everything if login state changed
          var loggedIn = _authProvider.loggedIn.value;
          return pageView;
        }),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 0
                      ? Icons.explore
                      : Icons.explore_outlined),
                  label: 'navigation'.tr),
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 1
                      ? Icons.menu_book
                      : Icons.menu_book_outlined),
                  label: 'trails'.tr),
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 2
                      ? Icons.public
                      : Icons.public_outlined),
                  label: 'events'.tr),
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 3
                      ? Icons.sms
                      : Icons.sms_outlined),
                  label: 'topics'.tr),
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 4
                      ? Icons.account_box
                      : Icons.account_box_outlined),
                  label: 'account'.tr)
            ],
            currentIndex: controller.currentTabIndex.value,
            onTap: (i) {
              controller.switchTab(i);
            },
          ),
        ));
  }
}
