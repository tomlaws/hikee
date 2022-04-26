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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: HikeeAppBar(
            title: Text('events'.tr),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: TabBar(
                    labelColor: Get.theme.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Get.theme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    onTap: (i) {
                      controller.switchTab(i);
                    },
                    tabs: [
                      Tab(
                        text: 'participating'.tr,
                      ),
                      Tab(
                        text: 'organizing'.tr,
                      ),
                    ]),
              )
            ],
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
          )),
    );
  }
}
