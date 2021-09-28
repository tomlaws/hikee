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

  void setJoined(bool joined) {
    if (state == null) return;
    state!.joined = joined;
    state!.participantCount += joined ? 1 : -1;
    change(state, status: RxStatus.success());
  }
}
