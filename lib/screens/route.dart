import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/route_info.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/map_marker.dart';
import 'package:provider/provider.dart';

class RouteScreen extends StatefulWidget {
  final int id;
  const RouteScreen({Key? key, required this.id}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HikingRoute route = HikingRouteData.retrieve()
        .firstWhere((element) => element.id == widget.id);

    var points = GeoUtils.decodePath(route.path);

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              backgroundColor: Colors.white,
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Image.network(
                    route.image,
                    fit: BoxFit.cover,
                  ))
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              route.name_en,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Container(
                              height: 4,
                            ),
                            Text(
                              route.district_en,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFFAAAAAA)),
                            ),
                          ],
                        ),
                      ),
                      Button(
                        onPressed: () {
                          Provider.of<ActiveHikingRoute>(context, listen: false)
                              .selectRoute(route);
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                        child: Text('SELECT'),
                      )
                    ],
                  ),
                  Container(
                    height: 12,
                  ),
                  Divider(),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor)),
                          Container(
                            height: 12,
                          ),
                          Text(
                            route.description_en,
                            style: TextStyle(height: 1.6),
                          ),
                        ],
                      )),
                  Divider(),
                  Container(
                    height: 16,
                  ),
                  RouteInfo(
                    route: route,
                    showRouteName: false,
                  ),
                  Container(
                    height: 16,
                  ),
                  Container(
                    height: 240,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: points[(points.length / 5 * 2).floor()],
                        zoom: 13,
                      ),
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        new Factory<OneSequenceGestureRecognizer>(
                          () => new EagerGestureRecognizer(),
                        ),
                      ].toSet(),
                      zoomControlsEnabled: true,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      tiltGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      polylines: [
                        Polyline(
                          polylineId: PolylineId('polyLine1'),
                          color: Colors.amber.shade400,
                          zIndex: 2,
                          width: 4,
                          jointType: JointType.round,
                          startCap: Cap.roundCap,
                          endCap: Cap.roundCap,
                          points: points,
                        ),
                        Polyline(
                          polylineId: PolylineId('polyLine2'),
                          color: Colors.white,
                          width: 6,
                          jointType: JointType.round,
                          startCap: Cap.roundCap,
                          endCap: Cap.roundCap,
                          zIndex: 1,
                          points: points,
                        ),
                      ].toSet(),
                      markers: [
                        Marker(
                          markerId: MarkerId('marker-start'),
                          zIndex: 1,
                          icon: MapMarker().start,
                          position: points.first,
                        ),
                        Marker(
                          markerId: MarkerId('marker-end'),
                          zIndex: 1,
                          icon: MapMarker().end,
                          position: points.last,
                        )
                      ].toSet(),
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(
                            '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');

                        controller.moveCamera(CameraUpdate.newLatLngBounds(
                            GeoUtils.getPathBounds(points), 40));
                      },
                    ),
                  )
                ]),
              ),
            )
          ],
        ));
  }
}
