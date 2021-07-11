import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/mountain_deco.dart';
import 'package:hikee/components/sliding_up_panel.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/panel_position.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/screens/route.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController _pc = PanelController();
  ScrollController _sc = ScrollController();
  final double _collapsedPanelHeight = 180;
  final double _panelHeaderHeight = 60;
  double _mapBottomPadding = 18;
  Completer<GoogleMapController> _mapController = Completer();
  Location _location = Location();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.352036, 114.1373281),
    zoom: 11.55,
  );
  bool _lockPosition = true;
  bool _pinned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
            controller: _pc,
            parallaxEnabled: true,
            renderPanelSheet: false,
            maxHeight:
                MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
            minHeight: _collapsedPanelHeight,
            color: Colors.transparent,
            onPanelSlide: (position) {
              setState(() {
                _pinned = true;
              });
              Provider.of<PanelPosition>(context, listen: false)
                  .update(position);
            },
            onPanelOpened: () {
              setState(() {
                _pinned = false;
              });
            },
            onPanelClosed: () {
              setState(() {
                _pinned = false;
              });
            },
            panelBuilder: (ScrollController sc) {
              _sc = sc;
              return _panel(context, sc);
            },
            body: _body()));
  }

  Widget _panel(BuildContext context, ScrollController sc) {
    return SafeArea(
        child: Column(
      children: [
        Consumer<PanelPosition>(
            builder: (_, pos, __) => IgnorePointer(
                ignoring: pos.position == 0,
                child: Container(
                  height: _panelHeaderHeight,
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Opacity(
                      opacity: pos.position,
                      child: Text(
                        'Discover',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      )),
                ))),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26), topRight: Radius.circular(26)),
            ),
            clipBehavior: Clip.hardEdge,
            child: CustomScrollView(
              controller: sc,
              slivers: [
                SliverAppBar(
                  shadowColor: Colors.transparent,
                  expandedHeight: 116,
                  backgroundColor: Colors.white,
                  floating: true,
                  snap: true,
                  pinned: _pinned,
                  toolbarHeight: 116,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextInput(
                          hintText: 'Search...',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 32,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Button(
                                onPressed: () {},
                                child: Text('test'),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: HikingRouteTile(
                          route: HikingRouteData.retrieve()[0],
                          onTap: () {
                            // _setRoute(HikingRouteData.retrieve()[0]);
                            // _pc.close();
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => RouteScreen(id: 1)));
                          }),
                    ),
                    // Builds 1000 ListTiles
                    childCount: 1000,
                  ),
                )
                //   itemCount: 4,
                //   padding: EdgeInsets.only(left: 16, right: 16, top: 116),
                //   controller: sc,
                //   itemBuilder: (_, __) => HikingRouteTile(
                //       route: HikingRouteData.retrieve()[0],
                //       onTap: () {
                //         _setRoute(HikingRouteData.retrieve()[0]);
                //         _pc.close();
                //       }),
                //   separatorBuilder: (BuildContext context, int index) {
                //     return SizedBox(
                //       height: 10,
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget _body() {
    return Container(
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(
          bottom: max(
              0,
              _collapsedPanelHeight -
                  (_panelHeaderHeight / 2) -
                  _mapBottomPadding)),
      color: Color(0xFF5DB075),
      child: Consumer2<PanelPosition, ActiveHikingRoute>(
          builder: (_, posProvider, activeHikingRouteProvider, __) => Stack(
                children: [
                  if (activeHikingRouteProvider.route != null)
                    Opacity(
                        opacity: 1 - posProvider.position,
                        child: _map(activeHikingRouteProvider))
                  else
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: 1 - posProvider.position,
                        child: ClipPath(
                          clipper: MountainDeco(),
                          child: Container(
                            color: Colors.black.withOpacity(.05),
                            width: 300,
                            height: 300,
                          ),
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
                                              horizontal: 18, vertical: 12),
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
                                    child: Text('Set Your Goal'),
                                    onPressed: () {
                                      _pc.open();
                                    },
                                  ),
                                ))
                            ],
                          ))),
                  if (activeHikingRouteProvider.route != null)
                    Positioned(
                        bottom: _mapBottomPadding,
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
                                    onPressed: () {},
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
                                  Container(
                                    height: 8,
                                  ),
                                  Button(
                                    icon: Icon(
                                      LineAwesomeIcons.alternate_undo,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    invert: true,
                                    onPressed: () {
                                      Provider.of<ActiveHikingRoute>(context,
                                              listen: false)
                                          .update(null);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))
                ],
              )),
    );
  }

  // void _adjustPanelPosition(DragUpdateDetails dets) {
  //   double dy = dets.delta.dy;
  //   double newPos = _pc.panelPosition -
  //       dy /
  //           ((MediaQuery.of(context).size.height - kBottomNavigationBarHeight) -
  //               _collapsedPanelHeight);
  //   _pc.panelPosition = newPos.clamp(0, 1);
  // }

  Widget _map(ActiveHikingRoute activeHikingRouteProvider) {
    return Listener(
        onPointerDown: (e) {
          _lockPosition = false;
        },
        child: GoogleMap(
          padding: EdgeInsets.only(bottom: _mapBottomPadding),
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          polylines: [
            Polyline(
              polylineId: PolylineId('polyLine'),
              color: Colors.amber,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              width: 5,
              jointType: JointType.bevel,
              points: activeHikingRouteProvider.route!.polyline,
            ),
          ].toSet(),
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(
                '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
            _mapController = Completer<GoogleMapController>();
            _mapController.complete(controller);
            setState(() {
              _mapBottomPadding = 18;
            });
            _location.onLocationChanged.listen((l) {
              if (_lockPosition) {
                try {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(
                              l.latitude as double, l.longitude as double),
                          zoom: 16),
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
      final GoogleMapController controller = await _mapController.future;

      Location _location = new Location();
      LocationData location;
      _lockPosition = true;
      location = await _location.getLocation();
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target:
              LatLng(location.latitude as double, location.longitude as double),
          zoom: 16.0,
        ),
      ));
    } catch (e) {
      print(e);
    }
  }

  void _setRoute(HikingRoute route) {
    _lockPosition = true;
    Provider.of<ActiveHikingRoute>(context, listen: false).update(route);
  }
}
