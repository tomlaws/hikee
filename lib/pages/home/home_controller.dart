import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/components/event_tile.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/pages/account/account_binding.dart';
import 'package:hikee/pages/account/account_page.dart';
import 'package:hikee/pages/account/events/account_events_binding.dart';
import 'package:hikee/pages/account/events/account_events_page.dart';
import 'package:hikee/pages/compass/compass_binding.dart';
import 'package:hikee/pages/compass/compass_page.dart';
import 'package:hikee/pages/event/event_binding.dart';
import 'package:hikee/pages/event/event_page.dart';
import 'package:hikee/pages/events/events_binding.dart';
import 'package:hikee/pages/events/events_controller.dart';
import 'package:hikee/pages/events/events_page.dart';
import 'package:hikee/pages/route/route_binding.dart';
import 'package:hikee/pages/route/route_events/route_events_binding.dart';
import 'package:hikee/pages/route/route_events/route_events_page.dart';
import 'package:hikee/pages/route/route_page.dart';
import 'package:hikee/pages/routes/routes_binding.dart';
import 'package:hikee/pages/routes/routes_controller.dart';
import 'package:hikee/pages/routes/routes_page.dart';
import 'package:hikee/pages/search/search_binding.dart';
import 'package:hikee/pages/search/search_page.dart';
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
      '/': [() => RoutesPage(), RoutesBinding()],
      // '/route': [() => RoutePage(), RouteBinding()],
      // '/route-events': [() => RouteEventsPage(), RouteEventsBinding()],
      '/search': [
        () => SearchPage<RoutesController, HikingRoute>(
              key: Key('routes'),
              builder: (route) => HikingRouteTile(route: route),
              controllerBuilder: () => RoutesController(),
            ),
        SearchBinding()
      ],
    },
    2: {
      '/': [() => EventsPage(), EventsBinding()],
      //'/event': [() => EventPage(), EventBinding()],
      '/search': [
        () => SearchPage<EventsController, Event>(
              key: Key('events'),
              builder: (event) => EventTile(event: event),
              controllerBuilder: () => EventsController(),
            ),
        SearchBinding()
      ],
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
    // pageController.addListener(() {
    //   currentTabIndex.value =
    //       pageController.page?.round() ?? currentTabIndex.value;
    // });
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
