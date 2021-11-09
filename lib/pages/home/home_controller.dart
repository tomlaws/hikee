import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/pages/account/account_binding.dart';
import 'package:hikee/pages/account/old_account_page.dart';
import 'package:hikee/pages/account/events/account_events_binding.dart';
import 'package:hikee/pages/account/events/account_events_page.dart';
import 'package:hikee/pages/compass/compass_binding.dart';
import 'package:hikee/pages/compass/compass_page.dart';
import 'package:hikee/pages/events/events_binding.dart';
import 'package:hikee/pages/events/events_page.dart';
import 'package:hikee/pages/trails/trails_binding.dart';
import 'package:hikee/pages/trails/trails_page.dart';
import 'package:hikee/pages/topics/topics_binding.dart';
import 'package:hikee/pages/topics/topics_page.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  late PageController pageController;
  var currentTabIndex = 0.obs;

  final Map<int, Map<String, List<dynamic>>> routeMap = {
    0: {
      '/': [() => CompassPage(), CompassBinding()],
    },
    1: {
      '/': [() => TrailsPage(), TrailsBinding()],
    },
    2: {
      '/': [() => EventsPage(), EventsBinding()],
    },
    3: {
      '/': [() => TopicsPage(), TopicsBinding()],
    },
    4: {
      '/': [() => AccountPage(), AccountBinding()],
      '/events': [() => AccountEventsPage(), AccountEventsBinding()],
    }
  };

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

  Route? onGenerateRoute(RouteSettings settings) {
    List<dynamic> route = routeMap[currentTabIndex.value]![settings.name] ??
        routeMap[0]!.values.elementAt(0);
    Widget Function() page = route[0];
    Bindings binding = route[1];
    // https://github.com/jonataslaw/getx/issues/179
    Get.routing.args = settings.arguments;
    return GetPageRoute(
        settings: settings,
        page: page,
        binding: binding,
        transition: Transition.cupertino);
  }
}
