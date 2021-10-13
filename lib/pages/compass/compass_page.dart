import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/dropdown.dart';
import 'package:hikee/components/keep_alive.dart';
import 'package:hikee/components/mountain_deco.dart';
import 'package:hikee/components/route_elevation.dart';
import 'package:hikee/components/route_info.dart';
import 'package:hikee/components/sliding_up_panel.dart';
import 'package:hikee/data/distance_posts/reader.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/distance_post.dart';
import 'package:hikee/pages/compass/compass_controller.dart';
import 'package:hikee/pages/compass/weather_controller.dart';
import 'package:hikee/pages/home/home_controller.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/map_marker.dart';
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
              maxHeight: 296,
              minHeight: controller.collapsedPanelHeight,
              color: Colors.transparent,
              onPanelSlide: (position) {
                controller.panelPosition.value = position;
              },
              panel: Obx(() => _panel()),
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
                () => controller.started.value && controller.isCloseToGoal.value
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
                                  color: Colors.green.shade800,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Text('Swipe up to finish the route!',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 32),
                              child: ClipPath(
                                clipper: TriangleClipper(),
                                child: Container(
                                  color: Colors.green.shade800,
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
    if (controller.activeRoute.value == null) {
      return Container();
    }
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
            // decoration: BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(
            //             width: 1, color: Theme.of(context).dividerColor.withOpacity(.25)))),
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
                    if (controller.activeRoute.value!.isStarted) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.walking,
                            size: 30,
                            color: Get.theme.primaryColor,
                          ),
                          Container(width: 4),
                          Text(
                            GeoUtils.formatDistance(
                                controller.walkedDistance.value),
                            style: TextStyle(
                                fontSize: 28,
                                color: Get.theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.stopwatch,
                            size: 30,
                            color: Get.theme.primaryColor,
                          ),
                          Container(width: 4),
                          Text(
                            TimeUtils.formatSeconds(controller.elapsed.value),
                            style: TextStyle(
                                fontSize: 28,
                                color: Get.theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ],
                      )
                    ] else
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.isCloseToStart.value
                                  ? 'You\'re now at the start of the route'
                                  : 'You\'re far away from the route',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.primaryColor),
                            ),
                            Opacity(
                                opacity: .5,
                                child: Text(
                                    controller.isCloseToStart.value
                                        ? 'Swipe up to get start!'
                                        : 'Please reach to the starting point first',
                                    style: TextStyle(fontSize: 12)))
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _routeInfo(),
                  ),
                  KeepAlivePage(
                    key: Key(controller.activeRoute.value!.route.id.toString()),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: RouteElevation(
                        routeId: controller.activeRoute.value!.route.id,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      color: Color(0xFF5DB075),
      child: Obx(() {
        var hasActiveRoute = controller.activeRoute.value != null;
        return Stack(
          children: [
            if (hasActiveRoute)
              _map(controller.activeRoute.value!)
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
            SafeArea(
                child: Opacity(
                    opacity: 1 - controller.panelPosition.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
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
                                                      padding: EdgeInsets.only(
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
                                  DropdownMenu(),
                                  // Button(
                                  //   icon: Icon(LineAwesomeIcons.bars,
                                  //       color: Colors.white, size: 32),
                                  //   backgroundColor: Colors.transparent,
                                  //   onPressed: () {},
                                  // )
                                ],
                              ),
                              _weatherController.obx((weather) {
                                if (weather != null &&
                                    weather.warningMessage.length > 0) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.defaultDialog(
                                          title: 'Warning',
                                          content: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  weather.warningMessage
                                                      .join('\n'),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Button(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text('DISMISS'),
                                              )
                                            ],
                                          ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: 8.0, left: 8.0, right: 8.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.amber),
                                          color: Colors.amber.withOpacity(.8),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                              weather.warningMessage.join('\n'),
                                              style: TextStyle(
                                                  color: Colors.black),
                                              maxLines: 1),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text('Tap to view more details...',
                                              style: TextStyle(
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              }),
                            ],
                          ),
                        ),
                        if (!hasActiveRoute)
                          Expanded(
                              child: Center(
                            child: Button(
                              invert: true,
                              child: Text('Discover Routes'),
                              onPressed: () {
                                var hc = Get.find<HomeController>();
                                hc.switchTab(1);
                                Get.toNamed('/', id: 1);
                              },
                            ),
                          ))
                      ],
                    ))),
            if (hasActiveRoute)
              Positioned(
                right: 0,
                bottom: controller.collapsedPanelHeight + 8,
                child: Container(
                  //color: Colors.black,
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Button(
                            icon: Icon(
                              LineAwesomeIcons.expand,
                              color: Theme.of(context).primaryColor,
                            ),
                            invert: true,
                            onPressed: () {
                              controller.focusActiveRoute();
                            },
                          ),
                          Container(
                            height: 8,
                          ),
                          Button(
                            icon: Icon(
                              LineAwesomeIcons.map_marker,
                              color: Theme.of(context).primaryColor,
                            ),
                            invert: true,
                            onPressed: () {
                              controller.goToCurrentLocation();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _map(ActiveHikingRoute activeHikingRoute) {
    return Listener(
        onPointerDown: (e) {
          controller.lockPosition = false;
        },
        child: GoogleMap(
          padding: EdgeInsets.only(bottom: controller.collapsedPanelHeight + 8),
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          tiltGesturesEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: activeHikingRoute.decodedPath[0],
            zoom: 14,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          polylines: [
            Polyline(
              polylineId: PolylineId('polyLine1'),
              color: Colors.amber.shade400,
              zIndex: 1,
              width: 4,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              points: activeHikingRoute.decodedPath,
            ),
            Polyline(
              polylineId: PolylineId('polyLine2'),
              color: Colors.white,
              width: 6,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              zIndex: 0,
              points: activeHikingRoute.decodedPath,
            ),
          ].toSet(),
          // circles: [
          //   Circle(
          //       circleId: CircleId(
          //           'start-' + activeHikingRouteProvider.route!.id.toString()),
          //       center: activeHikingRouteProvider.decodedPath.first,
          //       fillColor: Colors.blue.withOpacity(.6),
          //       strokeWidth: 0,
          //       zIndex: 2,
          //       radius: 200),
          //   Circle(
          //       circleId: CircleId('start-border-' +
          //           activeHikingRouteProvider.route!.id.toString()),
          //       center: activeHikingRouteProvider.decodedPath.first,
          //       fillColor: Colors.blue.withOpacity(.3),
          //       strokeWidth: 0,
          //       zIndex: 2,
          //       radius: 300),
          //   Circle(
          //       circleId: CircleId(
          //           'end-' + activeHikingRouteProvider.route!.id.toString()),
          //       center: activeHikingRouteProvider.decodedPath.last,
          //       fillColor: Colors.red.withOpacity(.6),
          //       strokeWidth: 0,
          //       zIndex: 2,
          //       radius: 200),
          //   Circle(
          //       circleId: CircleId('end-border-' +
          //           activeHikingRouteProvider.route!.id.toString()),
          //       center: activeHikingRouteProvider.decodedPath.last,
          //       fillColor: Colors.red.withOpacity(.3),
          //       strokeWidth: 0,
          //       zIndex: 2,
          //       radius: 300),
          // ].toSet(),
          markers: [
            Marker(
              markerId: MarkerId('marker-start'),
              zIndex: 2,
              icon: MapMarker().start,
              position: activeHikingRoute.decodedPath.first,
            ),
            Marker(
              markerId: MarkerId('marker-end'),
              zIndex: 1,
              icon: MapMarker().end,
              position: activeHikingRoute.decodedPath.last,
            ),
            if (controller.nearestDistancePost.value != null)
              Marker(
                markerId: MarkerId('marker-distance-post'),
                zIndex: 999,
                icon: MapMarker().distancePost,
                position: controller.nearestDistancePost.value!.location,
              )
          ].toSet(),
          onMapCreated: (GoogleMapController mapController) async {
            mapController.setMapStyle(
                '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
            controller.mapController = Completer<GoogleMapController>();
            controller.mapController.complete(mapController);
          },
        ));
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

  Widget _routeInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        RouteInfo(
          route: controller.activeRoute.value!.route,
          showRouteName: true,
          hideRegion: true,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Obx(() {
            bool closeEnough = controller.isCloseToStart.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!controller.activeRoute.value!.isStarted)
                  Button(
                      child: Text('START NOW'),
                      backgroundColor:
                          closeEnough ? Get.theme.primaryColor : Colors.grey,
                      onPressed: () {
                        if (closeEnough) {
                          controller.startRoute();
                          controller.goToCurrentLocation();
                        } else {
                          _showFarAwayDialog();
                        }
                      })
                else
                  Button(
                      child: Text('FINISH ROUTE'),
                      disabled: !controller.isCloseToGoal.value,
                      onPressed: () {
                        controller.finishRoute();
                      }),
                // else
                //   Button(
                //       icon:
                //           Icon(LineAwesomeIcons.first_aid, color: Colors.white),
                //       backgroundColor: Colors.red[400],
                //       onPressed: () async {
                //         _showNearestDistancePostDialog();
                //       }),
                Container(width: 16),
                Button(
                    child: Text('QUIT ROUTE'),
                    backgroundColor: Colors.brown[300],
                    onPressed: () {
                      controller.quitRoute();
                    })
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
                Text('You\'re not at the start of the route'),
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
    DialogUtils.show(
        Get.context,
        FutureBuilder<DistancePost?>(
            future: DistancePostsReader.findClosestDistancePost(location),
            builder: (_, snapshot) {
              var nearestDistancePost = snapshot.data;
              if (snapshot.connectionState != ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (nearestDistancePost == null) {
                return Center(
                  child: Text('Distance post not found'),
                );
              }
              var distInKm = GeoUtils.calculateDistance(
                  nearestDistancePost.location, location);
              return Column(
                children: [
                  Text(
                    'The nearest distance post is',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Opacity(
                    opacity: .75,
                    child: Text(
                      'You\'re ${distInKm.toStringAsFixed(2)} km away from this distance post.',
                    ),
                  ),
                  Opacity(
                    opacity: .75,
                    child: Text(
                      'This may help the rescue team to locate you',
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      children: [
                        Text(nearestDistancePost.trail_name_en),
                        Text(nearestDistancePost.trail_name_zh),
                        Text(nearestDistancePost.no,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  Button(
                      child: Text('SHOW IN MAP'),
                      onPressed: () {
                        controller.showDistancePost(nearestDistancePost);
                        //Routemaster.of(context).pop();
                      }),
                ],
              );
            }),
        buttons: (context) => [
              Button(
                  child: Text('DIAL 999 NOW'),
                  backgroundColor: Colors.red,
                  onPressed: () {
                    launch("tel://999");
                    //Routemaster.of(context).pop();
                  }),
              Button(
                  child: Text('CANCEL'),
                  backgroundColor: Colors.black38,
                  onPressed: () {
                    //Routemaster.of(context).pop();
                  })
            ]);
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
