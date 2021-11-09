import 'package:get/get.dart';
import 'package:hikee/pages/trail/trail_events/trail_events_controller.dart';

class TrailEventsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrailEventsController());
  }
}
