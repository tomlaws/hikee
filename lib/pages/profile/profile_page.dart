import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/account/account_header.dart';
import 'package:hikee/components/account/record_tile.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/pages/profile/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: HikeeAppBar(
        title: FutureBuilder<User>(
            future: controller.getUser,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Shimmer(
                  width: 48,
                );
              } else {
                return Text(snapshot.data!.nickname);
              }
            }),
      ),
      body: Obx(() => controller.isPrivate.value != false
          ? Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AccountHeader(future: controller.getUser),
              ),
              SizedBox(height: 8),
              if (controller.isPrivate.value == true)
                Expanded(
                    child: Center(child: Text('Trail records are hidden'))),
            ])
          : InfiniteScroller<Record>(
              headers: [
                  AccountHeader(future: controller.getUser),
                ],
              controller: controller,
              separator: SizedBox(
                height: 16,
              ),
              empty: 'No records',
              builder: (record) {
                return RecordTile(record: record);
              })),
    );
  }
}
