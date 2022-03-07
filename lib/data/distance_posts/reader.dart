import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikees/models/distance_post.dart';
import 'package:hikees/utils/geo.dart';

class DistancePostsReader {
  static var d = FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);
  static Future<DistancePost?> findClosestDistancePost(LatLng location) async {
    final data =
        await rootBundle.loadString("assets/data/AFCD_Distance_Post.csv");
    List<List<dynamic>> rows =
        CsvToListConverter(csvSettingsDetector: d).convert(data);
    if (rows.length < 2) {
      return null;
    }
    // remove first row
    rows.removeAt(0);
    double minDist = double.infinity;
    DistancePost? post;
    for (var row in rows) {
      var latlng = LatLng(row[3], row[4]);
      var dist = GeoUtils.calculateDistance(latlng, location);
      if (dist < minDist) {
        minDist = dist;
        post = DistancePost(
            no: row[0],
            location: latlng,
            trail_name_en: row[1],
            trail_name_zh: row[2]);
      }
    }
    return post;
  }
}
