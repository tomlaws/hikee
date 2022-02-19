import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/calendar_date.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/geo.dart';
import 'package:intl/intl.dart';

class RecordTile extends StatelessWidget {
  final Record record;

  const RecordTile({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/records/${record.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [Themes.lightShadow],
        ),
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(
            //   LineAwesomeIcons.mountain,
            //   color: Theme.of(context).primaryColor,
            //   size: 32,
            // ),
            // Container(
            //   width: 24,
            // ),
            CalendarDate(
              date: record.date,
              size: 42,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                record.name,
              ),
            ),
            SizedBox(width: 16),
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(GeoUtils.getPathLength(encodedPath: record.userPath))}km',
                    maxLines: 2,
                    style: TextStyle(color: Colors.black45),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
