import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/pages/routes/featured_route_controller.dart';
import 'package:hikee/pages/routes/popular_routes_controller.dart';
import 'package:hikee/pages/routes/routes_controller.dart';
import 'package:hikee/pages/search/search_page.dart';

class RoutesPage extends StatelessWidget {
  final _popularRoutesController = Get.find<PopularRoutesController>();
  final _featuredRoutesController = Get.find<FeaturedRouteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Hero(
                    tag: 'search',
                    child: TextInput(
                        hintText: 'Search...',
                        textInputAction: TextInputAction.search,
                        icon: Icon(Icons.search),
                        onTap: () {
                          Get.to(SearchPage<HikingRoute>(
                              tag: 'search-routes',
                              controller: Get.put(RoutesController(),
                                  tag: 'search-routes'),
                              builder: (route) =>
                                  HikingRouteTile(route: route)));
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Popular',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 260 / (16 / 9) + 32),
                child: _popularRoutesController.obx(
                    (state) => ListView.separated(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: state?.length ?? 0,
                          itemBuilder: (_, i) {
                            return HikingRouteTile(
                                route: state![i], width: 260);
                          },
                          separatorBuilder: (_, __) => SizedBox(
                            width: 16,
                          ),
                        ),
                    onLoading: CircularProgressIndicator(),
                    onEmpty: Center(
                      child: Text('not found'),
                    )),
              ),
              //Container(height: 98, child: SizedBox()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Featured',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _featuredRoutesController.obx(
                    (state) =>
                        HikingRouteTile(route: state!, aspectRatio: 4 / 3),
                    onLoading: CircularProgressIndicator()),
              )
            ],
          ),
        ));
  }
}
