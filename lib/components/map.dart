import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/map_marker.dart';

class HikeeMap extends StatelessWidget {
  const HikeeMap({Key? key, required this.target, this.path}) : super(key: key);
  final LatLng target;
  final List<LatLng>? path;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: target,
        zoom: 14,
      ),
      // gestureRecognizers:
      //     <Factory<OneSequenceGestureRecognizer>>[
      //   new Factory<OneSequenceGestureRecognizer>(
      //     () => new EagerGestureRecognizer(),
      //   ),
      // ].toSet(),
      zoomControlsEnabled: true,
      compassEnabled: false,
      mapToolbarEnabled: false,
      tiltGesturesEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      polylines: path != null
          ? [
              Polyline(
                polylineId: PolylineId('polyLine1'),
                color: Colors.amber.shade400,
                zIndex: 2,
                width: 4,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                points: path!,
              ),
              Polyline(
                polylineId: PolylineId('polyLine2'),
                color: Colors.white,
                width: 6,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                zIndex: 1,
                points: path!,
              ),
            ].toSet()
          : const <Polyline>{},
      markers: path != null
          ? [
              Marker(
                markerId: MarkerId('marker-start'),
                zIndex: 2,
                icon: MapMarker().start,
                position: path!.first,
              ),
              Marker(
                markerId: MarkerId('marker-end'),
                zIndex: 1,
                icon: MapMarker().end,
                position: path!.last,
              )
            ].toSet()
          : const <Marker>{},
      onMapCreated: (GoogleMapController mapController) {
        mapController.setMapStyle(
            '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');
        if (path != null) {
          mapController.moveCamera(
              CameraUpdate.newLatLngBounds(GeoUtils.getPathBounds(path!), 40));
        }
      },
    );
  }
}
