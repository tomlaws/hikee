import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/avatar.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/calendar_date.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/future_selector.dart';
import 'package:hikee/components/core/infinite_scroll.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/models/event_participation.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/event.dart';
import 'package:hikee/pages/route.dart';
import 'package:hikee/providers/event_participations.dart';
import 'package:hikee/utils/time.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HikeeAppBar(
        title: Text(context.watch<EventProvider>().event?.name ?? ''),
      ),
      body: FutureSelector<EventProvider, Event>(
        init: (p) => p.getEvent(widget.id),
        selector: (_, p) => p.event,
        builder: (_, event, __) {
          return Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: HikingRouteTile(
                          route: event.route,
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) =>
                                    RouteScreen(id: event.route.id)));
                          },
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).primaryColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CalendarDate(date: event.date),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(DateFormat('hh:mm a').format(event.date),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                Opacity(
                                  opacity: .75,
                                  child: Text(TimeUtils.formatMinutes(
                                      event.route.duration)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 8,
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
                      Divider(),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Participants',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).primaryColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: event.participantCount == 0
                            ? Center(
                                child: Opacity(
                                    opacity: .75,
                                    child: Text('No participants yet')))
                            : SizedBox(
                                height: 32, child: _participantList(true)),
                      )
                    ],
                  ),
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
                      return context.read<AuthProvider>().mustLogin(context,
                          () {
                        bool joined = event.joined ?? false;
                        if (joined) {
                          return context
                              .read<EventProvider>()
                              .quitEvent(event.id);
                        }
                        return context
                            .read<EventProvider>()
                            .joinEvent(event.id);
                      });
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
                        child: Text(joined ? 'QUIT' : 'JOIN'),
                      );
                    },
                  )),
            )
          ]);
        },
      ),
    );
  }

  Widget _participantList(bool summary) {
    int? take;
    double spacing = 8;
    double avatarHeight = 32;
    if (summary) {
      var horizontalPadding = 16;
      take = ((MediaQuery.of(context).size.width - horizontalPadding * 2) /
              (avatarHeight + spacing))
          .floor();
    }

    return InfiniteScroll<EventParticipationsProvider, EventParticipation>(
        take: take,
        init: take != null,
        empty: 'No participants yet',
        shrinkWrap: true,
        selector: (p) => p.items,
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
                        '+' +
                            (totalCount - displayCount).clamp(0, 99).toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal)))),
          ]);
        },
        fetch: (next) {
          return context.read<EventParticipationsProvider>().fetch(next);
        });
  }
}
