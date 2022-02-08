import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/providers/event.dart';

class TrailEventsController extends PaginationController<Paginated<Event>> {
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
