import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/map.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/pages/compass/compass_controller.dart';
import 'package:hikee/pages/home/home_controller.dart';
import 'package:hikee/pages/route/route_controller.dart';
import 'package:hikee/pages/route/route_events/route_events_binding.dart';
import 'package:hikee/pages/route/route_events/route_events_page.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RoutePage extends GetView<RouteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SliverAppBar(
                  //   expandedHeight: 250.0,
                  //   backgroundColor: Colors.white,
                  //   automaticallyImplyLeading: false,
                  //   leadingWidth: 36 + 18,
                  //   leading: Container(
                  //     padding: const EdgeInsets.only(left: 16.0),
                  //     margin: EdgeInsets.symmetric(vertical: 8),
                  //     child: Button(
                  //         height: 36,
                  //         backgroundColor: Colors.white,
                  //         minWidth: 36,
                  //         radius: 36,
                  //         icon: Icon(
                  //           Icons.chevron_left,
                  //           color: Colors.black87,
                  //           size: 20,
                  //         ),
                  //         onPressed: Get.back),
                  //   ),
                  //   actions: [
                  //     controller.obx((state) {
                  //       var bookmarked = state!.bookmark != null;
                  //       return Container(
                  //         padding: const EdgeInsets.only(right: 16.0),
                  //         margin: EdgeInsets.symmetric(vertical: 8),
                  //         width: 36 + 18,
                  //         child: Button(
                  //             backgroundColor: Colors.white,
                  //             radius: 36,
                  //             height: 36,
                  //             minWidth: 36,
                  //             icon: Icon(
                  //               bookmarked
                  //                   ? Icons.bookmark
                  //                   : Icons.bookmark_outline,
                  //               color: Colors.black87,
                  //               size: 20,
                  //             ),
                  //             onPressed: () {}),
                  //       );
                  //     }, onLoading: SizedBox())
                  //   ],
                  //   flexibleSpace: Stack(
                  //     children: <Widget>[
                  //       Positioned.fill(
                  //           child: controller.obx((state) {
                  //         var images = state!.images
                  //             .map((img) => CachedNetworkImage(
                  //                   placeholder: (_, __) => Shimmer(),
                  //                   imageUrl: img,
                  //                   fit: BoxFit.cover,
                  //                 ))
                  //             .toList();
                  //         return Container(
                  //           clipBehavior: Clip.antiAlias,
                  //           margin: EdgeInsets.symmetric(horizontal: 8),
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.vertical(
                  //                   bottom: Radius.circular(16))),
                  //           child: PageView(
                  //             controller: controller.carouselController,
                  //             children: images,
                  //           ),
                  //         );
                  //       }, onLoading: SizedBox())),
                  //       Positioned(
                  //         bottom: 8,
                  //         left: 0,
                  //         right: 0,
                  //         child: Center(
                  //           child: controller.obx((state) {
                  //             return SizedBox(
                  //               height: 8,
                  //               child: ListView.separated(
                  //                   scrollDirection: Axis.horizontal,
                  //                   shrinkWrap: true,
                  //                   separatorBuilder: (_, __) => Container(
                  //                         width: 8,
                  //                       ),
                  //                   itemCount: state!.images.length,
                  //                   itemBuilder: (_, i) {
                  //                     return Obx(
                  //                       () => AnimatedContainer(
                  //                         duration:
                  //                             const Duration(milliseconds: 250),
                  //                         width: 8,
                  //                         height: 8,
                  //                         decoration: BoxDecoration(
                  //                             color: controller.carouselPage
                  //                                         .round() ==
                  //                                     i
                  //                                 ? Theme.of(context).primaryColor
                  //                                 : Colors.black38,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(4.0)),
                  //                       ),
                  //                     );
                  //                   }),
                  //             );
                  //           }, onLoading: SizedBox()),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SafeArea(
                            child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  SizedBox(
                                    height: 280,
                                    child: controller.obx((state) {
                                      var images = state!.images
                                          .map((img) => CachedNetworkImage(
                                                placeholder: (_, __) =>
                                                    Shimmer(),
                                                imageUrl: img,
                                                fit: BoxFit.cover,
                                              ))
                                          .toList();
                                      return Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: PageView(
                                          controller:
                                              controller.carouselController,
                                          children: images,
                                        ),
                                      );
                                    }, onLoading: SizedBox()),
                                  ),
                                  Positioned(
                                      bottom: -40,
                                      left: 16,
                                      right: 16,
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            boxShadow: [Themes.shadow],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            controller.obx(
                                                (state) => AutoSizeText(
                                                    state!.name_en,
                                                    minFontSize: 18,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    overflowReplacement:
                                                        SizedBox(
                                                      height: 22,
                                                      child: Marquee(
                                                        blankSpace: 20.0,
                                                        fadingEdgeStartFraction:
                                                            .2,
                                                        fadingEdgeEndFraction:
                                                            .2,
                                                        pauseAfterRound:
                                                            Duration(
                                                                seconds: 1),
                                                        velocity: 24.0,
                                                        text: state.name_en,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                onLoading: Shimmer(
                                                  fontSize: 18,
                                                )),
                                            SizedBox(height: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                        LineAwesomeIcons
                                                            .map_marker,
                                                        size: 12,
                                                        color:
                                                            Color(0xFFAAAAAA)),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    controller.obx(
                                                        (state) => Text(
                                                              state!.region
                                                                  .name_en,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xFFAAAAAA)),
                                                            ),
                                                        onLoading: Shimmer(
                                                          fontSize: 12,
                                                        )),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Icon(LineAwesomeIcons.star,
                                                        size: 12,
                                                        color:
                                                            Color(0xFFAAAAAA)),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    controller.obx(
                                                        (state) => Text(
                                                              state!.rating
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xFFAAAAAA)),
                                                            ),
                                                        onLoading: Shimmer(
                                                          fontSize: 12,
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(LineAwesomeIcons.ruler,
                                                        size: 12,
                                                        color:
                                                            Color(0xFFAAAAAA)),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    controller.obx(
                                                        (state) => Text(
                                                              GeoUtils.formatDistance(
                                                                  state!.length /
                                                                      1000),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xFFAAAAAA)),
                                                            ),
                                                        onLoading: Shimmer(
                                                          fontSize: 12,
                                                        )),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Icon(LineAwesomeIcons.clock,
                                                        size: 12,
                                                        color:
                                                            Color(0xFFAAAAAA)),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    controller.obx(
                                                        (state) => Text(
                                                              TimeUtils
                                                                  .formatMinutes(
                                                                      state!
                                                                          .duration),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xFFAAAAAA)),
                                                            ),
                                                        onLoading: Shimmer(
                                                          fontSize: 12,
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: Button(
                                        height: 36,
                                        backgroundColor: Colors.white,
                                        minWidth: 36,
                                        radius: 36,
                                        icon: Icon(
                                          Icons.chevron_left,
                                          color: Colors.black87,
                                          size: 20,
                                        ),
                                        onPressed: Get.back),
                                  ),
                                  Positioned(
                                      top: 16,
                                      right: 16,
                                      child: controller.obx((state) {
                                        var bookmarked =
                                            state!.bookmark != null;
                                        return Button(
                                            backgroundColor: Colors.white,
                                            radius: 36,
                                            height: 36,
                                            minWidth: 36,
                                            icon: Icon(
                                              bookmarked
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_outline,
                                              color: Colors.black87,
                                              size: 20,
                                            ),
                                            onPressed: () {});
                                      }, onLoading: SizedBox())),
                                ]),
                          ),
                          SizedBox(
                            height: 48,
                          ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //         height: 48,
                          //         clipBehavior: Clip.hardEdge,
                          //         decoration: BoxDecoration(
                          //             color: Colors.grey[100],
                          //             borderRadius: BorderRadius.circular(8)),
                          //         child:
                          //             Stack(clipBehavior: Clip.none, children: [
                          //           Positioned(
                          //             left: 0,
                          //             top: 0,
                          //             child: Icon(
                          //               LineAwesomeIcons.ruler,
                          //               size: 72,
                          //               color: Colors.black12,
                          //             ),
                          //           ),
                          //           Align(
                          //             alignment: Alignment.centerRight,
                          //             child: Padding(
                          //               padding: EdgeInsets.only(right: 8),
                          //               child: controller.obx(
                          //                   (route) => Text(
                          //                         '${(route!.length / 1000).toString()}km',
                          //                         style: TextStyle(
                          //                             fontSize: 16,
                          //                             fontWeight:
                          //                                 FontWeight.bold,
                          //                             color: Colors.black38),
                          //                       ),
                          //                   onLoading: Shimmer(
                          //                     height: 30,
                          //                   )),
                          //             ),
                          //           )
                          //         ]),
                          //       ),
                          //     ),
                          //     SizedBox(width: 16),
                          //     Expanded(
                          //       child: Container(
                          //         height: 48,
                          //         clipBehavior: Clip.hardEdge,
                          //         decoration: BoxDecoration(
                          //             color: Colors.grey[100],
                          //             borderRadius: BorderRadius.circular(8)),
                          //         child:
                          //             Stack(clipBehavior: Clip.none, children: [
                          //           Positioned(
                          //             left: 0,
                          //             top: 0,
                          //             child: Icon(
                          //               LineAwesomeIcons.clock,
                          //               size: 72,
                          //               color: Colors.black12,
                          //             ),
                          //           ),
                          //           Align(
                          //               alignment: Alignment.centerRight,
                          //               child: Padding(
                          //                   padding: EdgeInsets.only(right: 8),
                          //                   child: controller.obx(
                          //                       (route) => Text(
                          //                             TimeUtils.formatMinutes(
                          //                                 route!.duration),
                          //                             style: TextStyle(
                          //                                 fontSize: 16,
                          //                                 fontWeight:
                          //                                     FontWeight.bold,
                          //                                 color:
                          //                                     Colors.black38),
                          //                           ),
                          //                       onLoading: Shimmer(
                          //                         height: 30,
                          //                       ))))
                          //         ]),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // controller.obx(
                          //     (state) => RouteInfo(
                          //           route: state!,
                          //           showRouteName: false,
                          //         ),
                          //     onLoading: SizedBox()),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Description',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ))),
                          controller.obx(
                              (state) => ReadMoreText(
                                    state!.description_en,
                                    trimLines: 3,
                                    colorClickableText: Colors.pink,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    style: TextStyle(
                                        height: 1.6,
                                        color: Get.theme.textTheme.bodyText1
                                                ?.color ??
                                            Colors.black),
                                    moreStyle: TextStyle(
                                      color: Get.theme.colorScheme.secondary,
                                    ),
                                    lessStyle: TextStyle(
                                        color: Get.theme.colorScheme.secondary),
                                  ),
                              onLoading: Shimmer(
                                fontSize: 16,
                              )),
                          Container(
                            height: 16,
                          ),
                          Container(
                              height: 240,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: controller.obx(
                                  (state) => HikeeMap(
                                      target: controller.points.value![
                                          (controller.points.value!.length /
                                                  5 *
                                                  2)
                                              .floor()],
                                      path: controller.points.value!),
                                  onLoading: Shimmer(
                                    height: 240,
                                  )))
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Reviews',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Button(
                                      backgroundColor: Colors.transparent,
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.black38,
                                      ),
                                      onPressed: () async {
                                        //await routeReviewDialog();
                                      })
                                ]),
                            Container(
                              height: 8,
                            ),
                            //_reviewList(3),
                            // Selector<RouteReviewsProvider, bool>(
                            //     builder: (context, more, __) {
                            //       if (!more) return SizedBox();
                            //       return Padding(
                            //         padding: const EdgeInsets.only(top: 8.0),
                            //         child: SizedBox(
                            //           width: double.infinity,
                            //           child: Button(
                            //               child: Text('SHOW MORE'),
                            //               secondary: true,
                            //               onPressed: () {
                            //                 Navigator.of(context)
                            //                     .push(CupertinoPageRoute(
                            //                         builder: (_) => Container(
                            //                               color: Colors.white,
                            //                               child: Column(children: [
                            //                                 HikeeAppBar(
                            //                                   title:
                            //                                       Text('Reviews'),
                            //                                 ),
                            //                                 Padding(
                            //                                   padding:
                            //                                       const EdgeInsets
                            //                                           .all(16.0),
                            //                                   //child:
                            //                                   //_reviewList(null),
                            //                                 ),
                            //                               ]),
                            //                             )));
                            //               }),
                            //         ),
                            //       );
                            //     },
                            //     selector: (_, p) => p.items.length > 3)
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // if (!(Get.arguments?['hideButtons'] == true))
            //   Row(
            //     children: [
            //       Expanded(
            //         child: Button(
            //           radius: 0,
            //           safeArea: true,
            //           onPressed: () {
            //             HomeController hc = Get.find<HomeController>();
            //             hc.switchTab(0);
            //             CompassController cc = Get.find<CompassController>();
            //             cc.selectRoute(controller.state!);
            //             Get.back();
            //           },
            //           child: Text('Select Route'),
            //         ),
            //       ),
            //       Expanded(
            //         child: Button(
            //           radius: 0,
            //           safeArea: true,
            //           backgroundColor: Colors.teal,
            //           onPressed: () {
            //             Get.to(RouteEventsPage(),
            //                 transition: Transition.cupertino,
            //                 arguments: {'id': Get.arguments['id']},
            //                 binding: RouteEventsBinding());
            //           },
            //           child: Text('FIND EVENTS'),
            //         ),
            //       ),
            //     ],
            //   )
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  blurRadius: 16,
                  spreadRadius: -8,
                  color: Colors.black.withOpacity(.09),
                  offset: Offset(0, -6))
            ]),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    onPressed: () {
                      HomeController hc = Get.find<HomeController>();
                      hc.switchTab(0);
                      CompassController cc = Get.find<CompassController>();
                      cc.selectRoute(controller.state!);
                      Get.back();
                    },
                    child: Text('Select Now'),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Button(
                  onPressed: () {},
                  icon: Icon(Icons.public_outlined, color: Colors.white),
                ),
              ],
            ),
          )
        ]));
  }

  // Future<Map<String, dynamic>?> routeReviewDialog() async {
  //   return await showDialog<Map<String, dynamic>?>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return RouteReviewDialog(
  //         routeId: widget.id,
  //       );
  //     },
  //   );
  // }

  // Widget _reviewList(int? take) {
  //   return InfiniteScroll<RouteReviewsProvider, RouteReview>(
  //       take: take,
  //       init: take != null,
  //       empty: 'No reviews yet',
  //       shrinkWrap: true,
  //       selector: (p) => p.items,
  //       padding: EdgeInsets.zero,
  //       separator: SizedBox(height: 8),
  //       builder: (routeReview) {
  //         return RouteReviewTile(
  //           routeReview: routeReview,
  //         );
  //       },
  //       fetch: (next) {
  //         return context.read<RouteReviewsProvider>().fetch(next);
  //       });
  // }
}
