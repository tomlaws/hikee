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
import 'package:hikee/pages/routes/featured_route_controller.dart';
import 'package:hikee/pages/routes/popular_routes_controller.dart';
import 'package:hikee/pages/routes/routes_page.dart';
import 'package:hikee/pages/topics/topics_controller.dart';
import 'package:hikee/pages/topics/topics_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
    Get.lazyPut(() => PopularRoutesController());
    Get.lazyPut(() => FeaturedRouteController());
    Get.lazyPut(() => EventsController());
    Get.lazyPut(() => EventCategoriesController());
    Get.lazyPut(() => TopicsController());
    Get.lazyPut(() => AccountController());
    pageView = PageView(
        controller: controller.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          KeepAlivePage(child: CompassPage()),
          RoutesPage(),
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
