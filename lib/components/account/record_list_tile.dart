import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/models/record.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
          children: [
            Icon(
              LineAwesomeIcons.mountain,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            Container(
              width: 24,
            ),
            Expanded(
              child: Text(
                record.route.name_en,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(record.route.length / 1000).toString()}km',
                  style: TextStyle(fontSize: 16),
                  maxLines: 2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
