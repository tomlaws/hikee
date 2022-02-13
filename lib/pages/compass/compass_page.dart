import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/drag_marker.dart';
import 'package:hikee/components/elevation_profile.dart';
import 'package:hikee/components/map/map.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/themes.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:hikee/components/button.dart';
import 'package:hikee/components/compass.dart';
import 'package:hikee/components/keep_alive.dart';
import 'package:hikee/components/mountain_deco.dart';
import 'package:hikee/components/active_trail_info.dart';
import 'package:hikee/components/sliding_up_panel.dart';
import 'package:hikee/models/active_trail.dart';
import 'package:hikee/pages/compass/compass_controller.dart';
import 'package:hikee/pages/compass/weather_controller.dart';
import 'package:hikee/pages/home/home_controller.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CompassPage extends GetView<CompassController> {
  final _weatherController = Get.find<WeatherController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(children: [
        Container(
          child: SlidingUpPanel(
              controller: controller.panelController,
              renderPanelSheet: false,
              maxHeight: 320,
              minHeight: controller.collapsedPanelHeight,
              color: Colors.transparent,
              onPanelSlide: (position) {
                controller.panelPosition.value = position;
              },
              panel: Obx(() => controller.activeTrail.value == null
                  ? Container()
                  : _panel()),
              body: _body(context)),
        ),
        AnimatedBuilder(
          animation: controller.tooltipController,
          builder: (_, __) => Positioned(
              bottom: controller.panelPosition.value *
                      (296 - controller.collapsedPanelHeight) +
                  controller.collapsedPanelHeight +
                  10 +
                  controller.alpha.value,
              left: 0,
              child: Obx(
                () => controller.activeTrail.value?.isStarted == true &&
                        controller.activeTrailProvider.isCloseToGoal.value
                    ? Opacity(
                        opacity:
                            (1 - controller.panelPosition.value).clamp(0, 1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: Themes.gradientColors,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Text('Swipe up to finish the trail!',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 32),
                              child: ClipPath(
                                clipper: TriangleClipper(),
                                child: Container(
                                  color: Themes.gradientColors[0],
                                  height: 10,
                                  width: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              )),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Obx(
              () => Opacity(
                opacity: (1 - controller.panelPosition.value).clamp(0, 0.75),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.blueGrey.withOpacity(.1)
                        ],
                        begin: const FractionalOffset(0.0, 0.4),
                        end: const FractionalOffset(0.0, 1.0),
                        stops: [0.4, 1.0]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _panel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26), topRight: Radius.circular(26)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: kBottomNavigationBarHeight,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (_) {
                  if (controller.panelController.isPanelClosed) {
                    controller.panelController.open();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (controller.activeTrail.value!.isStarted) ...[
                      Expanded(
                          child: Obx(
                        () => Stack(children: [
                          Opacity(
                            opacity: 1 - controller.panelPosition.value,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  LineAwesomeIcons.walking,
                                  size: 24,
                                ),
                                Container(width: 4),
                                Obx(() {
                                  var t = controller.activeTrailProvider.tick
                                      .value; // do not remove this line
                                  return Text(
                                    GeoUtils.formatDistance(
                                        controller.activeTrail.value!.length),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  );
                                })
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: controller.panelPosition.value,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  LineAwesomeIcons.alternate_tachometer,
                                  size: 24,
                                ),
                                Container(width: 4),
                                Obx(() {
                                  var t = controller.activeTrailProvider.tick
                                      .value; // do not remove this line
                                  return Text(
                                    '${GeoUtils.formatDistance(controller.speed!)}/h',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  );
                                })
                              ],
                            ),
                          ),
                        ]),
                      )),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        color: Get.theme.dividerColor,
                        width: 1,
                        height: 24,
                      ),
                      Expanded(
                        child: Obx(
                          () => Stack(children: [
                            Opacity(
                              opacity: 1 - controller.panelPosition.value,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    LineAwesomeIcons.stopwatch,
                                    size: 24,
                                  ),
                                  Container(width: 4),
                                  Obx(() {
                                    var t = controller.activeTrailProvider.tick
                                        .value; // do not remove this line
                                    return Text(
                                      TimeUtils.formatSeconds(controller
                                          .activeTrail.value!.elapsed),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    );
                                  })
                                ],
                              ),
                            ),
                            Opacity(
                              opacity: controller.panelPosition.value,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    LineAwesomeIcons.hourglass_end,
                                    size: 24,
                                  ),
                                  Container(width: 4),
                                  Obx(() {
                                    var t = controller.activeTrailProvider.tick
                                        .value; // do not remove this line
                                    return Text(
                                      '${TimeUtils.formatSeconds(controller.estimatedFinishTime!)}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ]),
                        ),
                      )
                    ] else
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.activeTrailProvider.recordMode
                                  ? 'You\'re in recording mode'
                                  : controller.activeTrailProvider
                                          .isCloseToStart.value
                                      ? 'You\'re now at the start of the trail'
                                      : 'You\'re far away from the trail',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: controller.panelPosition.value == 1
                                      ? 0
                                      : 1,
                                  child: Text(
                                      controller.activeTrailProvider
                                                  .isCloseToStart.value ||
                                              controller.activeTrailProvider
                                                  .recordMode
                                          ? 'Swipe up to start recording!'
                                          : 'Please reach to the starting point first',
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Positioned(
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: controller.panelPosition.value == 1
                                        ? 1
                                        : 0,
                                    child: Text(
                                        controller
                                                .activeTrailProvider.recordMode
                                            ? 'Start when you\'re ready!'
                                            : controller.activeTrailProvider
                                                    .isCloseToStart.value
                                                ? 'Let\'s get started!'
                                                : 'Please reach to the starting point first',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                  ],
                ),
              );
            }),
          ),
          Expanded(
              child: Column(children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _pageIndicators(2, controller.panelPage.value),
              ),
            ),
            Container(),
            Expanded(child: Obx(() {
              return controller.panelPageController.value == null
                  ? SizedBox()
                  : PageView(
                      controller: controller.panelPageController.value,
                      children: [
                        _trailInfo(),
                        KeepAlivePage(
                          child: Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 8,
                              ),
                              child: Obx(() {
                                return Column(children: [
                                  if (controller.nearbyFacilities.value !=
                                          null &&
                                      controller
                                              .nearbyFacilities.value!.length >
                                          0)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MutationBuilder(mutation: () {
                                            return controller
                                                .discoverNearbyFacilities();
                                          }, builder: (mutate, loading) {
                                            return Button(
                                              height: 44,
                                              minWidth: 44,
                                              onPressed: () {
                                                mutate();
                                              },
                                              loading: loading,
                                              child: Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  spacing: 8.0,
                                                  children: [
                                                    Icon(
                                                      LineAwesomeIcons
                                                          .sync_icon,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    Text(
                                                      'Nearby Facilities',
                                                    )
                                                  ]),
                                            );
                                          }),
                                          MutationBuilder(mutation: () {
                                            return controller
                                                .discoverNearbyFacilities();
                                          }, builder: (mutate, loading) {
                                            return Button(
                                              height: 44,
                                              minWidth: 44,
                                              backgroundColor: Colors.red,
                                              onPressed: () {
                                                mutate();
                                              },
                                              loading: loading,
                                              child: Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  spacing: 8.0,
                                                  children: [
                                                    Icon(
                                                      LineAwesomeIcons.bell,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    Text(
                                                      'Emergency',
                                                    )
                                                  ]),
                                            );
                                          })
                                        ],
                                      ),
                                    ),
                                  Expanded(
                                      child:
                                          controller.nearbyFacilities.value !=
                                                      null &&
                                                  controller.nearbyFacilities
                                                          .value!.length >
                                                      0
                                              ? ListView.separated(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  itemBuilder: (_, i) {
                                                    var facility = controller
                                                        .nearbyFacilities
                                                        .value![i];
                                                    return Container(
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          boxShadow: [
                                                            Themes.lightShadow
                                                          ]),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                facility.name,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Obx(() => controller
                                                                          .currentLocation
                                                                          .value !=
                                                                      null
                                                                  ? Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 4),
                                                                      child:
                                                                          Text(
                                                                        '~' +
                                                                            GeoUtils.formatDistance(facility.calculateDistance(controller.currentLocation.value!.latLng)),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    )
                                                                  : SizedBox())
                                                            ],
                                                          )),
                                                          SizedBox(width: 16),
                                                          Button(
                                                            icon: Icon(
                                                              LineAwesomeIcons
                                                                  .map_marker,
                                                              //color: Colors.white,
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            onPressed: () {
                                                              controller
                                                                  .pinnedFacility
                                                                  .value = facility;
                                                              controller
                                                                  .mapController
                                                                  ?.focus(facility
                                                                      .location);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder: (_, __) =>
                                                      SizedBox(height: 8),
                                                  itemCount: controller
                                                      .nearbyFacilities
                                                      .value!
                                                      .length)
                                              : Center(
                                                  child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Opacity(
                                                        opacity: .6,
                                                        child: Text(controller
                                                                    .nearbyFacilities
                                                                    .value ==
                                                                null
                                                            ? 'Discover nearby facilities'
                                                            : 'No nearby facilities')),
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                    MutationBuilder(
                                                        mutation: () {
                                                      return controller
                                                          .discoverNearbyFacilities();
                                                    }, builder:
                                                            (mutate, loading) {
                                                      return Button(
                                                        onPressed: () {
                                                          mutate();
                                                        },
                                                        loading: loading,
                                                        child: Text(controller
                                                                    .nearbyFacilities
                                                                    .value ==
                                                                null
                                                            ? 'Discover facilities'
                                                            : 'Refresh'),
                                                      );
                                                    }),
                                                  ],
                                                )))
                                ]);
                              })),
                        )
                      ],
                    );
            }))
          ])),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Obx(() => Container(
          clipBehavior: Clip.none,
          color: controller.activeTrail.value != null
              ? Colors.white
              : Color.fromARGB(255, 64, 141, 97),
          child: Obx(() {
            var hasActiveTrail = controller.activeTrail.value != null;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                if (hasActiveTrail)
                  _map(controller.activeTrail.value!)
                else
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      clipper: MountainDeco(),
                      child: Container(
                        color: Colors.black.withOpacity(.05),
                        width: 400,
                        height: 400,
                      ),
                    ),
                  ),
                Opacity(
                    opacity: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(color: Colors.white),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: controller.activeTrail.value == null
                                  ? null
                                  : LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0, 1],
                                      colors: [
                                        Colors.black.withOpacity(.7),
                                        Colors.transparent
                                      ],
                                    ),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: SafeArea(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        height: controller.panelHeaderHeight,
                                        alignment: Alignment.centerLeft,
                                        child: _weatherController
                                            .obx((weather) => weather != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      launch(
                                                          'https://www.hko.gov.hk/en/index.html');
                                                    },
                                                    child: Row(
                                                      children: [
                                                        ...weather.icon
                                                            .map((no) =>
                                                                CachedNetworkImage(
                                                                  imageUrl:
                                                                      'https://www.hko.gov.hk/images/HKOWxIconOutline/pic$no.png',
                                                                  width: 30,
                                                                  height: 30,
                                                                ))
                                                            .toList(),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Text(
                                                              '${weather.temperature}°C',
                                                              style: TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox()),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 16),
                                        child: Compass(
                                          heading: controller.currentHeading,
                                        ),
                                      ),
                                      // DropdownMenu(),
                                      // Button(
                                      //   icon: Icon(LineAwesomeIcons.bars,
                                      //       color: Colors.white, size: 32),
                                      //   backgroundColor: Colors.transparent,
                                      //   onPressed: () {},
                                      // )
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  // _weatherController.obx((weather) {
                                  //   if (weather != null &&
                                  //       weather.warningMessage.length > 0) {
                                  //     return GestureDetector(
                                  //       onTap: () {
                                  //         Get.defaultDialog(
                                  //             title: 'Warning',
                                  //             content: Column(
                                  //               children: [
                                  //                 Padding(
                                  //                   padding: const EdgeInsets
                                  //                           .symmetric(
                                  //                       horizontal: 8.0),
                                  //                   child: Text(
                                  //                     weather.warningMessage
                                  //                         .join('\n'),
                                  //                     style: TextStyle(
                                  //                         color: Colors.black),
                                  //                   ),
                                  //                 ),
                                  //                 SizedBox(
                                  //                   height: 16,
                                  //                 ),
                                  //                 Button(
                                  //                   onPressed: () {
                                  //                     Get.back();
                                  //                   },
                                  //                   child: Text('DISMISS'),
                                  //                 )
                                  //               ],
                                  //             ));
                                  //       },
                                  //       child: Container(
                                  //         margin: EdgeInsets.only(
                                  //             bottom: 8.0,
                                  //             left: 8.0,
                                  //             right: 8.0),
                                  //         padding: EdgeInsets.all(8.0),
                                  //         decoration: BoxDecoration(
                                  //             border: Border.all(
                                  //                 color: Colors.amber),
                                  //             color:
                                  //                 Colors.amber.withOpacity(.8),
                                  //             borderRadius:
                                  //                 BorderRadius.circular(8.0)),
                                  //         child: Column(
                                  //           children: [
                                  //             Text(
                                  //                 weather.warningMessage
                                  //                     .join('\n'),
                                  //                 style: TextStyle(
                                  //                     color: Colors.black),
                                  //                 maxLines: 1),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     );
                                  //   }
                                  //   return SizedBox();
                                  // }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (!hasActiveTrail)
                          Expanded(
                              child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Button(
                                invert: true,
                                child: Text('Discover Trails'),
                                onPressed: () {
                                  var hc = Get.find<HomeController>();
                                  hc.switchTab(1);
                                  Get.toNamed('/', id: 1);
                                },
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Button(
                                invert: true,
                                child: Text('Record Trail'),
                                onPressed: () {
                                  controller.record();
                                },
                              )
                            ],
                          ))
                      ],
                    )),
              ],
            );
          }),
        ));
  }

  Widget _map(ActiveTrail activeTrail) {
    return Obx(() {
      var lock = controller.lockPosition.value; // do not remove this line
      List<DragMarker> markers = [];
      if (activeTrail.trail?.pins != null) {
        markers.addAll(activeTrail.trail!.pins!.map(
          (pos) => DragMarker(
            draggable: false,
            point: pos.location,
            width: 10,
            height: 10,
            hasPopup: pos.message != null,
            onTap: (_) {
              DialogUtils.showDialog("Message", pos.message!);
            },
          ),
        ));
      }
      if (controller.pinnedFacility.value != null) {
        markers.add(
          DragMarker(
            draggable: false,
            point: controller.pinnedFacility.value!.location,
            width: 10,
            height: 10,
            hasPopup: true,
            popupColor: Color.fromARGB(255, 64, 66, 196),
            popupIcon: LineAwesomeIcons.star,
            onTap: (_) {
              DialogUtils.showDialog(
                  "Facility", controller.pinnedFacility.value!.name);
            },
          ),
        );
      }
      return HikeeMap(
        key: Key('compass-map'),
        onMapCreated: (mapController) {
          controller.mapController = mapController;
        },
        path: activeTrail.trail?.path,
        userPath: controller.userPath,
        pathOnly: true,
        showCenterOnLocationUpdateButton: true,
        positionStream: controller.currentLocation.stream,
        headingStream: controller.currentHeading.stream,
        markers: markers,
        contentMargin: EdgeInsets.only(
            top: 8,
            left: 8,
            right: 8,
            bottom: controller.collapsedPanelHeight + 8),
      );
    });
  }

  List<Widget> _pageIndicators(int total, double currentPage) {
    List<Widget> list = [];
    for (int i = 0; i < total; i++) {
      bool isActive = i == currentPage.round();
      list.add(Container(
        height: 16,
        width: 16,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Get.theme.primaryColor : Color(0XFFEAEAEA),
          ),
        ),
      ));
    }
    return list;
  }

  Widget _trailInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Obx(
            () => Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.black.withOpacity(.05)))),
                margin: EdgeInsets.only(
                  bottom: 16.0,
                  top: 4.0,
                ),
                padding: const EdgeInsets.only(
                    top: 0, left: 8.0, right: 16.0, bottom: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() => ActiveTrailInfo(
                            activeTrail: controller.activeTrail.value!,
                            onEdit: controller.rename,
                          )),
                      SizedBox(height: 8),
                      Expanded(
                        child: ElevationProfile(
                          elevations: controller.activeTrailProvider.recordMode
                              ? controller.activeTrail.value!.userElevation
                              : controller.activeTrail.value!.trail!.elevations,
                          myLocation: controller.currentLocation.value?.latLng,
                        ),
                      ),
                    ])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Obx(() {
            bool closeEnough = controller.isCloseToStart.value;
            bool recordMode = controller.activeTrailProvider.recordMode;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!controller.activeTrail.value!.isStarted)
                  Expanded(
                    child: Button(
                        child: Text(controller.activeTrailProvider.recordMode
                            ? 'Start Recording'
                            : 'Start Now'),
                        backgroundColor: closeEnough || recordMode
                            ? Get.theme.primaryColor
                            : Colors.grey,
                        onPressed: () {
                          if (recordMode) {
                            controller.activeTrailProvider.start();
                            controller.mapController?.focusCurrentLocation();
                          } else if (closeEnough) {
                            controller.activeTrailProvider.start();
                            controller.mapController?.focusCurrentLocation();
                          } else {
                            _showFarAwayDialog();
                          }
                          controller.panelController.close();
                        }),
                  )
                else
                  Expanded(
                    child: Button(
                        child: Text(controller.activeTrailProvider.recordMode
                            ? 'Finish Recording'
                            : 'Finish Trail'),
                        onPressed: () {
                          controller.finishTrail();
                        }),
                  ),
                Container(width: 16),
                Expanded(
                  child: Button(
                      child: Text(controller.activeTrailProvider.recordMode
                          ? 'Quit Recording'
                          : 'Quit Trail'),
                      backgroundColor: Color.fromRGBO(109, 160, 176, 1),
                      onPressed: () {
                        controller.activeTrailProvider.quit();
                        controller.panelController.close();
                      }),
                )
              ],
            );
          }),
        ),
      ]),
    );
  }

  Future<void> _showFarAwayDialog() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seems too far away...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You\'re not at the start of the trail'),
                Text('Would you like to check how to reach there?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No, thanks'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                controller.googleMapDir();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNearestDistancePostDialog() {
    var location =
        controller.currentLocation.value ?? LatLng(22.3872078, 114.3777223);

    //location = const LatLng(22.3872078, 114.3777223);
    //   DialogUtils.show(
    //       Get.context,
    //       FutureBuilder<DistancePost?>(
    //           future: DistancePostsReader.findClosestDistancePost(location),
    //           builder: (_, snapshot) {
    //             var nearestDistancePost = snapshot.data;
    //             if (snapshot.connectionState != ConnectionState.done) {
    //               return Padding(
    //                 padding: const EdgeInsets.all(16.0),
    //                 child: Center(
    //                   child: CircularProgressIndicator(),
    //                 ),
    //               );
    //             }
    //             if (nearestDistancePost == null) {
    //               return Center(
    //                 child: Text('Distance post not found'),
    //               );
    //             }
    //             var distInKm = GeoUtils.calculateDistance(
    //                 nearestDistancePost.location, location);
    //             return Column(
    //               children: [
    //                 Text(
    //                   'The nearest distance post is',
    //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //                 ),
    //                 Opacity(
    //                   opacity: .75,
    //                   child: Text(
    //                     'You\'re ${distInKm.toStringAsFixed(2)} km away from this distance post.',
    //                   ),
    //                 ),
    //                 Opacity(
    //                   opacity: .75,
    //                   child: Text(
    //                     'This may help the rescue team to locate you',
    //                   ),
    //                 ),
    //                 Container(
    //                   height: 16,
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.all(16),
    //                   decoration: BoxDecoration(
    //                       color: Colors.black12,
    //                       borderRadius: BorderRadius.circular(8.0)),
    //                   child: Column(
    //                     children: [
    //                       Text(nearestDistancePost.trail_name_en),
    //                       Text(nearestDistancePost.trail_name_zh),
    //                       Text(nearestDistancePost.no,
    //                           style: TextStyle(
    //                               fontSize: 24, fontWeight: FontWeight.bold))
    //                     ],
    //                   ),
    //                 ),
    //                 Container(
    //                   height: 16,
    //                 ),
    //                 Button(
    //                     child: Text('SHOW IN MAP'),
    //                     onPressed: () {
    //                       controller.showDistancePost(nearestDistancePost);
    //                       //Trailmaster.of(context).pop();
    //                     }),
    //               ],
    //             );
    //           }),
    //       buttons: (context) => [
    //             Button(
    //                 child: Text('DIAL 999 NOW'),
    //                 backgroundColor: Colors.red,
    //                 onPressed: () {
    //                   launch("tel://999");
    //                   //Trailmaster.of(context).pop();
    //                 }),
    //             Button(
    //                 child: Text('CANCEL'),
    //                 backgroundColor: Colors.black38,
    //                 onPressed: () {
    //                   //Trailmaster.of(context).pop();
    //                 })
    //           ]);
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
