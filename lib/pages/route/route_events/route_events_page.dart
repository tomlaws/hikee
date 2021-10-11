import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/event_tile.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/pages/events/create_event/create_event_binding.dart';
import 'package:hikee/pages/events/create_event/create_event_page.dart';
import 'package:hikee/pages/route/route_events/route_events_controller.dart';

class RouteEventsPage extends GetView<RouteEventsController> {
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
                  child: Text('There\'s no event for this route currently.'),
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
                        arguments: {'routeId': controller.routeId},
                        binding: CreateEventBinding(),
                        transition: Transition.cupertino);
                  }),
            )
          ],
        ));
  }
}
