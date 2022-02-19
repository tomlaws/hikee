import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/events/event_tile.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/pages/account/events/account_events_controller.dart';

class AccountEventsPage extends GetView<AccountEventsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(
        title: Text('Events'.tr),
      ),
      body: InfiniteScroller<Event>(
        controller: controller,
        empty: Center(
          child: Text('No participated events'),
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
