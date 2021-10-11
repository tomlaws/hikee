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
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/models/event_participation.dart';
import 'package:hikee/pages/event/event_controller.dart';
import 'package:hikee/pages/event/event_participation_controller.dart';
import 'package:hikee/pages/route/route_binding.dart';
import 'package:hikee/pages/route/route_page.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HikingRouteTile(
                      radius: 0,
                      route: event!.route,
                      onTap: () {
                        Get.toNamed('/routes/${event.route.id}',
                            arguments: {'hideButtons': true});
                      },
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('Date',
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 18,
                          //         color: Theme.of(context).primaryColor)),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
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
                                                .format(event.date.toLocal()),
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
                                                event.route.duration),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Button(
                                  secondary: true,
                                  onPressed: () {
                                    var startDate = controller.state!.date;
                                    var endDate = startDate.add(Duration(
                                        minutes:
                                            controller.state!.route.duration));
                                    final Event event = Event(
                                        title: controller.state?.name ?? '',
                                        description:
                                            controller.state?.description ?? '',
                                        location:
                                            controller.state?.route.name_en ??
                                                '',
                                        startDate: startDate,
                                        endDate: endDate);
                                    Add2Calendar.addEvent2Cal(event);
                                  },
                                  icon: Icon(
                                    Icons.event,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text('Participants',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor)),
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor)),
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
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(0),
                  child: MutationBuilder(
                    mutation: () {
                      bool joined = event.joined ?? false;
                      if (joined) {
                        return _eventParticipationController.quitEvent();
                      }
                      return _eventParticipationController.joinEvent();
                    },
                    onDone: (_) {
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
                        radius: 0,
                        loading: loading,
                        backgroundColor: joined ? Colors.red : null,
                        onPressed: () {
                          mutate();
                        },
                        safeArea: true,
                        child: Text(joined ? 'QUIT' : 'JOIN'),
                      );
                    },
                  )),
            )
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
