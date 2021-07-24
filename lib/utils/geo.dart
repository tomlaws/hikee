import 'dart:math' show sin, cos, sqrt, asin, pi;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoUtils {
  static List<LatLng> decodePath(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(encoded);
    return result.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  static double calculateDistance(LatLng location1, LatLng location2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((location2.latitude - location1.latitude) * p) / 2 +
        c(location1.latitude * p) *
            c(location2.latitude * p) *
            (1 - c((location2.longitude - location1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  static double getPathLength({String? encodedPath, List<LatLng>? path}) {
    List<LatLng> points = [];
    if (path != null)
      points = path;
    else if (encodedPath != null) points = decodePath(encodedPath);
    double dist = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      dist += calculateDistance(points[i], points[i + 1]);
    }
    return dist;
  }

  static LatLngBounds getPathBounds(List<LatLng> path) {
    double minLat = path.first.latitude;
    double minLng = path.first.longitude;
    double maxLat = path.first.latitude;
    double maxLng = path.first.longitude;
    for (int i = 1; i < path.length; i++) {
      if (path[i].latitude < minLat) minLat = path[i].latitude;
      if (path[i].longitude < minLng) minLng = path[i].longitude;
      if (path[i].latitude > maxLat) maxLat = path[i].latitude;
      if (path[i].longitude > maxLng) maxLng = path[i].longitude;
    }
    return LatLngBounds(
        northeast: LatLng(maxLat, maxLng), southwest: LatLng(minLat, minLng));
  }

  static double minDistanceToPath(LatLng location, List<LatLng> path) {
    double min = double.infinity;
    path.forEach((p) {
      var dist = calculateDistance(p, location);
      if (dist < min) {
        min = dist;
      }
    });
    return min;
  }

  static bool isFarWayFromPath(LatLng location, List<LatLng> path) {
    return minDistanceToPath(location, path) > 0.5; // greater than 500meters
  }

  static bool isFarWayFromPoint(LatLng location, LatLng point) {
    return calculateDistance(location, point) > 0.15; // greater than 150meters
  }

  static List<LatLng> truncatePathByLocation(
      List<LatLng> path, LatLng location) {
    double dist = double.infinity;
    int index = 0;
    for (int i = 0; i < path.length; i++) {
      double d = calculateDistance(path[i], location);
      if (d < dist) {
        dist = d;
        index = i;
      }
    }
    return path.take(index + 1).toList();
  }

  static double getWalkedLength(LatLng myLocation, List<LatLng> path) {
    var walked = truncatePathByLocation(path, myLocation);
    return double.parse(getPathLength(path: walked).toStringAsFixed(3));
  }

  static String formatDistance(double km) {
    if (km < 0) {
      return (km * 1000).toStringAsFixed(0) + ' m';
    }
    return km.toStringAsFixed(2) + ' km';
  }

}
