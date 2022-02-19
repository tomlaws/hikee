import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/events/event_tile.dart';
import 'package:hikee/components/latest_events/latest_events_controller.dart';

class LatestEvents extends StatelessWidget {
  final controller = Get.put(LatestEventsController());

  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => SingleChildScrollView(
              clipBehavior: Clip.none,
              padding: EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 16,
                children: state!.data
                    .map((e) => EventTile(event: e, width: 240))
                    .toList(),
              ),
            ),
        onLoading: SingleChildScrollView(
          clipBehavior: Clip.none,
          padding: EdgeInsets.all(16),
          scrollDirection: Axis.horizontal,
          child: Wrap(spacing: 16, children: [
            EventTile(event: null, width: 240),
            EventTile(event: null, width: 240)
          ]),
        ));
  }
}
