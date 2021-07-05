import 'package:flutter/material.dart';
import 'package:hikee/models/event.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final bool? featured;
  final int? index;
  EventCard({Key? key, required this.event, this.featured, this.index})
      : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.featured == true)
      return Stack(
        children: [
          Stack(
            children: [
              Stack(
                children: [
                  Container(
                    height: 350,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://i.imgur.com/IyHBcKj.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black38,
                                Colors.transparent,
                              ]),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        height: 100,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Container()
                        // Stack(
                        //   children: [
                        //     Container(
                        //       height: 50,
                        //       width: 50,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                        //       height: 50,
                        //       width: 50,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     Container(
                        //       height: 50,
                        //       width: 50,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Colors.black,
                        //       ),
                        //     )

                        //   ],
                        // ),
                        ),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            top: 300,
            right: 24,
            left: 24,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(24),
                      offset: Offset(0, 3),
                      blurRadius: 12)
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              height: 120,
              width: 200,
              padding: EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.event.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Leo at phasellus cras pellentesque. Vel vel eu purus ornare orci',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    else
      return Container();
  }
}
