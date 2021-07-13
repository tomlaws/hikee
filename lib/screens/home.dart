import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mountain_deco.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/panel_position.dart';
import 'package:hikee/models/route.dart';
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
  final double _collapsedPanelHeight = 96;
  final double _panelHeaderHeight = 60;
  double _mapBottomPadding = 80;
  Completer<GoogleMapController> _mapController = Completer();
  Location _location = Location();
  bool _lockPosition = true;
  bool _pinned = false;
  HikingRoute? _activeRoute;
  BitmapDescriptor? _bdS, _bdE;

  @override
  void initState() {
    super.initState();
    _buildIcons();
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
    return Scaffold(
        body: SlidingUpPanel(
            controller: _pc,
            parallaxEnabled: true,
            renderPanelSheet: false,
            maxHeight: _activeRoute != null ? 296 : 0,
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
            panel: _panel(),
            body: _body()));
  }

  Widget _panel() {
    return SafeArea(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26), topRight: Radius.circular(26)),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Icon(
                    LineAwesomeIcons.walking,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(width: 4),
                  Text(
                    '3.2',
                    style: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  Container(width: 4),
                  Text(
                    'km',
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          child: Container(
            width: 36,
            height: 6,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.1),
                borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ],
    ));
  }

  Widget _body() {
    return Container(
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(bottom: max(0, _collapsedPanelHeight + 12)),
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

  Widget _map(ActiveHikingRoute activeHikingRouteProvider) {
    return Listener(
        onPointerDown: (e) {
          _lockPosition = false;
        },
        child: GoogleMap(
          padding: EdgeInsets.only(bottom: _mapBottomPadding),
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
}
