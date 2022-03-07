import 'package:get/get.dart';
import 'package:hikees/pages/events/create_event/create_event_controller.dart';

class CreateEventBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateEventController());
  }
}
