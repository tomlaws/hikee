import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mountain_deco.dart';
import 'package:hikee/components/route_info.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/panel_position.dart';
import 'package:hikee/models/route.dart';
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
  BitmapDescriptor? _bdS, _bdE;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _selectPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _buildIcons();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _buildIcons() async {
    _bdS = await _getIcon('START');
    _bdE = await _getIcon('END');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    HikingRoute? route =
        Provider.of<ActiveHikingRoute>(context, listen: true).route;
    if (route != _activeRoute) {
      _activeRoute = route;
      if (_activeRoute != null) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          widget.switchToTab(0);
        });
        _pc.close();
        _lockPosition = false;
        _goToLocation(_activeRoute!.polyline[0].latitude,
            _activeRoute!.polyline[0].longitude);
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
                opacity: 1 - panelPosition.position,
                child: Container(
                  height: 60,
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
              height: kBottomNavigationBarHeight + 1,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: Theme.of(context).dividerColor))),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                        '3.2 km',
                        style: TextStyle(
                            fontSize: 28,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
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
                      Text('54m 3s',
                          style: TextStyle(
                              fontSize: 28,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _selectPageIndex = page;
                    });
                  },
                  children: [_routeInfo(), _routeInfo()],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _pageIndicators(2, _selectPageIndex),
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
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: activeHikingRouteProvider.route!.polyline[0],
            zoom: 14,
          ),
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
          markers: _bdS != null && _bdE != null
              ? Set.from([
                  Marker(
                      markerId: MarkerId('start'),
                      position: activeHikingRouteProvider.route!.polyline.first,
                      icon: _bdS!),
                  Marker(
                      markerId: MarkerId('end'),
                      position: activeHikingRouteProvider.route!.polyline.last,
                      icon: _bdE!)
                ])
              : Set.from([]),
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

  Future<BitmapDescriptor> _getIcon(String text) async {
    final int width = 80;
    final int height = 80;
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(fontSize: 25.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
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
      child: RouteInfo(
        route: _activeRoute!,
      ),
    );
  }
}
