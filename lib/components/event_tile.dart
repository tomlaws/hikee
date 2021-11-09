import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/calendar_date.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/pages/event/event_binding.dart';
import 'package:hikee/pages/event/event_page.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final void Function()? onTap;
  final double width;
  final double aspectRatio;
  const EventTile(
      {Key? key,
      required this.event,
      this.onTap,
      this.width = double.infinity,
      this.aspectRatio = 16 / 9})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (onTap != null) {
        //   onTap!();
        //   return;
        // }
        //Get.toNamed('/event', id: 2, arguments: {'id': event.id});
        Get.to(EventPage(),
            transition: Transition.cupertino,
            arguments: {'id': event.id},
            binding: EventBinding());
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: AspectRatio(
            //height: 180,
            //width: width,
            aspectRatio: aspectRatio,
            child: CachedNetworkImage(
              placeholder: (_, __) => Shimmer(),
              imageUrl: event.trail.image,
              imageBuilder: (_, image) {
                return Stack(children: [
                  Positioned.fill(
                    child: Image(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.7),
                        ],
                      )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(event.name,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    '${event.participantCount} participants',
                                    maxLines: 1,
                                    style: TextStyle(color: Color(0xFFCCCCCC)),
                                  ),
                                ]),
                            CalendarDate(date: event.date, size: 48)
                          ],
                        ),
                      ),
                    ),
                  )
                ]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
