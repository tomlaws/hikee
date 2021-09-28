import 'package:get/get.dart';

import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/event_participation.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/event.dart';

class EventParticipationController
    extends PaginationController<Paginated<EventParticipation>> {
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
