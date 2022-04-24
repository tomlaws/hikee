import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/bottom_bar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/events/event_tile.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/pages/trail/trail_events/trail_events_controller.dart';

class TrailEventsPage extends GetView<TrailEventsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(
          title: Text('events'.tr),
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
                  child: Text('theresNoEventForThisTrailCurrently'.tr),
                ),
                loadingItemCount: 6,
                loadingBuilder: EventTile(
                  event: null,
                ),
                builder: (event) {
                  return EventTile(
                    event: event,
                  );
                },
              ),
            ),
            BottomBar(
              child: Row(children: [
                Expanded(
                  child: Button(
                      child: Text('createEvent'.tr),
                      onPressed: () {
                        Get.offAndToNamed(
                            '/events/create/${controller.trailId}');
                      }),
                )
              ]),
            )
          ],
        ));
  }
}
