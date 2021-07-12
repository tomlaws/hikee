import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/route.dart';
import 'package:provider/provider.dart';

class RouteScreen extends StatefulWidget {
  final int id;
  const RouteScreen({Key? key, required this.id}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  @override
  Widget build(BuildContext context) {
    HikingRoute route = HikingRouteData.retrieve()
        .firstWhere((element) => element.id == widget.id);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              route.name_en,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              route.district_en,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFFBBBBBB)),
                            ),
                          ],
                        ),
                      ),
                      Button(
                        onPressed: () {
                          Provider.of<ActiveHikingRoute>(context, listen: false)
                              .update(route);
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                        child: Text('GO NOW'),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      route.description_en,
                      style: TextStyle(),
                    ),
                  ),
                  Container(
                    height: 240,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: route
                            .polyline[(route.polyline.length / 5 * 2).floor()],
                        zoom: 13,
                      ),
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        new Factory<OneSequenceGestureRecognizer>(
                          () => new EagerGestureRecognizer(),
                        ),
                      ].toSet(),
                      zoomControlsEnabled: false,
                      //myLocationEnabled: true,
                      //myLocationButtonEnabled: false,
                      polylines: [
                        Polyline(
                          polylineId: PolylineId('polyLine'),
                          color: Colors.amber,
                          startCap: Cap.roundCap,
                          endCap: Cap.roundCap,
                          width: 5,
                          jointType: JointType.bevel,
                          points: route.polyline,
                        ),
                      ].toSet(),
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(
                            '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
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
