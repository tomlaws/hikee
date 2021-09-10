import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/calendar_date.dart';
import 'package:hikee/models/event.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class EventTile extends StatefulWidget {
  const EventTile({Key? key, required this.event}) : super(key: key);
  final Event event;
  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Routemaster.of(context).push('/events/${widget.event.id}');
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
            ]),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 156,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.event.route.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.event.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: .75,
                        child: Text(
                            '${widget.event.participantCount} participants'),
                      ),
                    ],
                  ),
                  CalendarDate(date: widget.event.date)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
