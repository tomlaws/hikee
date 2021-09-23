import 'package:get/get.dart';
import 'package:hikee/pages/event/event_controller.dart';

class EventBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventController());
  }
}
