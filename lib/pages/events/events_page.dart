import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/events/event_tile.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/pages/events/events_controller.dart';
import 'package:hikees/pages/search/search_page.dart';

class EventsPage extends GetView<EventsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: InfiniteScroller<Event>(
        refreshable: true,
        controller: controller,
        padding: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
        separator: SizedBox(
          height: 16,
        ),
        empty: 'noEvents'.tr,
        loadingItemCount: 3,
        loadingBuilder: EventTile(event: null),
        builder: (e) {
          return EventTile(event: e);
        },
        sliversBuilder: (list, _) => [
          SliverAppBar(
            expandedHeight: 60.0,
            collapsedHeight: 60.0,
            pinned: true,
            elevation: 2,
            shadowColor: Colors.black45,
            backgroundColor: Colors.black,
            flexibleSpace: HikeeAppBar(
                elevation: 0,
                leading: Button(
                    secondary: true,
                    backgroundColor: Colors.transparent,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.toNamed('/events/create');
                    }),
                actions: [
                  Button(
                    icon: Icon(Icons.search),
                    secondary: true,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Get.to(SearchPage<Event, EventsController>(
                          tag: 'search-events',
                          controller: EventsController(),
                          loadingWidget: EventTile(event: null),
                          builder: (event) => EventTile(event: event)));
                    },
                  )
                ],
                title: Text('events'.tr)),
          ),
          list
        ],
      ),
    );
  }
}
