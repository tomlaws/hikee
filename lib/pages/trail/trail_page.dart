import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/avatar.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/mutation_builder.dart';
import 'package:hikee/components/core/text_may_overflow.dart';
import 'package:hikee/components/map/drag_marker.dart';
import 'package:hikee/components/map/map.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/components/trails/trail_review_tile.dart';
import 'package:hikee/models/trail_review.dart';
import 'package:hikee/pages/compass/compass_controller.dart';
import 'package:hikee/pages/home/home_controller.dart';
import 'package:hikee/pages/trail/trail_controller.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/image.dart';
import 'package:hikee/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:photo_view/photo_view.dart';

class TrailPage extends GetView<TrailController> {
  final _authProvider = Get.find<AuthProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.refreshTrail();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                        List<Widget> images = (state!
                                                        .images.length ==
                                                    0
                                                ? [state.image]
                                                : state.images)
                                            .map((img) => GestureDetector(
                                                  onTap: () => _fullscreen(img),
                                                  child: CachedNetworkImage(
                                                    placeholder: (_, __) =>
                                                        Shimmer(),
                                                    imageUrl:
                                                        ImageUtils.imageLink(
                                                            img),
                                                    fit: BoxFit.cover,
                                                  ),
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
                                                  (state) => TextMayOverflow(
                                                      state!.name,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
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
                                                          color: Color(
                                                              0xFFAAAAAA)),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      controller.obx(
                                                          (state) => Text(
                                                                state!.region
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xFFAAAAAA)),
                                                              ),
                                                          onLoading: Shimmer(
                                                            fontSize: 12,
                                                            width: 50,
                                                          )),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      Icon(
                                                          LineAwesomeIcons.star,
                                                          size: 12,
                                                          color: Color(
                                                              0xFFAAAAAA)),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      controller.obx(
                                                          (state) => Text(
                                                                state!.rating
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xFFAAAAAA)),
                                                              ),
                                                          onLoading: Shimmer(
                                                            fontSize: 12,
                                                            width: 30,
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                          LineAwesomeIcons
                                                              .ruler,
                                                          size: 12,
                                                          color: Color(
                                                              0xFFAAAAAA)),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      controller.obx(
                                                          (state) => Text(
                                                                GeoUtils.formatDistance(
                                                                    state!.length /
                                                                        1000),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xFFAAAAAA)),
                                                              ),
                                                          onLoading: Shimmer(
                                                            fontSize: 12,
                                                            width: 30,
                                                          )),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      Icon(
                                                          LineAwesomeIcons
                                                              .clock,
                                                          size: 12,
                                                          color: Color(
                                                              0xFFAAAAAA)),
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
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xFFAAAAAA)),
                                                              ),
                                                          onLoading: Shimmer(
                                                            fontSize: 12,
                                                            width: 30,
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
                                        right: 16,
                                        top: 16,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Obx(() => _authProvider
                                                    .loggedIn.value
                                                ? Positioned(
                                                    top: 16,
                                                    right: 64,
                                                    child:
                                                        controller.obx((state) {
                                                      var bookmarked =
                                                          state!.bookmark !=
                                                              null;
                                                      return MutationBuilder(
                                                          mutation: controller
                                                              .toggleBookmark,
                                                          builder: (mutate,
                                                              loading) {
                                                            return Button(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 36,
                                                                height: 36,
                                                                minWidth: 36,
                                                                loading:
                                                                    loading,
                                                                icon: Icon(
                                                                  bookmarked
                                                                      ? Icons
                                                                          .bookmark
                                                                      : Icons
                                                                          .bookmark_outline,
                                                                  color: Colors
                                                                      .black87,
                                                                  size: 20,
                                                                ),
                                                                onPressed:
                                                                    mutate);
                                                          });
                                                    }, onLoading: SizedBox()))
                                                : SizedBox()),
                                            // Button(
                                            //     backgroundColor: Colors.white,
                                            //     radius: 36,
                                            //     height: 36,
                                            //     minWidth: 36,
                                            //     icon: Icon(
                                            //       Icons.share,
                                            //       color: Colors.black87,
                                            //       size: 20,
                                            //     ),
                                            //     onPressed: () {})
                                          ],
                                        )),
                                  ]),
                            ),
                            SizedBox(
                              height: 48,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text('creator'.tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                    controller.obx(
                                        (state) => state?.creator != null
                                            ? GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  Get.toNamed(
                                                      '/profiles/${state!.creator!.id}');
                                                },
                                                child: Row(children: [
                                                  Avatar(
                                                      user: state!.creator,
                                                      height: 24),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(state.creator!.nickname)
                                                ]),
                                              )
                                            : Text('afcd'.tr),
                                        onLoading: Row(children: [
                                          Avatar(user: null, height: 24),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Shimmer(
                                            width: 60,
                                          )
                                        ])),
                                    Container(
                                      height: 8,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, bottom: 12.0),
                                        child: Text('description'.tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                    controller.obx(
                                        (state) => ReadMoreText(
                                              state!.description,
                                              trimLines: 3,
                                              colorClickableText: Colors.pink,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: 'showMore'.tr,
                                              trimExpandedText: 'showLess'.tr,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  height: 1.6,
                                                  color: Get.theme.textTheme
                                                          .bodyText1?.color ??
                                                      Colors.black),
                                              moreStyle: TextStyle(
                                                color: Get.theme.colorScheme
                                                    .secondary,
                                              ),
                                              lessStyle: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .secondary),
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
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        child: controller.obx((state) {
                                          var path =
                                              GeoUtils.decodePath(state!.path);
                                          return HikeeMap(
                                            path: path,
                                            pathOnly: true,
                                            markers: state.pins == null
                                                ? null
                                                : state.pins!
                                                    .map(
                                                      (pos) => DragMarker(
                                                        draggable: false,
                                                        point: pos.location,
                                                        width: 10,
                                                        height: 10,
                                                        hasPopup:
                                                            pos.message != null,
                                                        onTap: (_) {
                                                          DialogUtils
                                                              .showDialog(
                                                                  "message".tr,
                                                                  pos.message!);
                                                        },
                                                        builder: (_) {
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                    .toList(),
                                          );
                                        },
                                            onLoading: Shimmer(
                                              height: 240,
                                            ))),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('reviews'.tr,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: 32,
                                              width: 32,
                                              child: Button(
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.black38,
                                                  ),
                                                  invert: true,
                                                  onPressed: () {
                                                    controller.addReview();
                                                  }),
                                            )
                                          ]),
                                    ),
                                    InfiniteScroller(
                                      take: controller.takeReviews,
                                      padding: EdgeInsets.only(top: 16.0),
                                      controller:
                                          controller.trailReviewsController,
                                      separator: SizedBox(height: 16),
                                      empty: 'noReviews'.tr,
                                      footersBuilder: (hasMore) {
                                        if (hasMore) {
                                          return [
                                            Container(
                                              margin: EdgeInsets.only(top: 8.0),
                                              child: Button(
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                minWidth: double.infinity,
                                                onPressed: () {
                                                  controller.viewMoreReviews();
                                                },
                                                child: Text('showMore'.tr),
                                                invert: true,
                                              ),
                                            )
                                          ];
                                        } else {
                                          return [];
                                        }
                                      },
                                      builder: (TrailReview trailReview) {
                                        return TrailReviewTile(
                                            contained: false,
                                            trailReview: trailReview);
                                      },
                                    ),
                                  ]),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, boxShadow: [Themes.bottomBarShadow]),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    onPressed: () {
                      HomeController hc = Get.find<HomeController>();
                      hc.switchTab(0);
                      CompassController cc = Get.find<CompassController>();
                      cc.activeTrailProvider.select(controller.state!);
                      Navigator.of(context).popUntil((route) => route
                          .isFirst); // use navigator pop instead of get off here as it push new page instead of reusing the one alive
                    },
                    child: Text('selectNow'.tr),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Button(
                    secondary: true,
                    onPressed: () {
                      if (controller.state != null)
                        Get.toNamed('/trails/events/${controller.state!.id}');
                    },
                    child: Text('findEvents'.tr),
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  _fullscreen(String image) {
    var widget = Scaffold(
      appBar: HikeeAppBar(title: Text("gallery".tr)),
      backgroundColor: Colors.black,
      body: controller.obx(
          (state) => (state?.images == null || state?.images.length == 0)
              ? SizedBox()
              : Column(children: [
                  Expanded(
                    child: CarouselSlider(
                      options: CarouselOptions(
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                          initialPage: state!.images.indexOf(image),
                          height: double.infinity),
                      items: state.images
                          .map((e) => Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: PhotoView(
                                imageProvider: CachedNetworkImageProvider(
                                    ImageUtils.imageLink(e)),
                              )))
                          .toList(),
                    ),
                  )
                ]),
          onLoading: SizedBox()),
    );
    Get.to(widget, transition: Transition.zoom, fullscreenDialog: true);
  }
}
