import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/pages/trails/category/trail_category_controller.dart';

class TrailCategoryPage extends GetView<TrailCategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(title: Text(controller.categoryName)),
        body: InfiniteScroller<Trail>(
          controller: controller,
          separator: SizedBox(
            height: 16,
          ),
          builder: (trail) {
            return TrailTile(trail: trail);
          },
          loadingItemCount: 3,
          loadingBuilder: TrailTile(),
        ));
  }
}
