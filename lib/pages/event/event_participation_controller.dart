import 'package:get/get.dart';

import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/event_participation.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/providers/event.dart';

class EventParticipationController
    extends PaginationController<EventParticipation> {
  final _eventProvider = Get.put(EventProvider());
  late int id;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
  }

  @override
  Future<Paginated<EventParticipation>> fetch(Map<String, dynamic> query) {
    return _eventProvider.getParticipation(id);
  }

  Future<EventParticipation> joinEvent() async {
    EventParticipation e = await _eventProvider.joinEvent(id);
    refetch();
    return e;
  }

  Future<EventParticipation> quitEvent() async {
    EventParticipation e = await _eventProvider.quitEvent(id);
    refetch();
    return e;
  }
}
