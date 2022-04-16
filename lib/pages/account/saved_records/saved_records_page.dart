import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/account/record_tile.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/models/offline_record.dart';
import 'package:hikees/pages/account/saved_records/saved_records_controller.dart';

class SavedRecordsPage extends GetView<SavedRecordsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(
        title: Text('savedRecords'.tr),
      ),
      body: InfiniteScroller<OfflineRecord>(
        controller: controller,
        empty: Center(
          child: Text('noData'.tr),
        ),
        separator: SizedBox(
          height: 16,
        ),
        builder: (record) {
          return RecordTile(
            record: record,
            offline: true,
          );
        },
      ),
    );
  }
}
