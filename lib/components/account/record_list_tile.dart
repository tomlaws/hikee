import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/utils/geo.dart';
import 'package:intl/intl.dart';

class RecordListTile extends StatelessWidget {
  final Record record;

  const RecordListTile({Key? key, required this.record}) : super(key: key);

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
          boxShadow: [
            BoxShadow(
                blurRadius: 1, spreadRadius: 1, color: Colors.grey.shade200)
          ],
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
            Expanded(
              child: Text(
                record.name,
              ),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('yyyy-MM-dd').format(record.date),
                    style: TextStyle(color: Colors.black45),
                  ),
                  SizedBox(
                    height: 8,
                  ),
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
