import 'dart:io';
import 'dart:math' show sin, cos, sqrt, asin, atan2, pi, pow;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:hikees/models/hk_datum.dart';
import 'package:hikees/models/region.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:tuple/tuple.dart';
import 'package:hikees/models/georaster.dart';
import 'package:dart_jts/dart_jts.dart';

class GeoUtils {
  static String encodePath(List<LatLng> points) {
    return encodePolyline(points.map((e) => [e.latitude, e.longitude]).toList(),
        accuracyExponent: 5);
  }

  static List<LatLng> decodePath(String encoded) {
    var result = decodePolyline(encoded, accuracyExponent: 5);
    return result.map((e) => LatLng(e[0].toDouble(), e[1].toDouble())).toList();
  }

  // in km
  // static double calculateDistance(LatLng location1, LatLng location2) {
  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 -
  //       c((location2.latitude - location1.latitude) * p) / 2 +
  //       c(location1.latitude * p) *
  //           c(location2.latitude * p) *
  //           (1 - c((location2.longitude - location1.longitude) * p)) /
  //           2;
  //   return 12742 * asin(sqrt(a));
  // }

  static int calculateDistance(LatLng location1, LatLng location2) {
    var R = 6378137; // Earth’s mean radius in meter
    var dLat = (location2.latitude - location1.latitude) * pi / 180;
    var dLong = (location2.longitude - location1.longitude) * pi / 180;
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(location1.latitudeInRad) *
            cos(location2.latitudeInRad) *
            sin(dLong / 2) *
            sin(dLong / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c;
    return d.round();
  }

  static int getPathLength({String? encodedPath, List<LatLng>? path}) {
    List<LatLng> points = [];
    if (path != null)
      points = path;
    else if (encodedPath != null) points = decodePath(encodedPath);
    int dist = 0;
    for (int i = 0; i < points.length - 1; i++) {
      dist += calculateDistance(points[i], points[i + 1]);
    }
    return dist;
  }

  static LatLngBounds getPathBounds(List<LatLng> path) {
    return LatLngBounds.fromPoints(path);
  }

  static int minDistanceToPath(LatLng location, List<LatLng> path) {
    int min = 9999;
    path.forEach((p) {
      var dist = calculateDistance(p, location);
      if (dist < min) {
        min = dist;
      }
    });
    return min;
  }

  static bool isFarWayFromPath(LatLng location, List<LatLng> path) {
    return minDistanceToPath(location, path) > 500; // greater than 500meters
  }

  static bool isCloseToPoint(LatLng location, LatLng point) {
    return calculateDistance(location, point) <= 100; // smaller than 100meters
  }

  static String formatMetres(int m) {
    if (m / 1000 > 0) {
      return (m / 1000).toStringAsFixed(2) + 'km';
    }
    return m.toString() + 'm';
  }

  static String formatKm(double km) {
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

  static GeoRaster? _cache;
  static Future<void> _ensureRasterLoaded() async {
    if (_cache == null) {
      ByteData data = await DefaultAssetBundle.of(Get.context!)
          .load('assets/data/hong_kong_terrain.tif');
      GeoRaster image = GeoRaster(data.buffer.asUint8List());
      image.read();
      _cache = image;
    }
  }

  /// Get the height at a specific location
  /// Return the height in metres above the Hong Kong Principal Datum
  static int _getHeight(GeoRaster geoRaster, LatLng pt) {
    Coordinate c = Coordinate.empty2D();
    var res = GeoUtils.convertToEPSG2326(pt);
    geoRaster.geoInfo?.worldToPixel(Coordinate(res.item1, res.item2), c);
    int dp = geoRaster.getInt(c.x.toInt(), c.y.toInt());
    return dp;
  }

  static Future<List<HKDatum>> getHKDPs(List<LatLng> path) async {
    await _ensureRasterLoaded();
    List<HKDatum> result = path.map((pt) {
      int dp = _getHeight(_cache!, pt);
      return HKDatum(dp, pt);
    }).toList();
    return result;
  }

  /// Calculate the length in metres and the duration in minutes (using Naismith's rule) for the trail.
  /// Reference: https://medium.com/amoutdoors/applying-naismiths-rule-to-your-land-navigation-c50b649b2c70
  static Future<Tuple2<int, int>> calculateLengthAndDuration(
      List<LatLng> path) async {
    await _ensureRasterLoaded();
    if (path.length == 0) return Tuple2(0, 0);

    double length = 0.0; // track's length in metres
    double mFlat = 0.0;
    int ascent = 0;
    var prevPt = path.elementAt(0);
    for (int i = 1; i < path.length; ++i) {
      var pt = path.elementAt(i);

      // Calculate distance on earth surface
      var flatDist = calculateDistance(pt, prevPt);
      if (flatDist > 10) {
        // Ensure a point for every 10m
        pt = offsetCoordinate(prevPt, 10, bearing(prevPt, pt));
        flatDist = 10;
        i -= 1;
      }
      mFlat += flatDist;

      // Calculate ascent
      int diff = _getHeight(_cache!, pt) - _getHeight(_cache!, prevPt);
      if (diff > 0) {
        // is ascent
        ascent += diff;
      }

      // Increment to track's length
      //length += sqrt(pow(flatDist, 2) + pow(diff, 2));
      length += flatDist;

      prevPt = pt;
    }
    // 1 hour for every 5 km forward plus 1 hour for every 600 m of ascent
    var duration = (60 * (mFlat / 1000 / 5) + 60 * (ascent / 600)).round();
    var lengthRounded = length.round();
    return Tuple2(lengthRounded, duration);
  }

  /// Find bearing from point A to point B
  /// Reference: https://stackoverflow.com/questions/8123049/calculate-bearing-between-two-locations-lat-long
  static double bearing(LatLng from, LatLng to) {
    double lat1 = from.latitudeInRad;
    double lng1 = from.longitudeInRad;
    double lat2 = to.latitudeInRad;
    double lng2 = to.longitudeInRad;
    double dLon = (lng2 - lng1);
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    return atan2(y, x);
  }

  /// Offset coordinate by distance and bearing
  /// Reference: https://stackoverflow.com/questions/2839533/adding-distance-to-a-gps-coordinate
  static LatLng offsetCoordinate(
      LatLng location, int distanceInMetres, double bearingInRadian) {
    double rad = bearingInRadian;
    double lat1 = location.latitudeInRad;
    double lng1 = location.longitudeInRad;
    double lat = asin(sin(lat1) * cos(distanceInMetres / 6378137) +
        cos(lat1) * sin(distanceInMetres / 6378137) * cos(rad));
    double lng = lng1 +
        atan2(sin(rad) * sin(distanceInMetres / 6378137) * cos(lat1),
            cos(distanceInMetres / 6378137) - sin(lat1) * sin(lat));
    return LatLng(lat * 180 / pi, lng * 180 / pi); // to degrees
  }
}
