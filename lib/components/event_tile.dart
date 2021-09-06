import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hikee/models/event.dart';
import 'package:intl/intl.dart';

class EventTile extends StatefulWidget {
  const EventTile({Key? key, required this.event}) : super(key: key);
  final Event event;
  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
          ]),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: CachedNetworkImage(
              imageUrl: widget.event.route.image,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 8,
                ),
                Opacity(
                  opacity: .75,
                  child:
                      Text(new DateFormat('dd / MM').format(widget.event.date)),
                ),
                SizedBox(
                  height: 8,
                ),
                Opacity(
                  opacity: .75,
                  child:
                      Text(new DateFormat('hh:mm a').format(widget.event.date)),
                ),
                SizedBox(
                  height: 8,
                ),
                Opacity(
                  opacity: .75,
                  child:
                      Text('0 participants'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
