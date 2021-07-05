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
        child: ListView(
          children: [
           HorizontalList(items)
          ],
        ),
      ),
    );
  }
}
