import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/account/account_header.dart';
import 'package:hikees/components/account/record_tile.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/pages/profile/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: HikeeAppBar(
        title: Obx(() => controller.user.value != null
            ? Text(controller.user.value!.nickname)
            : Shimmer(width: 48)),
      ),
      body: Obx(() => controller.user.value?.isPrivate != false
          ? Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Obx(
                    () => AccountHeader(user: controller.user.value),
                  )),
              SizedBox(height: 8),
              if (controller.user.value?.isPrivate == true)
                Expanded(
                    child: Center(child: Text('trailRecordsAreHidden'.tr))),
            ])
          : InfiniteScroller<Record>(
              headers: [
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AccountHeader(user: controller.user.value),
                    ),
                  )
                ],
              controller: controller,
              separator: SizedBox(
                height: 16,
              ),
              empty: 'noRecords'.tr,
              loadingItemCount: 5,
              loadingBuilder: RecordTile(record: null),
              builder: (record) {
                return RecordTile(record: record);
              })),
    );
  }
}
