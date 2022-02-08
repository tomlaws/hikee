import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/calendar_date.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/pages/event/event_binding.dart';
import 'package:hikee/pages/event/event_page.dart';
import 'package:hikee/themes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EventTile extends StatelessWidget {
  final Event? event;
  final void Function()? onTap;
  final double width;
  final double aspectRatio;
  const EventTile(
      {Key? key,
      required this.event,
      this.onTap,
      this.width = double.infinity,
      this.aspectRatio = 16 / 7})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (event != null)
          Get.to(EventPage(),
              transition: Transition.cupertino,
              arguments: {'id': event!.id},
              binding: EventBinding());
      },
      child: Container(
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [Themes.shadow]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              margin: EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: event == null
                  ? Shimmer()
                  : CachedNetworkImage(
                      placeholder: (_, __) => Shimmer(),
                      imageUrl: event!.trail.image,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        event == null
                            ? Shimmer(fontSize: 16)
                            : Text(event!.name,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            event == null
                                ? Shimmer(fontSize: 12, width: 88)
                                : Text(
                                    '${event!.participantCount} participants',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (event != null) CalendarDate(date: event!.date, size: 36)
                ],
              )),
        ]),
      ),
    );
  }
}
