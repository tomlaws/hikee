import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/providers/event.dart';

class TrailEventsController extends PaginationController<Event> {
  final _eventProvider = Get.put(EventProvider());
  late int trailId;

  @override
  void onInit() {
    super.onInit();
    trailId = int.parse(Get.parameters['id']!);
  }

  @override
  Future<Paginated<Event>> fetch(Map<String, dynamic> query) {
    query['trailId'] = trailId.toString();
    return _eventProvider.getEvents(query);
  }
}
