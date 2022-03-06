import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/events/event_tile.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/pages/trail/trail_events/trail_events_controller.dart';

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
                builder: (event) {
                  return EventTile(
                    event: event,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 16,
                    spreadRadius: -8,
                    color: Colors.black.withOpacity(.09),
                    offset: Offset(0, -6))
              ]),
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
