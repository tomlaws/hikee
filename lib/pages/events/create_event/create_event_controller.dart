import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/pages/search/search_page.dart';
import 'package:hikees/pages/trails/trails_controller.dart';
import 'package:hikees/pages/trails/trails_filter.dart';
import 'package:hikees/providers/event.dart';
import 'package:hikees/providers/trail.dart';
import 'package:intl/intl.dart';

class CreateEventController extends GetxController {
  final _eventProvider = Get.put(EventProvider());
  final trailId = Rxn<int>();

  final TextInputController nameController = TextInputController();
  final TextInputController descriptionController = TextInputController();
  final TextInputController dateController = TextInputController();
  final TrailProvider trailProvider = Get.find<TrailProvider>();
  final dateTime = Rx(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters.containsKey('trailId'))
      trailId.value = int.parse(Get.parameters['trailId']!);
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }

  bool get canChangeTrail {
    return !Get.parameters.containsKey('trailId');
  }

  Future<Event> createEvent() async {
    var name = nameController.text;
    var description = descriptionController.text;
    var date = DateFormat('yyyy-MM-dd HH:mm').parse(dateController.text);
    var utcDate = date.toUtc();
    var event = await _eventProvider.createEvent(
        name: name,
        description: description,
        date: utcDate,
        trailId: trailId.value!);
    return event;
  }

  Future<void> pickTrail() async {
    Trail t = await Navigator.push(Get.context!,
        MaterialPageRoute(builder: (context) {
      return SearchPage<Trail, TrailsController>(
          tag: 'event-trail-picker',
          controller: TrailsController(),
          filter: TrailsFilter(),
          loadingWidget: TrailTile(trail: null),
          builder: (trail) => TrailTile(
                trail: trail,
                onTap: () {
                  Get.back(result: trail);
                },
              ));
    }));
    trailId.value = t.id;
  }
}
