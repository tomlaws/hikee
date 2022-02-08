import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/event_category.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/providers/event.dart';

class EventsController extends PaginationController<Paginated<Event>> {
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
