import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mountain_deco.dart';
import 'package:hikee/components/route_elevation.dart';
import 'package:hikee/components/route_info.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/hiking_stat.dart';
import 'package:hikee/models/panel_position.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/map_marker.dart';
import 'package:hikee/utils/time.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  final Function switchToTab;
  const HomeScreen({Key? key, required this.switchToTab}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController _pc = PanelController();
  final double _collapsedPanelHeight = kBottomNavigationBarHeight;
  final double _panelHeaderHeight = 60;
  Completer<GoogleMapController> _mapController = Completer();
  Location _location = Location();
  bool _lockPosition = true;
  HikingRoute? _activeRoute;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _selectPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HikingRoute? route =
        Provider.of<ActiveHikingRoute>(context, listen: true).route;
    if (route != _activeRoute) {
      _activeRoute = route;
      _pc.close();
      if (_activeRoute != null) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          widget.switchToTab(0);
          Future.delayed(const Duration(milliseconds: 10), () {
            _focusActiveRoute();
          });
        });
        _lockPosition = false;
      }
    }
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(children: [
        Container(
          child: SlidingUpPanel(
              controller: _pc,
              parallaxEnabled: true,
              renderPanelSheet: false,
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              maxHeight: 296,
              minHeight: _collapsedPanelHeight + mediaQueryData.padding.top,
              color: Colors.transparent,
              onPanelSlide: (position) {
                Provider.of<PanelPosition>(context, listen: false)
                    .update(position);
              },
              panel: _panel(),
              body: _body()),
        ),
        Consumer<PanelPosition>(
          builder: (_, panelPosition, __) => Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: (1 - panelPosition.position).clamp(0, 0.75),
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
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26), topRight: Radius.circular(26)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              GeoUtils.formatDistance(
                                  hikingStat.walkedDistance),
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            )
                          ],
                        ),
                        StreamBuilder<int>(
                            stream: hikingStat.clockStream,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.data == null) {
                                return Container();
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LineAwesomeIcons.stopwatch,
                                    size: 30,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Container(width: 4),
                                  Text(
                                    TimeUtils.formatSeconds(snapshot.data ?? 0),
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                ],
                              );
                            })
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _pageIndicators(2, _selectPageIndex),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _selectPageIndex = page;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _routeInfo(),
                  ),
                  RouteElevation(
                    encodedPath: _activeRoute!.path,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(bottom: _collapsedPanelHeight),
      color: Color(0xFF5DB075),
      child: Consumer2<PanelPosition, ActiveHikingRoute>(
          builder: (_, posProvider, activeHikingRouteProvider, __) => Stack(
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
                      child: Opacity(
                          opacity: 1 - posProvider.position,
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
                                          child: Text(
                                            'Good Morning',
                                            style: TextStyle(fontSize: 32),
                                          ),
                                        ),
                                        Button(
                                          icon: Icon(LineAwesomeIcons.bars,
                                              color: Colors.white, size: 32),
                                          backgroundColor: Colors.transparent,
                                          onPressed: () {},
                                        )
                                      ],
                                    )
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
                                      widget.switchToTab(1);
                                    },
                                  ),
                                ))
                            ],
                          ))),
                  if (activeHikingRouteProvider.route != null)
                    Positioned(
                        bottom: _collapsedPanelHeight,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [],
                              ),
                              Column(
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
                        )),
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
          padding: EdgeInsets.only(bottom: _collapsedPanelHeight),
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
              zIndex: 2,
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
              zIndex: 1,
              points: activeHikingRouteProvider.decodedPath!,
            ),
          ].toSet(),
          markers: [
            Marker(
                markerId: MarkerId(
                    'start' + activeHikingRouteProvider.route!.id.toString()),
                position: activeHikingRouteProvider.decodedPath!.first,
                icon: !activeHikingRouteProvider.isStarted
                    ? MapMarker().red
                    : MapMarker().grey,
                anchor: Offset(0.5, 0.5),
                zIndex: 99),
            Marker(
                markerId: MarkerId(
                    'end' + activeHikingRouteProvider.route!.id.toString()),
                position: activeHikingRouteProvider.decodedPath!.last,
                icon: MapMarker().blue,
                anchor: Offset(0.5, 0.5),
                zIndex: 99)
          ].toSet(),
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(
                '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
            _mapController = Completer<GoogleMapController>();
            _mapController.complete(controller);
            _location.onLocationChanged.listen((l) {
              if (_lockPosition) {
                try {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(
                              l.latitude as double, l.longitude as double),
                          zoom: 14),
                    ),
                  );
                } catch (e) {}
              }
            });
          },
        ));
  }

  Future<void> _goToCurrentLocation() async {
    try {
      Location _location = new Location();
      LocationData location;
      _lockPosition = true;
      location = await _location.getLocation();
      await _goToLocation(
          location.latitude as double, location.longitude as double);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _goToLocation(double latitude, double longitude) async {
    try {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(latitude, longitude),
          zoom: 14.0,
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
    //print('focus');
    final GoogleMapController controller = await _mapController.future;
    controller.moveCamera(
        CameraUpdate.newLatLngBounds(GeoUtils.getPathBounds(decodedPath), 20));
  }

  List<Widget> _pageIndicators(int total, int selectedindex) {
    List<Widget> list = [];
    for (int i = 0; i < total; i++) {
      bool isActive = i == selectedindex;
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
          hideDistrict: true,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Consumer2<ActiveHikingRoute, HikingStat>(
              builder: (_, activeHikingRoute, hikingStat, ___) {
            if (activeHikingRoute.isStarted)
              return Button(
                  child: Text('QUIT'),
                  onPressed: () {
                    activeHikingRoute.quitRoute();
                  });
            else {
              bool closeEnough = !hikingStat.isFarAwayFromStart;
              return Button(
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
                  });
            }
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
