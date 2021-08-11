import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
