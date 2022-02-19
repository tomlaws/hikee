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
          color: Colors.red[400], borderRadius: BorderRadius.circular(6.0)),
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                        left: size / 4,
                        top: size / 6 / -2,
                        child: Container(
                          width: size / 8,
                          height: size / 6,
                          decoration: BoxDecoration(
                              color: Colors.red[400],
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(6.0)),
                        )),
                    Positioned(
                        right: size / 4,
                        top: size / 6 / -2,
                        child: Container(
                          width: size / 8,
                          height: size / 6,
                          decoration: BoxDecoration(
                              color: Colors.pink[400],
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(6.0)),
                        )),
                    Positioned(
                      top: 0,
                      bottom: size - 20 + 1,
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: Text(DateFormat('MMM').format(date),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12))),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 20,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        margin: EdgeInsets.only(bottom: 1, left: 1, right: 1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(5.0))),
                        child: Text(date.day.toString(),
                            style: TextStyle(
                                color: Colors.red[400],
                                fontSize: size * 0.375)),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
