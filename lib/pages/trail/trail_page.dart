import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/avatar.dart';
import 'package:hikees/components/core/bottom_bar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/components/core/text_may_overflow.dart';
import 'package:hikees/components/map/drag_marker.dart';
import 'package:hikees/components/map/map.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/components/trails/trail_review_tile.dart';
import 'package:hikees/models/trail_review.dart';
import 'package:hikees/pages/compass/compass_controller.dart';
import 'package:hikees/pages/home/home_controller.dart';
import 'package:hikees/pages/trail/trail_controller.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/image.dart';
import 'package:hikees/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class TrailPage extends GetView<TrailController> {
  final _authProvider = Get.find<AuthProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: controller.offline
            ? HikeeAppBar(
                title: controller.obx(
                    (state) => TextMayOverflow(
                          state!.name,
                        ),
                    onLoading: Shimmer(width: 220, height: 30)),
                actions: [
                  Button(
                    onPressed: () {
                      controller.deleteOfflineTrail();
                    },
                    icon: Icon(Icons.delete),
                    invert: true,
                  )
                ],
              )
            : null,
        body: Column(children: [
          Expanded(
            child: RefreshIndicator(
                onRefresh: () async {
                  controller.refreshTrail();
                },
                child: Column(children: [
                  Expanded(
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
                                          if (!controller.offline)
                                            SizedBox(
                                              height: 280,
                                              child: controller.obx((state) {
                                                List<Widget> images = (state!
                                                                .images
                                                                .length ==
                                                            0
                                                        ? [state.image]
                                                        : state.images)
                                                    .map((img) =>
                                                        GestureDetector(
                                                          onTap: () =>
                                                              _fullscreen(img),
                                                          child:
                                                              CachedNetworkImage(
                                                            placeholder:
                                                                (_, __) =>
                                                                    Shimmer(),
                                                            imageUrl: ImageUtils
                                                                .imageLink(img),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ))
                                                    .toList();
                                                return Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16)),
                                                  child: PageView(
                                                    controller: controller
                                                        .carouselController,
                                                    children: images,
                                                  ),
                                                );
                                              }, onLoading: Shimmer()),
                                            )
                                          else
                                            Container(
                                              height: 30,
                                              width: double.infinity,
                                            ),
                                          Positioned(
                                              bottom: -40,
                                              left: controller.offline ? 0 : 16,
                                              right:
                                                  controller.offline ? 0 : 16,
                                              child: Container(
                                                padding: controller.offline
                                                    ? EdgeInsets.symmetric(
                                                        horizontal: 8)
                                                    : EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    boxShadow:
                                                        controller.offline
                                                            ? null
                                                            : [Themes.shadow],
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (controller.offline)
                                                      Text('info'.tr,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))
                                                    else
                                                      controller.obx(
                                                          (state) => TextMayOverflow(
                                                              state!.name,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          onLoading: Shimmer(
                                                            fontSize: 18,
                                                          )),
                                                    SizedBox(height: 8),
                                                    DefaultTextStyle(
                                                      style: TextStyle(
                                                          fontSize:
                                                              controller.offline
                                                                  ? null
                                                                  : 12,
                                                          color: controller
                                                                  .offline
                                                              ? Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .color
                                                              : Color(
                                                                  0xFFAAAAAA)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                  LineAwesomeIcons
                                                                      .map_marker,
                                                                  size: controller
                                                                          .offline
                                                                      ? 16
                                                                      : 12,
                                                                  color: Color(
                                                                      0xFFAAAAAA)),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              controller.obx(
                                                                  (state) =>
                                                                      Text(
                                                                        state!
                                                                            .region
                                                                            .name,
                                                                      ),
                                                                  onLoading:
                                                                      Shimmer(
                                                                    fontSize:
                                                                        12,
                                                                    width: 50,
                                                                  )),
                                                              SizedBox(
                                                                width: 16,
                                                              ),
                                                              Icon(
                                                                  LineAwesomeIcons
                                                                      .star,
                                                                  size: controller
                                                                          .offline
                                                                      ? 16
                                                                      : 12,
                                                                  color: Color(
                                                                      0xFFAAAAAA)),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              controller.obx(
                                                                  (state) =>
                                                                      Text(
                                                                        state!
                                                                            .rating
                                                                            .toString(),
                                                                      ),
                                                                  onLoading:
                                                                      Shimmer(
                                                                    fontSize:
                                                                        12,
                                                                    width: 30,
                                                                  )),
                                                            ],
                                                          ),
                                                          SizedBox(height: 4),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                  LineAwesomeIcons
                                                                      .ruler,
                                                                  size: controller
                                                                          .offline
                                                                      ? 16
                                                                      : 12,
                                                                  color: Color(
                                                                      0xFFAAAAAA)),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              controller.obx(
                                                                  (state) =>
                                                                      Text(
                                                                        GeoUtils.formatDistance(state!.length /
                                                                            1000),
                                                                      ),
                                                                  onLoading:
                                                                      Shimmer(
                                                                    fontSize:
                                                                        12,
                                                                    width: 30,
                                                                  )),
                                                              SizedBox(
                                                                width: 16,
                                                              ),
                                                              Icon(
                                                                  LineAwesomeIcons
                                                                      .clock,
                                                                  size: controller
                                                                          .offline
                                                                      ? 16
                                                                      : 12,
                                                                  color: Color(
                                                                      0xFFAAAAAA)),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              controller.obx(
                                                                  (state) =>
                                                                      Text(
                                                                        TimeUtils.formatMinutes(
                                                                            state!.duration),
                                                                      ),
                                                                  onLoading:
                                                                      Shimmer(
                                                                    fontSize:
                                                                        12,
                                                                    width: 30,
                                                                  )),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          if (!controller.offline)
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
                                                  if (!controller.offline)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Button(
                                                          invert: true,
                                                          radius: 36,
                                                          height: 36,
                                                          minWidth: 36,
                                                          icon: Icon(
                                                            Icons.download,
                                                            color:
                                                                Colors.black87,
                                                            size: 20,
                                                          ),
                                                          onPressed: () {
                                                            controller
                                                                .downloadTrail();
                                                          }),
                                                    ),
                                                  if (!controller.offline)
                                                    Obx(() =>
                                                        _authProvider
                                                                .loggedIn.value
                                                            ? controller.obx(
                                                                (state) {
                                                                var bookmarked =
                                                                    state!.bookmark !=
                                                                        null;
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                                  child:
                                                                      MutationBuilder(
                                                                          mutation: controller
                                                                              .toggleBookmark,
                                                                          builder:
                                                                              (mutate, loading) {
                                                                            return Button(
                                                                                invert: true,
                                                                                radius: 36,
                                                                                height: 36,
                                                                                minWidth: 36,
                                                                                loading: loading,
                                                                                icon: Icon(
                                                                                  bookmarked ? Icons.bookmark : Icons.bookmark_outline,
                                                                                  color: Colors.black87,
                                                                                  size: 20,
                                                                                ),
                                                                                onPressed: mutate);
                                                                          }),
                                                                );
                                                              },
                                                                onLoading:
                                                                    SizedBox())
                                                            : SizedBox()),
                                                  if (!controller.offline)
                                                    Button(
                                                        invert: true,
                                                        radius: 36,
                                                        height: 36,
                                                        minWidth: 36,
                                                        icon: Icon(
                                                          Icons.share,
                                                          color: Colors.black87,
                                                          size: 20,
                                                        ),
                                                        onPressed: () {
                                                          var t =
                                                              controller.state;
                                                          if (t != null)
                                                            Share.share(
                                                                '${t.name}\nhttps://hikees.com/trails/${t.id}');
                                                        })
                                                ],
                                              )),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: Text('creator'.tr,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ))),
                                          controller.obx(
                                              (state) => state?.creator != null
                                                  ? GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      onTap: () {
                                                        Get.toNamed(
                                                            '/profiles/${state!.creator!.id}');
                                                      },
                                                      child: Row(children: [
                                                        Avatar(
                                                            user:
                                                                state!.creator,
                                                            height: 24),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(state
                                                            .creator!.nickname)
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
                                                    colorClickableText:
                                                        Colors.pink,
                                                    trimMode: TrimMode.Line,
                                                    trimCollapsedText:
                                                        'showMore'.tr,
                                                    trimExpandedText:
                                                        'showLess'.tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        height: 1.6,
                                                        color: Get
                                                                .theme
                                                                .textTheme
                                                                .bodyText1
                                                                ?.color ??
                                                            Colors.black),
                                                    moreStyle: TextStyle(
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                    lessStyle: TextStyle(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
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
                                                      BorderRadius.circular(
                                                          16.0)),
                                              child: controller.obx((state) {
                                                var path = GeoUtils.decodePath(
                                                    state!.path);
                                                return HikeeMap(
                                                  key: Key(state.id.toString()),
                                                  path: path,
                                                  pathOnly: true,
                                                  offlineTrail:
                                                      controller.offline,
                                                  markers: state.pins == null
                                                      ? null
                                                      : state.pins!
                                                          .map(
                                                            (pos) => DragMarker(
                                                              draggable: false,
                                                              point:
                                                                  pos.location,
                                                              width: 10,
                                                              height: 10,
                                                              hasPopup:
                                                                  pos.message !=
                                                                      null,
                                                              onTap: (_) {
                                                                DialogUtils
                                                                    .showDialog(
                                                                        "message"
                                                                            .tr,
                                                                        pos.message!);
                                                              },
                                                              builder: (_, g) {
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
                                          if (!controller.offline)
                                            Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text('reviews'.tr,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Obx(() => _authProvider
                                                            .loggedIn.value
                                                        ? SizedBox(
                                                            height: 32,
                                                            width: 32,
                                                            child: Button(
                                                                icon: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .black38,
                                                                ),
                                                                invert: true,
                                                                onPressed: () {
                                                                  controller
                                                                      .addReview();
                                                                }),
                                                          )
                                                        : SizedBox())
                                                  ]),
                                            ),
                                          if (!controller.offline)
                                            InfiniteScroller(
                                              take: controller.takeReviews,
                                              padding:
                                                  EdgeInsets.only(top: 16.0),
                                              controller: controller
                                                  .trailReviewsController,
                                              separator: SizedBox(height: 16),
                                              empty: 'noReviews'.tr,
                                              footersBuilder: (hasMore) {
                                                if (hasMore) {
                                                  return [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 8.0),
                                                      child: Button(
                                                        backgroundColor: Colors
                                                            .grey.shade200,
                                                        minWidth:
                                                            double.infinity,
                                                        onPressed: () {
                                                          controller
                                                              .viewMoreReviews();
                                                        },
                                                        child:
                                                            Text('showMore'.tr),
                                                        invert: true,
                                                      ),
                                                    )
                                                  ];
                                                } else {
                                                  return [];
                                                }
                                              },
                                              builder:
                                                  (TrailReview trailReview) {
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
                ])),
          ),
          BottomBar(
            child: Row(
              children: [
                Expanded(
                  child: MutationBuilder(
                    mutation: () async {
                      HomeController hc = Get.find<HomeController>();
                      hc.switchTab(0);
                      CompassController cc = Get.find<CompassController>();
                      await cc.activeTrailProvider.select(controller.state!);
                      Navigator.of(context).popUntil((route) => route
                          .isFirst); // use navigator pop instead of get off here as it push new page instead of reusing the one alive
                    },
                    builder: (mutate, loading) => Button(
                      onPressed: mutate,
                      loading: loading,
                      child: Text('selectNow'.tr),
                    ),
                  ),
                ),
                if (!controller.offline) ...[
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
                ]
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
