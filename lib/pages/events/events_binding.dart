import 'package:get/get.dart';
import 'package:hikees/pages/events/events_controller.dart';

class EventsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventsController());
  }
}
