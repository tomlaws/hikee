import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/latest_events/latest_events.dart';
import 'package:hikee/components/trail_tile.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/pages/trails/featured_trail_controller.dart';
import 'package:hikee/pages/trails/popular_trails_controller.dart';
import 'package:hikee/pages/trails/trails_controller.dart';
import 'package:hikee/pages/search/search_page.dart';
import 'package:hikee/pages/trails/trails_filter.dart';

class TrailsPage extends StatelessWidget {
  final _popularTrailsController = Get.find<PopularTrailsController>();
  final _featuredTrailsController = Get.find<FeaturedTrailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HikeeAppBar(
                elevation: 0,
                leading: Button(
                    backgroundColor: Colors.transparent,
                    secondary: true,
                    icon: Icon(
                      Icons.grid_view_rounded,
                    ),
                    onPressed: () {
                      Get.toNamed('/trails/categories');
                    }),
                title: Text("Trails"),
                actions: [
                  Button(
                      secondary: true,
                      backgroundColor: Colors.transparent,
                      icon: Icon(Icons.add_rounded),
                      onPressed: () {
                        Get.toNamed('/trails/create');
                      })
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Row(children: [
                  Expanded(
                    child: Hero(
                      tag: 'search',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextInput(
                            hintText: 'Search...',
                            textInputAction: TextInputAction.search,
                            icon: Icon(Icons.search),
                            onTap: () {
                              Get.to(SearchPage<Trail, TrailsController>(
                                  tag: 'search-trails',
                                  controller: TrailsController(),
                                  filter: TrailsFilter(),
                                  builder: (trail) => TrailTile(trail: trail)));
                            }),
                      ),
                    ),
                  )
                ]),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Text(
                  'Popular',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              _popularTrailsController.obx(
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
                  onLoading: CircularProgressIndicator(),
                  onEmpty: Center(
                    child: Text('not found'),
                  )),
              // _popularTrailsController.obx(
              //     (state) => ListView.separated(
              //           padding:
              //               EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              //           shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           itemCount: state?.length ?? 0,
              //           itemBuilder: (_, i) {
              //             return TrailTile(trail: state![i], width: 260);
              //           },
              //           separatorBuilder: (_, __) => SizedBox(
              //             width: 16,
              //           ),
              //         ),
              //     onLoading: CircularProgressIndicator(),
              //     onEmpty: Center(
              //       child: Text('not found'),
              //     )),
              //Container(height: 98, child: SizedBox()),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Featured',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _featuredTrailsController.obx(
                    (state) => TrailTile(trail: state!, aspectRatio: 4 / 3),
                    onLoading: CircularProgressIndicator()),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Text(
                  'Latest Events',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              LatestEvents(),
              SizedBox(height: 16),
            ],
          ),
        ));
  }
}
