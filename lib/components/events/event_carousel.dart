import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/events/event_card.dart';
import 'package:hikee/models/event.dart';

class EventCarousel extends StatefulWidget {
  final List<Event> items;
  EventCarousel(
    this.items, {
    Key? key,
  }) : super(key: key);

  @override
  _EventCarouselState createState() => _EventCarouselState();
}

class _EventCarouselState extends State<EventCarousel> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
            items: List<EventCard>.generate(widget.items.length,
                (index) => EventCard(event: widget.items[index])),
            options: CarouselOptions(
              height: 460,
              viewportFraction: 0.85,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
              scrollDirection: Axis.horizontal,
            )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.asMap().entries.map((entry) {
              return Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.fromLTRB(4, 0, 4, 12),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
