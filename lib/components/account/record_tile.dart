import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/calendar_date.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/geo.dart';

class RecordTile extends StatelessWidget {
  final Record? record;

  const RecordTile({Key? key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [Themes.lightShadow],
          borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          if (record != null) Get.toNamed('/records/${record!.id}');
        },
        child: Padding(
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
              record == null
                  ? Shimmer(
                      width: 42,
                      height: 42,
                    )
                  : CalendarDate(
                      date: record!.date,
                      size: 42,
                    ),
              SizedBox(width: 16),
              Expanded(
                child: record != null
                    ? Text(
                        record!.name,
                        maxLines: 2,
                      )
                    : Shimmer(
                        width: 40,
                      ),
              ),
              SizedBox(width: 16),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    record != null
                        ? Text(
                            '${(GeoUtils.getPathLength(encodedPath: record!.userPath))}km',
                            style: TextStyle(color: Colors.black45),
                            maxLines: 1)
                        : Shimmer(
                            width: 30,
                          )
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
