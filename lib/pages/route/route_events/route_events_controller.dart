import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/providers/event.dart';

class RouteEventsController extends PaginationController<Paginated<Event>> {
  final _eventProvider = Get.put(EventProvider());
  late int routeId;

  @override
  void onInit() {
    super.onInit();
    routeId = Get.arguments['id'];
  }

  @override
  Future<Paginated<Event>> fetch(Map<String, dynamic> query) {
    query['routeId'] = routeId.toString();
    return _eventProvider.getEvents(query);
  }
}
