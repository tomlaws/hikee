import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/providers/event.dart';

class AccountEventsController extends PaginationController<Event>
    with GetSingleTickerProviderStateMixin {
  final _eventProvider = Get.put(EventProvider());
  int? _participantId;
  int? _organizerId;

  @override
  void onInit() {
    super.onInit();
    switchTab(0);
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Future<Paginated<Event>> fetch(Map<String, dynamic> query) {
    if (_participantId != null) {
      query['participantId'] = _participantId.toString();
    }
    if (_organizerId != null) {
      query['organizerId'] = _organizerId.toString();
    }
    return _eventProvider.getEvents(query);
  }

  void switchTab(int index) {
    if (index == 0) {
      _organizerId = null;
      _participantId = Get.find<AuthProvider>().me.value?.id;
    } else {
      _participantId = null;
      _organizerId = Get.find<AuthProvider>().me.value?.id;
    }
    refetch();
  }
}
