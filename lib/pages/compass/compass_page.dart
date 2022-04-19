import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hikees/components/connection_error.dart';
import 'package:hikees/components/core/floating_tooltip.dart';
import 'package:hikees/components/trails/height_profile.dart';
import 'package:hikees/components/map/map.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/color.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/compass/compass.dart';
import 'package:hikees/components/core/keep_alive.dart';
import 'package:hikees/components/compass/mountain_deco.dart';
import 'package:hikees/components/compass/active_trail_info.dart';
import 'package:hikees/components/compass/sliding_up_panel.dart';
import 'package:hikees/pages/compass/compass_controller.dart';
import 'package:hikees/pages/compass/weather_controller.dart';
import 'package:hikees/pages/home/home_controller.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CompassPage extends GetView<CompassController> {
  final _weatherController = Get.find<WeatherController>();
  final _authProvider = Get.find<AuthProvider>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(children: [
        SlidingUpPanel(
            controller: controller.panelController,
            renderPanelSheet: false,
            maxHeight: controller.maxPanelHeight,
            minHeight: controller.collapsedPanelHeight,
            color: Colors.transparent,
            onPanelSlide: (position) {
              controller.panelPosition.value = position;
            },
            panel: Obx(() {
              if (controller.activeTrail.value == null) {
                return Container();
              } else {
                return _panel();
              }
            }),
            body: _body(context)),
        Obx(() => Positioned(
              bottom: controller.panelPosition.value *
                      (controller.maxPanelHeight -
                          controller.collapsedPanelHeight) +
                  controller.collapsedPanelHeight +
                  16,
              left: 8,
              child: controller.activeTrail.value?.isStarted == true &&
                      controller.activeTrailProvider.isCloseToGoal.value &&
                      !controller.activeTrailProvider.recordMode
                  ? Opacity(
                      opacity: 1 - controller.panelPosition.value,
                      child: FloatingTooltip(
                          animation: true,
                          child: Text('swipeUpToFinishTheTrail'.tr + '!',
                              style: TextStyle(fontWeight: FontWeight.w500))),
                    )
                  : SizedBox(),
            )),
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
                            opacity: controller.activeTrailProvider.recordMode
                                ? 1
                                : 1 - controller.panelPosition.value,
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
                                    GeoUtils.formatMetres(
                                        controller.activeTrail.value!.length),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  );
                                })
                              ],
                            ),
                          ),
                          if (!controller.activeTrailProvider.recordMode)
                            Opacity(
                              opacity: controller.panelPosition.value,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      '${GeoUtils.formatMetres(controller.speed!)}/h',
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
                              opacity: controller.activeTrailProvider.recordMode
                                  ? 1
                                  : 1 - controller.panelPosition.value,
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
                            if (!controller.activeTrailProvider.recordMode)
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
                                      var t = controller
                                          .activeTrailProvider
                                          .tick
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
                                  ? 'youreInRecordingMode'.tr
                                  : controller.activeTrailProvider
                                          .isCloseToStart.value
                                      ? 'youreNowAtTheStartOfTheTrail'.tr
                                      : 'youreFarAwayFromTheTrail'.tr,
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
                                          ? 'swipeUpToStartRecording'.tr
                                          : 'pleaseReachToTheStartingPointFirst'
                                              .tr,
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
                                            ? 'startWhenYoureReady'.tr
                                            : controller.activeTrailProvider
                                                    .isCloseToStart.value
                                                ? 'letsGetStarted'.tr
                                                : 'pleaseReachToTheStartingPointFirst'
                                                    .tr,
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
            Expanded(
                child: PageView(
              controller: controller.panelPageController,
              children: [_trailInfo(), _nearbyFacilities()],
            ))
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
                  _map()
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
                                        Colors.black.withOpacity(0),
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
                                        child: _weatherController.obx(
                                            (weather) => weather != null
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
                                                : SizedBox(),
                                            onError: (_) => SizedBox(),
                                            onLoading: SizedBox()),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 16),
                                        child: Compass(
                                          heading: controller.currentHeading,
                                        ),
                                      ),
                                    ],
                                  ),
                                  _weatherController.obx((weather) {
                                    if (weather != null &&
                                        weather.warningMessage.length > 0) {
                                      return Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            DialogUtils.showSimpleDialog(
                                                'warning'.tr,
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                      child: Text(
                                                        weather.warningMessage
                                                            .join('\n'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: 8.0,
                                                left: 8.0,
                                                right: 8.0),
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.amber),
                                                color: Colors.amber
                                                    .withOpacity(.58),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            child: Column(
                                              children: [
                                                Text(
                                                  weather.warningMessage
                                                      .join('\n'),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  },
                                      onError: (_) => SizedBox(),
                                      onLoading: SizedBox()),
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
                                child: Text(
                                  'discoverTrails'.tr,
                                  style: TextStyle(
                                      color: ColorUtils.darken(
                                          Get.theme.primaryColor, 0.2)),
                                ),
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
                                child: Text('recordTrail'.tr,
                                    style: TextStyle(
                                        color: ColorUtils.darken(
                                            Get.theme.primaryColor, 0.2))),
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

  Widget _map() {
    return Obx(() {
      var activeTrail = controller.activeTrail.value!;
      var lock = controller.lockPosition.value; // do not remove this line

      return HikeeMap(
        key: Key('compass-map-${activeTrail.hashCode}'),
        onMapCreated: (mapController) {
          controller.mapController = mapController;
        },
        onLongPress: (location) {
          controller.promptAddMarker(location);
        },
        offlineTrail: activeTrail.offline,
        path: activeTrail.originalPath,
        userPath: controller.userPath,
        pathOnly: true,
        zoom: 10,
        showCenterOnLocationUpdateButton: true,
        positionStream: controller.currentLocation.stream,
        headingStream: controller.currentHeading.stream,
        markers: controller.mapMarkers,
        heightData: false,
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
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.black.withOpacity(.05)))),
              margin: EdgeInsets.only(
                bottom: 16.0,
                top: 4.0,
              ),
              padding: const EdgeInsets.only(
                  top: 0, left: 8.0, right: 16.0, bottom: 0.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() => ActiveTrailInfo(
                          activeTrail: controller.activeTrail.value!,
                          onEdit: () async {
                            await controller.customizeRecord();
                          },
                        )),
                    SizedBox(height: 8),
                    Expanded(
                        child: HeightProfile(
                      header: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${GeoUtils.formatMetres(controller.activeTrailLength)}',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black54),
                            ),
                            Text(
                              '/',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black54),
                            ),
                            Text(
                              TimeUtils.formatMinutes(
                                  controller.activeTrailDuration),
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black54),
                            ),
                          ]),
                      heights: controller.activeTrail.value!.originalHeights ??
                          controller.activeTrail.value!.userHeights,
                      myLocation: controller.currentLocation.value?.latLng,
                    )),
                  ])),
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
                            ? 'startRecording'.tr
                            : 'startNow'.tr),
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
                    child: MutationBuilder(mutation: () {
                      return controller.finishTrail();
                    }, builder: (mutate, loading) {
                      return Button(
                          loading: loading,
                          child: Text(controller.activeTrailProvider.recordMode
                              ? 'finishRecording'.tr
                              : 'finishTrail'.tr),
                          disabled: (!controller
                                      .activeTrailProvider.recordMode &&
                                  !controller.isCloseToGoal.value) ||
                              controller.activeTrail.value!.userPath.length ==
                                  0,
                          onPressed: () {
                            mutate();
                          });
                    }),
                  ),
                Container(width: 16),
                Expanded(
                  child: Button(
                      child: Text(controller.activeTrailProvider.recordMode
                          ? 'quitRecording'.tr
                          : 'quitTrail'.tr),
                      secondary: true,
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

  Widget _nearbyFacilities() {
    return KeepAlivePage(
      child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
          ),
          child: Obx(() {
            return Column(children: [
              if (controller.nearbyFacilities.value != null &&
                  controller.nearbyFacilities.value!.length > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MutationBuilder(mutation: () {
                        return controller.discoverNearbyFacilities();
                      }, builder: (mutate, loading) {
                        return Button(
                          height: 44,
                          minWidth: 44,
                          onPressed: () {
                            mutate();
                          },
                          loading: loading,
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8.0,
                              children: [
                                Icon(
                                  LineAwesomeIcons.sync_icon,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                Text(
                                  'nearbyFacilities'.tr,
                                )
                              ]),
                        );
                      }),
                      MutationBuilder(mutation: () {
                        return controller.discoverNearbyFacilities();
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
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8.0,
                              children: [
                                Icon(
                                  LineAwesomeIcons.bell,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                Text(
                                  'emergency'.tr,
                                )
                              ]),
                        );
                      })
                    ],
                  ),
                ),
              Expanded(
                  child: controller.nearbyFacilities.value != null &&
                          controller.nearbyFacilities.value!.length > 0
                      ? ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (_, i) {
                            var facility =
                                controller.nearbyFacilities.value![i];
                            return Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [Themes.lightShadow]),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        facility.localizedName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Obx(() => controller
                                                  .currentLocation.value !=
                                              null
                                          ? Container(
                                              margin: EdgeInsets.only(top: 4),
                                              child: Text(
                                                '~' +
                                                    GeoUtils.formatMetres(facility
                                                        .calculateDistance(
                                                            controller
                                                                .currentLocation
                                                                .value!
                                                                .latLng)),
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            )
                                          : SizedBox())
                                    ],
                                  )),
                                  SizedBox(width: 16),
                                  Button(
                                    icon: Icon(LineAwesomeIcons.thumbtack,
                                        color: Colors.black54),
                                    backgroundColor: Colors.grey.shade100,
                                    onPressed: () {
                                      controller.addMarker(
                                          location: facility.location,
                                          title: facility.localizedName);
                                      controller.mapController
                                          ?.focus(facility.location);
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(height: 8),
                          itemCount: controller.nearbyFacilities.value!.length)
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                                opacity: .6,
                                child: Text(
                                    controller.nearbyFacilities.value == null
                                        ? 'discoverNearbyFacilities'.tr
                                        : 'noNearbyFacilities'.tr)),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MutationBuilder(mutation: () {
                                  return controller.discoverNearbyFacilities();
                                }, builder: (mutate, loading) {
                                  return Button(
                                    onPressed: () {
                                      mutate();
                                    },
                                    loading: loading,
                                    child: Text(
                                        controller.nearbyFacilities.value ==
                                                null
                                            ? 'discoverFacilities'.tr
                                            : 'refresh'.tr),
                                  );
                                }),
                                SizedBox(
                                  width: 8,
                                ),
                                MutationBuilder(mutation: () {
                                  return controller.emergency();
                                }, builder: (mutate, loading) {
                                  return Button(
                                    backgroundColor: Colors.red,
                                    onPressed: () {
                                      mutate();
                                    },
                                    loading: loading,
                                    child: Text('emergency'.tr),
                                  );
                                }),
                              ],
                            )
                          ],
                        )))
            ]);
          })),
    );
  }

  Future<void> _showFarAwayDialog() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('seemsTooFarAway'.tr + '...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('youreNotAtTheStartOfTheTrail'.tr),
                Text('wouldYouLikeToCheckHowToReachThere'.tr),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('noThanks'.tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('yes'.tr),
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
}
