import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/pages/account/trails/account_trails_controller.dart';

class AccountTrailsPage extends GetView<AccountTrailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(
        title: Text('trails'.tr),
      ),
      body: InfiniteScroller<Trail>(
        controller: controller,
        empty: Center(
          child: Text('noData'.tr),
        ),
        separator: SizedBox(
          height: 16,
        ),
        loadingItemCount: 10,
        loadingBuilder: TrailTile(trail: null),
        builder: (trail) {
          return TrailTile(
            trail: trail,
          );
        },
      ),
    );
  }
}
