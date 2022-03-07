import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/connection_error.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/pages/trails/popular_trails_controller.dart';
import 'package:hikees/pages/trails/trails_controller.dart';
import 'package:hikees/pages/search/search_page.dart';

import 'featured_trail_controller.dart';

class TrailsPage extends GetView<TrailsController> {
  final popularTrailsController = Get.find<PopularTrailsController>();
  final featuredTrailsController = Get.find<FeaturedTrailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          displacement: 80.0,
          onRefresh: () async {
            popularTrailsController.refetch();
            featuredTrailsController.refetch();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverAppBar(
                expandedHeight: 60.0,
                collapsedHeight: 60.0,
                pinned: true,
                elevation: 2,
                shadowColor: Colors.black45,
                backgroundColor: Colors.white,
                flexibleSpace: HikeeAppBar(
                  elevation: 0,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("trails".tr),
                  ),
                  actions: [
                    Button(
                        backgroundColor: Colors.transparent,
                        secondary: true,
                        icon: Icon(
                          Icons.grid_view_rounded,
                        ),
                        onPressed: () {
                          Get.toNamed('/trails/categories');
                        }),
                    Button(
                        secondary: true,
                        backgroundColor: Colors.transparent,
                        icon: Icon(Icons.add_rounded),
                        onPressed: () {
                          Get.toNamed('/trails/create');
                        }),
                    Button(
                      icon: Icon(Icons.search),
                      secondary: true,
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Get.to(SearchPage<Trail, TrailsController>(
                            tag: 'search-trails',
                            controller: TrailsController(),
                            builder: (trail) => TrailTile(trail: trail)));
                      },
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      child: Text(
                        'popular'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    popularTrailsController.obx(
                        (state) => SingleChildScrollView(
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.all(16),
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 16,
                                children: state!
                                    .map((e) => TrailTile(trail: e, width: 240))
                                    .toList(),
                              ),
                            ),
                        onError: (error) => ConnectionError(),
                        onLoading: SingleChildScrollView(
                            clipBehavior: Clip.none,
                            padding: EdgeInsets.all(16),
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 16,
                              children: [
                                TrailTile(trail: null, width: 240),
                                TrailTile(trail: null, width: 240)
                              ],
                            )),
                        onEmpty: Center(
                          child: Text('not found'),
                        )),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'featured'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: featuredTrailsController.obx(
                          (state) =>
                              TrailTile(trail: state!, aspectRatio: 4 / 3),
                          onError: (error) => ConnectionError(),
                          onLoading:
                              TrailTile(trail: null, aspectRatio: 4 / 3)),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
