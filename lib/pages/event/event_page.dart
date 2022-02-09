import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/avatar.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/calendar_date.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/components/trail_tile.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/models/event_participation.dart';
import 'package:hikee/pages/event/event_controller.dart';
import 'package:hikee/pages/event/event_participation_controller.dart';
import 'package:hikee/pages/trail/trail_binding.dart';
import 'package:hikee/pages/trail/trail_page.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/time.dart';
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
                          Text('Date',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                            controller.state?.trail.name_en ??
                                                '',
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
                          Text('Participants',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: SizedBox(
                                height: 32,
                                child: _participantList(
                                    _eventParticipationController,
                                    true,
                                    context)),
                          ),
                          Text('Description',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                  'Error', 'This event has expired.');
                              return;
                            }
                            mutate();
                          },
                          safeArea: true,
                          child: Text(event.isExpired
                              ? 'Expired'
                              : joined
                                  ? 'Quit'
                                  : 'Join'),
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
      empty: 'No participants yet',
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      separator: SizedBox(width: spacing),
      horizontal: summary,
      builder: (participation) {
        return Avatar(user: participation.participant);
      },
      overflowBuilder: (participation, displayCount, totalCount) {
        return Stack(children: [
          Avatar(user: participation.participant),
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
