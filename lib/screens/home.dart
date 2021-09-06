import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
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
import 'package:hikee/models/current_location.dart';
import 'package:hikee/models/distance_post.dart';
import 'package:hikee/models/hiking_stat.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/models/weather.dart';
import 'package:hikee/services/weather.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/map_marker.dart';
import 'package:hikee/utils/time.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  WeatherService get weatherService => GetIt.I<WeatherService>();
  PanelController _pc = PanelController();
  final double _collapsedPanelHeight = kBottomNavigationBarHeight;
  final double _panelHeaderHeight = 60;
  Completer<GoogleMapController> _mapController = Completer();
  bool _lockPosition = true;
  HikingRoute? _activeRoute;
  DistancePost? _nearestDistancePost;
  ValueNotifier<double> _panelPosition = ValueNotifier(0.0);
  ValueNotifier<double> _panelPage = ValueNotifier(0.0);
  PageController _panelPageController = PageController(
    initialPage: 0,
  );
  ValueNotifier<Weather?> _weather = ValueNotifier(null);
  Timer? _weatherTimer;

  @override
  void initState() {
    super.initState();
    updateWeather();
    _weatherTimer =
        Timer.periodic(Duration(minutes: 5), (Timer t) => updateWeather());
  }

  @override
  void dispose() {
    _weatherTimer?.cancel();
    _panelPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    HikingRoute? route =
        Provider.of<ActiveHikingRoute>(context, listen: true).route;
    if (route != _activeRoute) {
      if (route == null && _activeRoute != null) {
        _pc.close();
      }
      _activeRoute = route;
      if (_activeRoute != null) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Routemaster.of(context).push('/');
          Future.delayed(const Duration(milliseconds: 10), () {
            _focusActiveRoute();
          });
        });
        _lockPosition = false;
      }
    }
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(children: [
        Container(
          child: SlidingUpPanel(
              controller: _pc,
              renderPanelSheet: false,
              maxHeight: 296,
              minHeight: _collapsedPanelHeight,
              color: Colors.transparent,
              onPanelSlide: (position) {
                _panelPosition.value = position;
              },
              panel: _panel(),
              body: _body()),
        ),
        ValueListenableBuilder<double>(
          valueListenable: _panelPosition,
          builder: (_, panelPosition, __) => Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: (1 - panelPosition).clamp(0, 0.75),
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
    if (_activeRoute == null) {
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
            child: Consumer2<ActiveHikingRoute, HikingStat>(
                builder: (_, activeHikingRoute, hikingStat, __) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (_) {
                  if (_pc.isPanelClosed) {
                    _pc.open();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (activeHikingRoute.isStarted) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.walking,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                          Container(width: 4),
                          Text(
                            GeoUtils.formatDistance(hikingStat.walkedDistance),
                            style: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).primaryColor,
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
                            color: Theme.of(context).primaryColor,
                          ),
                          Container(width: 4),
                          Text(
                            TimeUtils.formatSeconds(hikingStat.elapsed),
                            style: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).primaryColor,
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
                              hikingStat.isFarAwayFromStart
                                  ? 'You\'re far away from the route'
                                  : 'You\'re now at the start of the route',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Opacity(
                                opacity: .5,
                                child: Text(
                                    hikingStat.isFarAwayFromStart
                                        ? 'Please reach to the starting point first'
                                        : 'Swipe up to get start!',
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
            ValueListenableBuilder<double>(
              valueListenable: _panelPage,
              builder: (context, panelPage, _) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _pageIndicators(2, panelPage),
              ),
            ),
            Container(),
            Expanded(
              child: PageView(
                controller: _panelPageController
                  ..addListener(() {
                    _panelPage.value = _panelPageController.page ?? 0;
                  }),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _routeInfo(),
                  ),
                  KeepAlivePage(
                    key: Key(_activeRoute!.id.toString()),
                    child: RouteElevation(
                      routeId: _activeRoute!.id,
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

  Widget _body() {
    return Container(
      clipBehavior: Clip.none,
      color: Color(0xFF5DB075),
      child: Consumer<ActiveHikingRoute>(
          builder: (_, activeHikingRouteProvider, __) => Stack(
                children: [
                  if (activeHikingRouteProvider.route != null)
                    _map(activeHikingRouteProvider)
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
                    child: ValueListenableBuilder<double>(
                      valueListenable: _panelPosition,
                      builder: (_, panelPosition, __) => Opacity(
                          opacity: 1 - panelPosition,
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
                                          height: _panelHeaderHeight,
                                          alignment: Alignment.centerLeft,
                                          child:
                                              ValueListenableBuilder<Weather?>(
                                                  valueListenable: _weather,
                                                  builder: (_, weather, __) =>
                                                      weather != null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                launch(
                                                                    'https://www.hko.gov.hk/en/index.html');
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  ...weather
                                                                      .icon
                                                                      .map((no) =>
                                                                          CachedNetworkImage(
                                                                            imageUrl:
                                                                                'https://www.hko.gov.hk/images/HKOWxIconOutline/pic$no.png',
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                30,
                                                                          ))
                                                                      .toList(),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                8),
                                                                    child: Text(
                                                                        '${weather.temperature}°C',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                24,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
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
                                    ValueListenableBuilder<Weather?>(
                                        valueListenable: _weather,
                                        builder: (_, weather, __) {
                                          if (weather != null &&
                                              weather.warningMessage.length >
                                                  0) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 8.0,
                                                  left: 8.0,
                                                  right: 8.0),
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.amber),
                                                  color: Colors.amber
                                                      .withOpacity(.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.warning,
                                                    color: Colors.black,
                                                  ),
                                                  Container(width: 8),
                                                  Expanded(
                                                    child: Wrap(
                                                        children: weather
                                                            .warningMessage
                                                            .map((m) => Text(
                                                                  m,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ))
                                                            .toList()),
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                          return SizedBox();
                                        })
                                  ],
                                ),
                              ),
                              if (activeHikingRouteProvider.route == null)
                                Expanded(
                                    child: Center(
                                  child: Button(
                                    invert: true,
                                    child: Text('Discover Routes'),
                                    onPressed: () {
                                      Routemaster.of(context).push('/routes');
                                    },
                                  ),
                                ))
                            ],
                          )),
                    ),
                  ),
                  if (activeHikingRouteProvider.route != null)
                    Positioned(
                      right: 0,
                      bottom: _collapsedPanelHeight + 8,
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
                                    _focusActiveRoute();
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
                                    _goToCurrentLocation();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              )),
    );
  }

  Widget _map(ActiveHikingRoute activeHikingRouteProvider) {
    return Listener(
        onPointerDown: (e) {
          _lockPosition = false;
        },
        child: GoogleMap(
          padding: EdgeInsets.only(bottom: _collapsedPanelHeight + 8),
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          tiltGesturesEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: activeHikingRouteProvider.decodedPath![0],
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
              points: activeHikingRouteProvider.decodedPath!,
            ),
            Polyline(
              polylineId: PolylineId('polyLine2'),
              color: Colors.white,
              width: 6,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              zIndex: 0,
              points: activeHikingRouteProvider.decodedPath!,
            ),
          ].toSet(),
          // circles: [
          //   Circle(
          //       circleId: CircleId(
          //           'start-' + activeHikingRouteProvider.route!.id.toString()),
          //       center: activeHikingRouteProvider.decodedPath!.first,
          //       fillColor: Colors.blue.withOpacity(.6),
          //       strokeWidth: 0,
          //       zIndex: 2,
          //       radius: 200),
          //   Circle(
          //       circleId: CircleId('start-border-' +
          //           activeHikingRouteProvider.route!.id.toString()),
          //       center: activeHikingRouteProvider.decodedPath!.first,
          //       fillColor: Colors.blue.withOpacity(.3),
          //       strokeWidth: 0,
          //       zIndex: 2,
          //       radius: 300),
          //   Circle(
          //       circleId: CircleId(
          //           'end-' + activeHikingRouteProvider.route!.id.toString()),
          //       center: activeHikingRouteProvider.decodedPath!.last,
          //       fillColor: Colors.red.withOpacity(.6),
          //       strokeWidth: 0,
          //       zIndex: 2,
          //       radius: 200),
          //   Circle(
          //       circleId: CircleId('end-border-' +
          //           activeHikingRouteProvider.route!.id.toString()),
          //       center: activeHikingRouteProvider.decodedPath!.last,
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
              position: activeHikingRouteProvider.decodedPath!.first,
            ),
            Marker(
              markerId: MarkerId('marker-end'),
              zIndex: 1,
              icon: MapMarker().end,
              position: activeHikingRouteProvider.decodedPath!.last,
            ),
            if (_nearestDistancePost != null)
              Marker(
                markerId: MarkerId('marker-distance-post'),
                zIndex: 999,
                icon: MapMarker().distancePost,
                position: _nearestDistancePost!.location,
                // onTap: () {
                //   _showNearestDistancePostDialog(_nearestDistancePost!, );
                // }
              )
          ].toSet(),
          onMapCreated: (GoogleMapController controller) async {
            controller.setMapStyle(
                '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
            _mapController = Completer<GoogleMapController>();
            _mapController.complete(controller);
            var stream = Provider.of<CurrentLocation>(context, listen: false)
                .onLocationChanged;
            stream.listen((event) {
              if (_lockPosition) {
                _goToCurrentLocation();
              }
            });
          },
        ));
  }

  Future<void> _goToCurrentLocation() async {
    try {
      _lockPosition = true;
      var location =
          Provider.of<CurrentLocation>(context, listen: false).location;
      if (location == null) return;
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: location,
          zoom: 14.0,
        ),
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showDistancePost(DistancePost dp) async {
    try {
      _lockPosition = false;
      var location = dp.location;
      setState(() {
        _nearestDistancePost = dp;
      });
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: location,
          zoom: 16.0,
        ),
      ));
    } catch (e) {
      print(e);
    }
  }

  void _focusActiveRoute() async {
    var decodedPath =
        Provider.of<ActiveHikingRoute>(context, listen: false).decodedPath;
    if (decodedPath == null) return;
    _lockPosition = false;
    //print('focus');
    final GoogleMapController controller = await _mapController.future;
    controller.moveCamera(
        CameraUpdate.newLatLngBounds(GeoUtils.getPathBounds(decodedPath), 20));
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
            color:
                isActive ? Theme.of(context).primaryColor : Color(0XFFEAEAEA),
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
          route: _activeRoute!,
          showRouteName: true,
          hideRegion: true,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Consumer2<ActiveHikingRoute, HikingStat>(
              builder: (_, activeHikingRoute, hikingStat, ___) {
            bool closeEnough = !hikingStat.isFarAwayFromStart;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!activeHikingRoute.isStarted)
                  Button(
                      child: Text('START NOW'),
                      backgroundColor: closeEnough
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      onPressed: () {
                        if (closeEnough) {
                          activeHikingRoute.startRoute();
                          _goToCurrentLocation();
                        } else {
                          _showFarAwayDialog();
                        }
                      })
                else
                  Button(
                      child: Text('EMERGENCY'),
                      backgroundColor: Colors.red,
                      onPressed: () async {
                        _showNearestDistancePostDialog();
                      }),
                Container(width: 16),
                Button(
                    child: Text('QUIT ROUTE'),
                    onPressed: () {
                      activeHikingRoute.quitRoute();
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
      context: context,
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
                Routemaster.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Routemaster.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNearestDistancePostDialog() {
    var location =
        Provider.of<CurrentLocation>(context, listen: false).location;
    location = const LatLng(22.3872078, 114.3777223);
    DialogUtils.show(
        context,
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
                  nearestDistancePost.location, location!);
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
                        _showDistancePost(nearestDistancePost);
                        Routemaster.of(context).pop();
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
                    Routemaster.of(context).pop();
                  }),
              Button(
                  child: Text('CANCEL'),
                  backgroundColor: Colors.black38,
                  onPressed: () {
                    Routemaster.of(context).pop();
                  })
            ]);
  }

  void updateWeather() async {
    _weather.value = await weatherService.getWeather();
  }
}
