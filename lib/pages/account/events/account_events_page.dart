import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/events/event_tile.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/pages/account/events/account_events_controller.dart';

class AccountEventsPage extends GetView<AccountEventsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(
        title: Text('events'.tr),
      ),
      body: InfiniteScroller<Event>(
        controller: controller,
        empty: Center(
          child: Text('noParticipatedEvents'.tr),
        ),
        separator: SizedBox(
          height: 16,
        ),
        builder: (event) {
          return EventTile(
            event: event,
          );
        },
      ),
    );
  }
}
