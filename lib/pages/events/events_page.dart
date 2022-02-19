import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/events/event_tile.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/pages/events/event_categories.dart';
import 'package:hikee/pages/events/events_controller.dart';
import 'package:hikee/pages/search/search_page.dart';

class EventsPage extends StatelessWidget {
  final controller = Get.find<EventsController>();
  final _eventCategoriesController = Get.find<EventCategoriesController>();

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
        empty: 'No events',
        loadingItemCount: 3,
        loadingBuilder: EventTile(event: null),
        builder: (e) {
          return EventTile(event: e);
        },
        sliversBuilder: (list) => [
          SliverAppBar(
            expandedHeight: 60.0,
            collapsedHeight: 60.0,
            pinned: true,
            elevation: 2,
            shadowColor: Colors.black45,
            backgroundColor: Colors.white,
            flexibleSpace: HikeeAppBar(
                elevation: 0,
                actions: [
                  Button(
                    icon: Icon(Icons.search),
                    secondary: true,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Get.to(SearchPage<Event, EventsController>(
                          tag: 'search-events',
                          controller: EventsController(),
                          builder: (event) => EventTile(event: event)));
                    },
                  )
                ],
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Events'),
                )),
          ),
          list
        ],
      ),
    );
  }
}
