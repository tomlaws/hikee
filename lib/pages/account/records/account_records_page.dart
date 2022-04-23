import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/account/record_tile.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/pages/account/records/account_records_controller.dart';
import 'package:hikees/pages/account/records/account_records_filter.dart';
import 'package:hikees/pages/search/search_page.dart';

class AccountRecordsPage extends GetView<AccountRecordsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: HikeeAppBar(title: Text('records'.tr), actions: [
        Button(
          onPressed: () {
            Get.to(AccountRecordsFilter(
              controller: controller,
            ));
          },
          backgroundColor: Colors.transparent,
          secondary: true,
          icon: Icon(
            Icons.filter_alt_rounded,
            size: 18,
          ),
        ),
        Button(
          icon: Icon(Icons.search_rounded),
          onPressed: () {
            Get.to(SearchPage<Record, AccountRecordsController>(
                tag: 'search-records',
                controller: AccountRecordsController(),
                filter: AccountRecordsFilter(),
                loadingWidget: RecordTile(record: null),
                builder: (record) => RecordTile(record: record)));
          },
          backgroundColor: Colors.transparent,
          secondary: true,
        )
      ]),
      body: InfiniteScroller<Record>(
          controller: controller,
          separator: SizedBox(
            height: 16,
          ),
          empty: 'noRecords'.tr,
          loadingItemCount: 8,
          loadingBuilder: RecordTile(record: null),
          builder: (record) {
            return RecordTile(record: record);
          }),
    );
  }
}
