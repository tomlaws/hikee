import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/event_tile.dart';
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
      body: Column(
        children: [
          Expanded(
            child: InfiniteScroller<Event>(
                headers: [
                  HikeeAppBar(
                    elevation: 0,
                    title: Text("Events"),
                    titlePadding: false,
                    actions: [
                      // Button(
                      //     secondary: true,
                      //     backgroundColor: Colors.transparent,
                      //     icon: Icon(Icons.add_rounded),
                      //     onPressed: () {
                      //       Get.toNamed('/events/create');
                      //     })
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextInput(
                        hintText: 'Search...',
                        textInputAction: TextInputAction.search,
                        icon: Icon(Icons.search),
                        onTap: () {
                          Get.to(SearchPage<Event, EventsController>(
                              tag: 'search-events',
                              controller: EventsController(),
                              builder: (event) => EventTile(event: event)));
                        }),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
                controller: controller,
                separator: SizedBox(
                  height: 16,
                ),
                empty: 'No events',
                builder: (e) {
                  return EventTile(event: e);
                }),
          )
        ],
      ),
    );
  }
}
