import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/keep_alive.dart';
import 'package:hikee/controllers/shared/auth.dart';
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

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  final _authController = Get.put(AuthController());

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
    Get.lazyPut(() => CompassController());
    Get.lazyPut(() => WeatherController());
    Get.lazyPut(() => PopularTrailsController());
    Get.lazyPut(() => FeaturedTrailController());
    Get.lazyPut(() => EventsController());
    Get.lazyPut(() => EventCategoriesController());
    Get.lazyPut(() => TopicsController());
    Get.lazyPut(() => AccountController());
    pageView = PageView(
        controller: controller.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          KeepAlivePage(child: CompassPage()),
          TrailsPage(),
          EventsPage(),
          TopicsPage(),
          AccountPage()
        ]);
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Obx(() {
          // ensures rebuild everything if login state changed
          var loggedIn = _authController.loggedIn.value;
          return pageView;
        }),
        // bottomNavigationBar: Container(
        //     color: Colors.white,
        //     padding: EdgeInsets.all(20.0),
        //     child: Obx(
        //       () => Row(
        //         crossAxisAlignment: CrossAxisAlignment.center, // Optional
        //         mainAxisAlignment:
        //             MainAxisAlignment.spaceEvenly, // Change to your own spacing
        //         children: [
        //           IconButton(
        //               onPressed: () {
        //                 controller.switchTab(0);
        //               },
        //               icon: Icon(
        //                   controller.currentTabIndex.value == 0
        //                       ? Icons.explore
        //                       : Icons.explore_outlined,
        //                   color: controller.currentTabIndex.value == 0
        //                       ? Get.theme.primaryColor
        //                       : Colors.black26)),
        //           IconButton(
        //             onPressed: () {
        //               controller.switchTab(1);
        //             },
        //             icon: Icon(
        //                 controller.currentTabIndex.value == 1
        //                     ? Icons.menu_book
        //                     : Icons.menu_book_outlined,
        //                 color: controller.currentTabIndex.value == 1
        //                     ? Get.theme.primaryColor
        //                     : Colors.black26),
        //           ),
        //           IconButton(
        //             onPressed: () {
        //               controller.switchTab(2);
        //             },
        //             icon: Icon(
        //                 controller.currentTabIndex.value == 2
        //                     ? Icons.public
        //                     : Icons.public_outlined,
        //                 color: controller.currentTabIndex.value == 2
        //                     ? Get.theme.primaryColor
        //                     : Colors.black26),
        //           ),
        //           IconButton(
        //             onPressed: () {
        //               controller.switchTab(3);
        //             },
        //             icon: Icon(
        //                 controller.currentTabIndex.value == 3
        //                     ? Icons.sms
        //                     : Icons.sms_outlined,
        //                 color: controller.currentTabIndex.value == 3
        //                     ? Get.theme.primaryColor
        //                     : Colors.black26),
        //           ),
        //           IconButton(
        //             onPressed: () {
        //               controller.switchTab(4);
        //             },
        //             icon: Icon(
        //                 controller.currentTabIndex.value == 4
        //                     ? Icons.account_box
        //                     : Icons.account_box_outlined,
        //                 color: controller.currentTabIndex.value == 4
        //                     ? Get.theme.primaryColor
        //                     : Colors.black26),
        //           )
        //         ],
        //       ),
        //     )),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 0
                      ? Icons.explore
                      : Icons.explore_outlined),
                  label: 'Compass'),
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 1
                      ? Icons.menu_book
                      : Icons.menu_book_outlined),
                  label: 'Trails'),
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 2
                      ? Icons.public
                      : Icons.public_outlined),
                  label: 'Events'),
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 3
                      ? Icons.sms
                      : Icons.sms_outlined),
                  label: 'Topics'),
              BottomNavigationBarItem(
                  icon: Icon(controller.currentTabIndex.value == 4
                      ? Icons.account_box
                      : Icons.account_box_outlined),
                  label: 'Account')
            ],
            currentIndex: controller.currentTabIndex.value,
            onTap: (i) {
              controller.switchTab(i);
            },
          ),
        ));
  }
}
