import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/avatar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/calendar_date.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/models/event_participation.dart';
import 'package:hikees/pages/event/event_controller.dart';
import 'package:hikees/pages/event/event_participation_controller.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/time.dart';
import 'package:intl/intl.dart';

class EventPage extends GetView<EventController> {
  @override
  Widget build(BuildContext context) {
    final _eventParticipationController =
        Get.put(EventParticipationController());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: HikeeAppBar(
          title: controller.obx((state) => Text(state?.name ?? ''),
              onLoading: Shimmer(width: 220, height: 30)),
        ),
        body: controller.obx((event) {
          return Column(children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TrailTile(
                        trail: event!.trail,
                        onTap: () {
                          Get.toNamed('/trails/${event.trail.id}',
                              arguments: {'hideButtons': true});
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('date'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CalendarDate(date: event.date, size: 48),
                                    SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            DateFormat('hh:mm a')
                                                .format(event.date),
                                            style: TextStyle(
                                              fontSize: 16,
                                            )),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Opacity(
                                          opacity: .75,
                                          child: Text(
                                            TimeUtils.formatMinutes(
                                                event.trail.duration),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Button(
                                  secondary: true,
                                  backgroundColor: Color(0xFFf5f5f5),
                                  onPressed: () {
                                    var startDate = controller.state!.date;
                                    var endDate = startDate.add(Duration(
                                        minutes:
                                            controller.state!.trail.duration));
                                    final Event event = Event(
                                        title: controller.state?.name ?? '',
                                        description:
                                            controller.state?.description ?? '',
                                        location:
                                            controller.state?.trail.name ?? '',
                                        startDate: startDate,
                                        endDate: endDate);
                                    Add2Calendar.addEvent2Cal(event);
                                  },
                                  icon: Icon(
                                    Icons.event,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text('paticipants'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: SizedBox(
                                height: 32,
                                child: _participantList(
                                    _eventParticipationController,
                                    true,
                                    context)),
                          ),
                          Text('description'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Text(event.description),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
              child: Row(
                children: [
                  Expanded(
                    child: MutationBuilder(
                      userOnly: true,
                      mutation: () {
                        bool joined = event.joined ?? false;
                        if (joined) {
                          return _eventParticipationController.quitEvent();
                        }
                        return _eventParticipationController.joinEvent();
                      },
                      onDone: (e) {
                        bool joined = event.joined!;
                        if (joined) {
                          controller.setJoined(false);
                        } else {
                          controller.setJoined(true);
                        }
                      },
                      builder: (mutate, loading) {
                        bool joined = event.joined ?? false;
                        return Button(
                          loading: loading,
                          disabled: event.isExpired,
                          backgroundColor: joined ? Colors.red : null,
                          onPressed: () {
                            if (event.isExpired) {
                              DialogUtils.showDialog(
                                  'error'.tr, 'thisEventHasExpired'.tr);
                              return;
                            }
                            mutate();
                          },
                          safeArea: true,
                          child: Text(event.isExpired
                              ? 'expired'.tr
                              : joined
                                  ? 'quit'.tr
                                  : 'join'.tr),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]);
        },
            onLoading: Center(
              child: CircularProgressIndicator(),
            )));
  }

  Widget _participantList(controller, bool summary, BuildContext context) {
    int? take;
    double spacing = 8;
    double avatarHeight = 32;
    if (summary) {
      var horizontalPadding = 16;
      take = ((MediaQuery.of(context).size.width - horizontalPadding * 2) /
              (avatarHeight + spacing))
          .floor();
    }
    return InfiniteScroller<EventParticipation>(
      controller: controller,
      take: take,
      empty: 'noParticipants'.tr,
      padding: EdgeInsets.zero,
      separator: SizedBox(width: spacing),
      horizontal: summary,
      builder: (participation) {
        return Avatar(user: participation.participant);
      },
      //loadingBuilder: Avatar(user: null),
      //loadingItemCount: 5,
      overflowBuilder: (participation, displayCount, totalCount) {
        return Stack(children: [
          Avatar(user: participation?.participant),
          Positioned.fill(
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.35),
                      borderRadius: BorderRadius.circular(avatarHeight / 2)),
                  child: Text(
                      '+' + (totalCount - displayCount).clamp(0, 99).toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal)))),
        ]);
      },
    );
  }
}
