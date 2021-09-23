import 'package:get/get.dart';
import 'package:hikee/providers/event.dart';
import 'package:hikee/models/event.dart';

class EventController extends GetxController with StateMixin<Event> {
  final _eventProvider = Get.put(EventProvider());
  late int id;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    append(() => () => _eventProvider.getEvent(id));
  }

  Future<Event> joinEvent() async {
    Event e = await _eventProvider.joinEvent(id);
    change(e, status: RxStatus.success());
    return e;
  }

  Future<Event> quitEvent() async {
    Event e = await _eventProvider.quitEvent(id);
    change(e, status: RxStatus.success());
    return e;
  }
}
