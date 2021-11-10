import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/pages/trails/create/create_trail_controller.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/map_marker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CreateTrailPage extends GetView<CreateTrailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(title: Text("Create Trail"), actions: [
          Obx(() => controller.prevCoordinates.length == 0
              ? SizedBox()
              : Button(
                  secondary: true,
                  backgroundColor: Colors.transparent,
                  icon: Icon(Icons.undo_rounded),
                  onPressed: () {
                    controller.undo();
                  }))
        ]),
        body: Obx(() {
          switch (controller.step.value) {
            case 0:
              return _step0();
            case 1:
              return _step1();
            default:
              return _step0();
          }
        }));
  }

  Widget _step1() {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 240,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(24)),
                child: GoogleMap(
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  padding:
                      EdgeInsets.only(bottom: kBottomNavigationBarHeight + 16),
                  markers: [
                    Marker(
                      markerId: MarkerId('marker-start'),
                      zIndex: 2,
                      icon: MapMarker().start,
                      position: controller.coordinates.first,
                    ),
                    Marker(
                      markerId: MarkerId('marker-end'),
                      zIndex: 1,
                      icon: MapMarker().end,
                      position: controller.coordinates.last,
                    ),
                  ].toSet(),
                  polylines: [
                    Polyline(
                      polylineId: PolylineId('polyline1'),
                      color: Color(0xFFfcce39),
                      zIndex: 1,
                      width: 8,
                      jointType: JointType.round,
                      startCap: Cap.roundCap,
                      endCap: Cap.roundCap,
                      points: controller.coordinates,
                    ),
                    Polyline(
                      polylineId: PolylineId('polyline2'),
                      color: Colors.white,
                      width: 10,
                      jointType: JointType.round,
                      startCap: Cap.roundCap,
                      endCap: Cap.roundCap,
                      zIndex: 0,
                      points: controller.coordinates,
                    ),
                  ].toSet(),
                  initialCameraPosition: CameraPosition(
                    target: controller.coordinates.first,
                    zoom: 11,
                  ),
                  onMapCreated: (GoogleMapController mapController) async {
                    await mapController.setMapStyle(
                        '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      mapController.moveCamera(CameraUpdate.newLatLngBounds(
                          GeoUtils.getPathBounds(controller.coordinates), 40));
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Trail name',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextInput(
                  hintText: "Trail name",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Difficulty',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RatingBar.builder(
                  glow: false,
                  initialRating: 0,
                  itemSize: 20,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: EdgeInsets.only(right: 8.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Description',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 160,
                  child: TextInput(
                    expand: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    hintText: "Description",
                  ),
                ),
              ),
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                blurRadius: 16,
                spreadRadius: -8,
                color: Colors.black.withOpacity(.09),
                offset: Offset(0, -6))
          ]),
          child: Row(
            children: [
              Button(
                secondary: true,
                onPressed: () {
                  controller.step.value = 0;
                },
                icon: Icon(Icons.chevron_left, color: Colors.white),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Button(
                  onPressed: () {},
                  child: Text('Publish'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _step0() {
    return Obx(() {
      var coordinates = controller.coordinates;
      print(coordinates.length); // keep this line to avoid error from GetX
      return Stack(children: [
        Positioned.fill(
          child: GoogleMap(
            compassEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            tiltGesturesEnabled: false,
            padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 16),
            markers: coordinates
                .asMap()
                .entries
                .map(
                  (entry) => Marker(
                      draggable: true,
                      markerId: MarkerId('marker-${entry.key}'),
                      zIndex: 2,
                      position: entry.value,
                      onTap: () {
                        controller.remove(entry.key);
                      },
                      onDragEnd: ((newPosition) {
                        controller.updateMarkerPosition(entry.key, newPosition);
                      })),
                )
                .toSet(),
            polylines: [
              Polyline(
                polylineId: PolylineId('polyline1'),
                color: Color(0xFFfcce39),
                zIndex: 1,
                width: 8,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                points: coordinates,
              ),
              Polyline(
                polylineId: PolylineId('polyline2'),
                color: Colors.white,
                width: 10,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                zIndex: 0,
                points: coordinates,
              ),
            ].toSet(),
            onTap: (LatLng latLng) {
              controller.addLocation(latLng);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(22.3579571, 114.1194196),
              zoom: 11,
            ),
            onMapCreated: (GoogleMapController mapController) async {
              await mapController.setMapStyle(
                  '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
            },
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: kBottomNavigationBarHeight + 16,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26)),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LineAwesomeIcons.walking,
                          size: 24,
                        ),
                        Container(width: 4),
                        Text(
                            "${GeoUtils.formatDistance(GeoUtils.getPathLength(path: controller.coordinates))}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Button(
                        child: Text(
                          'Next',
                        ),
                        disabled: controller.coordinates.length < 2,
                        onPressed: () {
                          if (controller.coordinates.length >= 2) {
                            controller.step.value = 1;
                          }
                        })
                  ],
                ),
              ),
            ))
      ]);
    });
  }
}
