import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDate extends StatelessWidget {
  const CalendarDate({Key? key, required this.date, this.size = 64})
      : super(key: key);
  final DateTime date;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(8.0)),
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(DateFormat('MMM').format(date),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              margin: EdgeInsets.only(bottom: 2, left: 2, right: 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(6.0))),
              child: Text(date.day.toString(),
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
