import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/event_category.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/providers/event.dart';

class EventsController extends PaginationController<Event> {
  final _eventProvider = Get.put(EventProvider());
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    next();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  @override
  Future<Paginated<Event>> fetch(Map<String, dynamic> query) {
    return _eventProvider.getEvents(query);
  }

  Future<List<EventCategory>> getEventCategories() async {
    return _eventProvider.getCategories();
  }
}
