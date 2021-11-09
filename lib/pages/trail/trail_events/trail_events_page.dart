import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/event_tile.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/pages/events/create_event/create_event_binding.dart';
import 'package:hikee/pages/events/create_event/create_event_page.dart';
import 'package:hikee/pages/trail/trail_events/trail_events_controller.dart';

class TrailEventsPage extends GetView<TrailEventsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(
          title: Text('Events'.tr),
        ),
        body: Column(
          children: [
            Expanded(
              child: InfiniteScroller<Event>(
                controller: controller,
                separator: SizedBox(
                  height: 16,
                ),
                empty: Center(
                  child: Text('There\'s no event for this trail currently.'),
                ),
                builder: (event) {
                  return EventTile(
                    event: event,
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              child: Button(
                  radius: 0,
                  safeArea: true,
                  child: Text('CREATE'),
                  onPressed: () {
                    Get.to(CreateEventPage(),
                        arguments: {'trailId': controller.trailId},
                        binding: CreateEventBinding(),
                        transition: Transition.cupertino);
                  }),
            )
          ],
        ));
  }
}
