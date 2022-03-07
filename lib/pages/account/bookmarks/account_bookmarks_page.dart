import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/models/bookmark.dart';
import 'package:hikees/pages/account/bookmarks/account_bookmarks_controller.dart';

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
          child: Text('noBookmarks'.tr),
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
