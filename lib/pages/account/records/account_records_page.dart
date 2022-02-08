import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/account/record_list_tile.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/protected.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/pages/account/records/account_records_controller.dart';
import 'package:hikee/pages/account/records/account_records_filter.dart';
import 'package:hikee/pages/search/search_page.dart';

class AccountRecordsPage extends GetView<AccountRecordsController> {
  @override
  Widget build(BuildContext context) {
    return Protected(
      authenticatedBuilder: (_, getMe) {
        return Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: HikeeAppBar(title: Text('Records'), actions: [
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
                    showAll: true,
                    tag: 'search-records',
                    controller: AccountRecordsController(),
                    filter: AccountRecordsFilter(),
                    builder: (record) => RecordListTile(record: record)));
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
              empty: 'No records',
              builder: (record) {
                return RecordListTile(record: record);
              }),
        );
      },
    );
  }
}
