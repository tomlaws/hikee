import 'package:get/get.dart';
import 'package:hikee/pages/route/route_events/route_events_controller.dart';

class RouteEventsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RouteEventsController());
  }
}
