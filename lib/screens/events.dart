import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/events/card.dart';
import 'package:hikee/components/events/h_list.dart';
import 'package:hikee/models/event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final items = List<Event>.generate(
      6, (i) => Event('Testing event', new DateTime.now()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            HorizontalList(items),
            Padding(
              padding: EdgeInsets.fromLTRB(18, 24, 0, 18),
              child: Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
            ),
            Container(
              // padding: EdgeInsets.only(
              //   left: 12,
              // ),
              height: 100,
              // color: Colors.green,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                padding: EdgeInsets.only(left: 18),
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                    ),
                    height: 100,
                    width: 100,
                  ),
                  Container(
                    width: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                    ),
                    height: 100,
                    width: 100,
                  ),
                  Container(
                    width: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                    ),
                    height: 100,
                    width: 100,
                  ),
                  Container(
                    width: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                    ),
                    height: 100,
                    width: 100,
                  )
                ],
              ),
            ),
            Container(
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://i.imgur.com/IyHBcKj.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://i.imgur.com/IyHBcKj.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
