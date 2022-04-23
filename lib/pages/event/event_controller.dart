import 'package:get/get.dart';
import 'package:hikees/pages/account/events/account_events_controller.dart';
import 'package:hikees/providers/event.dart';
import 'package:hikees/models/event.dart';

class EventController extends GetxController with StateMixin<Event> {
  final _eventProvider = Get.put(EventProvider());
  late int id;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['trailId'] ?? Get.arguments['id'];
    append(() => _loadEvent);
  }

  void setJoined(bool joined) {
    if (state == null) return;
    state!.joined = joined;
    state!.participantCount += joined ? 1 : -1;
    change(state, status: RxStatus.success());
    //
    try {
      final accountEventsController = Get.find<AccountEventsController>();
      accountEventsController.refetch();
    } catch (ex) {}
  }

  Future<Event> _loadEvent() async {
    return _eventProvider.getEvent(id);
  }

  void refreshEvent() {
    change(null, status: RxStatus.loading());
    append(() => _loadEvent);
  }
}
