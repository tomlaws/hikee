import 'package:hikee/pages/events/event_categories.dart';
import 'package:get/get.dart';
import 'package:hikee/pages/events/events_controller.dart';

class EventsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventsController());
    Get.lazyPut(() => EventCategoriesController());
  }
}
