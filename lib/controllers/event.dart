import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/event_category.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/providers/event.dart';

class EventController extends GetxController with StateMixin<Event> {
  final _eventProvider = Get.put(EventProvider());

  @override
  void onInit() {
    super.onInit();
    append(
        () => () => _eventProvider.getEvent(int.parse(Get.parameters['id']!)));
  }
}
