import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/trails/trail_category_tile.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/pages/trails/popular_trails_controller.dart';
import 'package:hikees/pages/trails/trail_categories_controller.dart';
import 'package:hikees/pages/trails/trails_controller.dart';
import 'package:hikees/pages/search/search_page.dart';
import 'package:hikees/pages/trails/trails_filter.dart';

import 'featured_trail_controller.dart';
import 'nearby_trails_controller.dart';

class TrailsPage extends GetView<TrailsController> {
  final _popularTrailsController = Get.put(PopularTrailsController());
  final _nearbyTrailsController = Get.put(NearbyTrailsController());
  final _featuredTrailsController = Get.put(FeaturedTrailController());
  final _trailCategoriesController = Get.put(TrailCategoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          displacement: 80.0,
          onRefresh: () async {
            _popularTrailsController.refetch();
            _featuredTrailsController.refetch();
            _nearbyTrailsController.refetch();
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
                  title: Text("trails".tr),
                  leading: Button(
                      secondary: true,
                      backgroundColor: Colors.transparent,
                      icon: Icon(Icons.add_rounded),
                      onPressed: () {
                        Get.toNamed('/trails/create');
                      }),
                  actions: [
                    // Button(
                    //     backgroundColor: Colors.transparent,
                    //     secondary: true,
                    //     icon: Icon(
                    //       Icons.grid_view_rounded,
                    //     ),
                    //     onPressed: () {
                    //       Get.toNamed('/trails/categories');
                    //     }),
                    Button(
                      icon: Icon(Icons.search),
                      secondary: true,
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Get.to(SearchPage<Trail, TrailsController>(
                            tag: 'search-trails',
                            controller: TrailsController(),
                            filter: TrailsFilter(),
                            loadingWidget: TrailTile(trail: null),
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
                        'categories'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: _trailCategoriesController.obx(
                          (state) => ListView.separated(
                                clipBehavior: Clip.none,
                                padding: EdgeInsets.all(16),
                                scrollDirection: Axis.horizontal,
                                itemCount: state?.length ?? 10,
                                itemBuilder: (_, i) => TrailCategoryTile(
                                  category: state?[i],
                                ),
                                separatorBuilder: (_, __) =>
                                    SizedBox(width: 16),
                              ),
                          onLoading: ListView.separated(
                            clipBehavior: Clip.none,
                            padding: EdgeInsets.all(16),
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (_, i) => TrailCategoryTile(
                              category: null,
                            ),
                            separatorBuilder: (_, __) => SizedBox(width: 16),
                          ),
                          onEmpty: Center(
                            child: Text('not found'),
                          )),
                    ),
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
                    SizedBox(
                      height: Get.locale?.languageCode.toLowerCase() == 'en'
                          ? 233
                          : 241.5,
                      child: _popularTrailsController.obx(
                          (state) => ListView.separated(
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.all(16),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, __) => SizedBox(width: 16),
                              itemCount: state?.length ?? 0,
                              itemBuilder: (_, i) =>
                                  TrailTile(trail: state?[i], width: 248)),
                          onLoading: ListView.separated(
                            clipBehavior: Clip.none,
                            padding: EdgeInsets.all(16),
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (_, __) => SizedBox(width: 16),
                            itemCount: 6,
                            itemBuilder: (_, i) =>
                                TrailTile(trail: null, width: 248),
                          ),
                          onEmpty: Center(
                            child: Text('not found'),
                          )),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      child: Text(
                        'nearby'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.locale?.languageCode.toLowerCase() == 'en'
                          ? 233
                          : 241.5,
                      child: _nearbyTrailsController.obx(
                          (state) => ListView.separated(
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.all(16),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, __) => SizedBox(width: 16),
                              itemCount: state?.length ?? 0,
                              itemBuilder: (_, i) =>
                                  TrailTile(trail: state?[i], width: 248)),
                          onLoading: ListView.separated(
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.all(16),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, __) => SizedBox(width: 16),
                              itemCount: 6,
                              itemBuilder: (_, i) =>
                                  TrailTile(trail: null, width: 248)),
                          onEmpty: Center(
                            child: Text('not found'),
                          )),
                    ),
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
                      child: _featuredTrailsController.obx(
                          (state) =>
                              TrailTile(trail: state!, aspectRatio: 4 / 3),
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
