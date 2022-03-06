import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/trails/trail_tile.dart';
import 'package:hikee/models/bookmark.dart';
import 'package:hikee/pages/account/bookmarks/account_bookmarks_controller.dart';

class AccountBookmarksPage extends GetView<AccountBookmarksController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(
        title: Text('bookmarks'.tr),
      ),
      body: InfiniteScroller<Bookmark>(
        controller: controller,
        empty: Center(
          child: Text('noParticipatedEvents'.tr),
        ),
        separator: SizedBox(
          height: 16,
        ),
        builder: (bookmark) {
          return TrailTile(
            trail: bookmark.trail,
          );
        },
      ),
    );
  }
}
