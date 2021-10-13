import 'package:get/get.dart';
import 'package:hikee/models/event_category.dart';
import 'package:hikee/providers/event.dart';

class EventCategoriesController extends GetxController
    with StateMixin<List<EventCategory>> {
  final _eventProvider = Get.put(EventProvider());
  @override
  void onInit() {
    super.onInit();
    append(() => _eventProvider.getCategories);
  }
}
