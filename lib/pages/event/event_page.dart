import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/avatar.dart';
import 'package:hikees/components/core/bottom_bar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/calendar_date.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/futurer.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/components/hikees_notifier.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/models/event_participation.dart';
import 'package:hikees/pages/event/event_controller.dart';
import 'package:hikees/pages/event/event_participation_controller.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/time.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class EventPage extends GetView<EventController> {
  @override
  Widget build(BuildContext context) {
    final _eventParticipationController =
        Get.put(EventParticipationController());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: HikeeAppBar(
          title: controller.hobx((state) => Text(state?.name ?? ''),
              onLoading: Shimmer(width: 220, height: 30)),
        ),
        body: Column(children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.refreshEvent();
                _eventParticipationController.refetch();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: controller.hobx(
                          (state) => TrailTile(
                                trail: state?.trail,
                                onTap: () {
                                  if (state != null)
                                    Get.toNamed('/trails/${state.trail.id}',
                                        arguments: {'hideButtons': true});
                                },
                              ),
                          onLoading: TrailTile(
                            trail: null,
                          )),
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
                                    controller.hobx(
                                        (state) => CalendarDate(
                                            date: state!.date.toLocal(),
                                            size: 48),
                                        onLoading: Shimmer(
                                          width: 48,
                                          height: 48,
                                        )),
                                    SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        controller.hobx(
                                            (state) => Text(
                                                DateFormat('hh : mm a').format(
                                                    state!.date.toLocal()),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                            onLoading: Shimmer(
                                              fontSize: 16,
                                              width: 80,
                                            )),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        controller.hobx(
                                            (state) => Futurer(
                                                  future: GeoUtils
                                                      .calculateLengthAndDuration(
                                                          GeoUtils.decodePath(
                                                              state!
                                                                  .trail.path)),
                                                  builder: (Tuple2 data) =>
                                                      Text(
                                                    TimeUtils.formatMinutes(
                                                        data.item2),
                                                    style: TextStyle(
                                                        color: Colors.black38),
                                                  ),
                                                  placeholder:
                                                      Shimmer(width: 20),
                                                ),
                                            onLoading: Shimmer(
                                              width: 56,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                Button(
                                  secondary: true,
                                  backgroundColor: Color(0xFFf5f5f5),
                                  onPressed: () {
                                    if (controller.state == null) return;
                                    var startDate =
                                        controller.state!.date.toLocal();
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
                          Text('participants'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: _participantList(
                                _eventParticipationController,
                                true,
                                36,
                                context),
                          ),
                          Text('description'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: controller.hobx(
                                (state) => Text(state!.description),
                                onLoading: Shimmer()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomBar(
              child: MutationBuilder(
            userOnly: true,
            mutation: () {
              bool joined = controller.state!.joined ?? false;
              if (joined) {
                return _eventParticipationController.quitEvent();
              }
              return _eventParticipationController.joinEvent();
            },
            onDone: (e) {
              bool joined = controller.state!.joined!;
              if (joined) {
                controller.setJoined(false);
              } else {
                controller.setJoined(true);
              }
            },
            builder: (mutate, loading) {
              bool joined = controller.state?.joined ?? false;
              return controller.hobx(
                  (event) => Button(
                        minWidth: double.infinity,
                        loading: loading,
                        disabled: controller.state?.isExpired != false,
                        backgroundColor: joined ? Colors.red : null,
                        onPressed: () {
                          if (controller.state!.isExpired) {
                            DialogUtils.showSimpleDialog(
                                'error'.tr, 'thisEventHasExpired'.tr);
                            return;
                          }
                          mutate();
                        },
                        safeArea: true,
                        child: Text(controller.state?.isExpired != false
                            ? 'expired'.tr
                            : joined
                                ? 'quit'.tr
                                : 'join'.tr),
                      ),
                  onLoading: Shimmer(
                    width: double.infinity,
                    height: 48,
                  ));
            },
          )),
        ]));
  }

  Widget _participantList(
      controller, bool summary, double avatarHeight, BuildContext context) {
    int? take;
    double spacing = 8;
    if (summary) {
      var horizontalPadding = 16;
      take = ((MediaQuery.of(context).size.width - horizontalPadding * 2) /
              (avatarHeight + spacing))
          .floor();
    }
    return Container(
      height: avatarHeight,
      child: InfiniteScroller<EventParticipation>(
        controller: controller,
        take: take,
        empty: 'noParticipants'.tr,
        padding: EdgeInsets.zero,
        separator: SizedBox(width: spacing),
        horizontal: summary,
        builder: (participation) {
          return Avatar(user: participation.participant);
        },
        loadingBuilder: Avatar(
          user: null,
          height: avatarHeight,
        ),
        loadingItemCount: 5,
        overflowBuilder: (participation, displayCount, totalCount) {
          return Stack(children: [
            Avatar(
              user: participation?.participant,
              height: avatarHeight,
            ),
            Positioned.fill(
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.35),
                        borderRadius: BorderRadius.circular(avatarHeight / 2)),
                    child: Text(
                        '+' +
                            (totalCount - displayCount).clamp(0, 99).toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal)))),
          ]);
        },
      ),
    );
  }
}
