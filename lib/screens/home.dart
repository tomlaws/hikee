import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/models/active_route.dart';
import 'package:hikee/models/panel_position.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController _pc = PanelController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
            controller: _pc,
            parallaxEnabled: true,
            renderPanelSheet: false,
            maxHeight: MediaQuery.of(context).size.height,
            minHeight: _collapsedPanelHeight,
            color: Colors.transparent,
            onPanelSlide: (position) {
              Provider.of<PanelPosition>(context, listen: false)
                  .update(position);
            },
            panel: _panel(context),
            body: _body()));
  }

  Widget _panel(BuildContext context) {
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
            child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextInput(
                      hintText: 'Search...',
                    )
                  ],
                )),
          ),
        )
      ],
    ));
  }

  Widget _body() {
    return Container(
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(
          bottom: _collapsedPanelHeight -
              (_panelHeaderHeight / 2) -
              _mapBottomPadding),
      color: Color(0xFF5DB075),
      child: Consumer2<PanelPosition, ActiveRoute>(
          builder: (_, posProvider, activeRouteProvider, __) => Stack(
                children: [
                  if (activeRouteProvider.route != null)
                    Opacity(opacity: 1 - posProvider.position, child: _map()),
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
                              if (activeRouteProvider.route == null)
                                Expanded(
                                    child: Center(
                                  child: Button(
                                    invert: true,
                                    child: Text('Set Your Goal'),
                                    onPressed: () {
                                      Provider.of<ActiveRoute>(context,
                                              listen: false)
                                          .update(RouteData.retrieve()[0]);
                                    },
                                  ),
                                ))
                            ],
                          ))),
                  if (activeRouteProvider.route != null)
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
                                      Provider.of<ActiveRoute>(context,
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
    return GestureDetector(
      onPanUpdate: (d) {
        if (d.delta.dy < 0 && _pc.isPanelClosed) _pc.open();
        if (d.delta.dy > 0 && _pc.isPanelOpen) _pc.close();
      },
      child: Container(
        color: Color(0xFF5DB075),
      ),
    );
  }

  Widget _map() {
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
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(
                '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
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
                          zoom: 18),
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
          zoom: 17.0,
        ),
      ));
    } catch (e) {
      print(e);
    }
  }
}
