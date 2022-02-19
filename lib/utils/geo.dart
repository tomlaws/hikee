import 'dart:math' show sin, cos, sqrt, asin, pi;
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get_utils/src/extensions/double_extensions.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:hikee/models/region.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:tuple/tuple.dart';

class GeoUtils {
  static String encodePath(List<LatLng> points) {
    return encodePolyline(points.map((e) => [e.latitude, e.longitude]).toList(),
        accuracyExponent: 5);
  }

  static List<LatLng> decodePath(String encoded) {
    var result = decodePolyline(encoded, accuracyExponent: 5);
    return result.map((e) => LatLng(e[0].toDouble(), e[1].toDouble())).toList();
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
    return dist.toPrecision(2);
  }

  static LatLngBounds getPathBounds(List<LatLng> path) {
    return LatLngBounds.fromPoints(path);
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

  static bool isCloseToPoint(LatLng location, LatLng point) {
    return calculateDistance(location, point) <= 0.10; // smaller than 100meters
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
    return double.parse(getPathLength(path: walked).toStringAsFixed(2));
  }

  static String formatDistance(double km) {
    if (km < 0) {
      return (km * 1000).toStringAsFixed(0) + 'm';
    }
    return km.toStringAsFixed(2) + 'km';
  }

  static Region? determineRegion(List<LatLng> path) {
    var min = double.infinity;
    var allRegions = Region.allRegions();
    Region? result;
    allRegions.forEach((region) {
      var td = 0.0;
      path.forEach((location) {
        td += calculateDistance(location, region.center!);
      });
      var averageDist = td / path.length;
      if (averageDist < min) {
        min = averageDist;
        result = region;
      }
    });
    return result;
  }

  static var epsg2326Def =
      '+proj=tmerc +lat_0=22.31213333333334 +lon_0=114.1785555555556 +k=1 +x_0=836694.05 +y_0=819069.8 +ellps=intl +towgs84=-162.619,-276.959,-161.764,0.067753,-2.24365,-1.15883,-1.09425 +units=m +no_defs';
  static Tuple2 convertToEPSG2326(LatLng src) {
    var pointSrc = proj4.Point(x: src.longitude, y: src.latitude);
    var projDst = proj4.Projection.get('EPSG:2326') ??
        proj4.Projection.add('EPSG:2326', epsg2326Def);
    var projSrc = proj4.Projection.get('EPSG:4326')!;
    var pointForward = projSrc.transform(projDst, pointSrc).toArray();
    return Tuple2(pointForward[0], pointForward[1]);
  }

  static LatLng convertFromEPSG2326(Tuple2 src) {
    var pointSrc = proj4.Point(x: src.item1, y: src.item2);
    var projSrc = proj4.Projection.get('EPSG:2326') ??
        proj4.Projection.add('EPSG:2326', epsg2326Def);
    var projDst = proj4.Projection.get('EPSG:4326')!;
    var pointForward = projSrc.transform(projDst, pointSrc).toArray();
    return LatLng(pointForward[1], pointForward[0]);
  }
}
