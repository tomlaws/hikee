import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hikees/models/active_trail.dart';
import 'package:hikees/models/map_marker.dart';
import 'package:hikees/models/offline_record.dart';
import 'package:hikees/models/preferences.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/geo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as Path;

class OfflineProvider extends GetConnect {
  static const DEG_TO_RAD = pi / 180;
  final downloaded = 0.obs;
  Future<Database>? _mapTilesDb;
  MapProvider? _currentOfflineProvider;

  OfflineProvider();

  Future<Database> loadMapTilesDb(MapProvider mapProvider) async {
    if (_currentOfflineProvider == mapProvider) {
      return _mapTilesDb!;
    }
    var appDocDir = await getApplicationDocumentsDirectory();
    File f = File(appDocDir.path + '/${mapProvider.resIdentifier}.mbtiles');
    _mapTilesDb = openDatabase(f.path);
    _currentOfflineProvider = mapProvider;
    return await _mapTilesDb!;
  }

  Future<Database> loadTrailsDb() async {
    var databasesPath = await getDatabasesPath();
    String path = Path.join(databasesPath, 'offline_data.db');
    //File(path).deleteSync();
    Database db = await openDatabase(path,
        version: 1,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (newVersion > 0) {
            await db.execute(
                'CREATE TABLE saved_trails (id INTEGER PRIMARY KEY, trail TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
            await db.execute(
                'CREATE TABLE tiles (id INTEGER PRIMARY KEY, zoom_level INTEGER, tile_column INTEGER, tile_row INTEGER, tile_data BLOB, UNIQUE (zoom_level, tile_column, tile_row))');
            await db.execute(
                'CREATE TABLE saved_trail_tiles (id INTEGER PRIMARY KEY, trail_id REFERENCES saved_trails(id) ON DELETE CASCADE, tile_id REFERENCES tiles(id))');
            await db.execute(
                'CREATE TABLE saved_records (id INTEGER PRIMARY KEY, name TEXT, date INTEGER, time INTEGER, region_id INTEGER, user_path TEXT, original_path TEXT, reference_trail_id INTEGER, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
            await db.execute(
                'CREATE TABLE markers (id INTEGER PRIMARY KEY, record_id REFERENCES saved_records(id) ON DELETE CASCADE, latitude REAL NOT NULL, longitude REAL NOT NULL, color INTEGER, title TEXT NOT NULL, message TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
          }
        },
        onDowngrade: (db, oldVersion, newVersion) async {},
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
          //await db.execute(
          //    'CREATE TABLE IF NOT EXISTS saved_records (id INTEGER PRIMARY KEY, name TEXT, date INTEGER, time INTEGER, region_id INTEGER, user_path TEXT, reference_trail_id INTEGER, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
        });
    return db;
  }

  Future<void> downloadAndSave(
      LatLngBounds latLngBounds, Trail trail, MapProvider? mapProvider) async {
    var topLeft = latLngBounds.northWest;
    var bottomRight = latLngBounds.southEast;
    var zoomLevels = [11, 12, 13, 14, 15, 16, 17];
    double tileSize = 256.0;
    List<double> bc = [];
    List<double> cc = [];
    List<Tuple2<double, double>> zc = [];
    List<double> ac = [];
    double c = tileSize;
    double e = 0.0;
    for (int i = 0; i <= zoomLevels.last; i++) {
      e = c / 2;
      bc.add(c / 360.0);
      cc.add(c / (2 * pi));
      zc.add(Tuple2(e, e));
      ac.add(c);
      c *= 2;
    }
    List<Tuple3<int, int, int>> wtmsList = [];
    zoomLevels.forEach((z) {
      var px0 = _projectPixels(topLeft, z, zc, bc, cc);
      var px1 = _projectPixels(bottomRight, z, zc, bc, cc);
      var start = px0.item1 ~/ tileSize;
      var end = (px1.item1 / tileSize).ceil();
      for (int x = start; x < end; x++) {
        if (x < 0 || x >= pow(2, z)) continue;
        var start = px0.item2 ~/ tileSize;
        var end = (px1.item2 / tileSize).ceil();
        for (int y = start; y < end; y++) {
          if (y < 0 || y >= pow(2, z)) continue;
          // tms
          wtmsList.add(Tuple3(z, x, y));
        }
      }
    });
    String? templateUrl;
    switch (mapProvider) {
      case MapProvider.OpenStreetMap:
        templateUrl = "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png";
        break;
      case MapProvider.LandsDepartment:
        templateUrl =
            "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/basemap/WGS84/{z}/{x}/{y}.png";
        break;
      case null:
      case MapProvider.OpenStreetMapCyclOSM:
        templateUrl =
            "https://a.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png";
        break;
    }
    if (wtmsList.length == 0) return;
    downloaded.value = 0;
    CancelToken cancelToken = CancelToken();
    DialogUtils.showSimpleDialog(
        "downloading".tr,
        Obx(() => Column(children: [
              Text((((downloaded / wtmsList.length) * 100).toInt()).toString() +
                  "%"),
            ])),
        dismissText: "cancel".tr, onDismiss: () {
      cancelToken.cancel();
    });
    var dio = new Dio();
    List<int> _tileIds = [];
    final database = await loadTrailsDb();
    await database.transaction((txn) async {
      // Save tiles
      for (int i = 0; i < wtmsList.length; i++) {
        var wtms = wtmsList[i];
        var url = templateUrl!
            .replaceFirst('{z}', wtms.item1.toString())
            .replaceFirst('{x}', wtms.item2.toString())
            .replaceFirst('{y}', wtms.item3.toString());
        var response = await dio.request(url,
            cancelToken: cancelToken,
            options: Options(responseType: ResponseType.bytes));

        List<Map> res = await txn.query('tiles',
            where: 'zoom_level = ? AND tile_column = ? AND tile_row = ?',
            whereArgs: [wtms.item1, wtms.item2, wtms.item3]);

        if (res.length == 0) {
          final tileId = await txn.insert('tiles', {
            'zoom_level': wtms.item1,
            'tile_column': wtms.item2,
            'tile_row': wtms.item3,
            'tile_data': response.data
          });
          _tileIds.add(tileId);
        } else {
          final tileId = await txn.update('tiles', {'tile_data': response.data},
              where: 'id = ?', whereArgs: [res.first['id']]);
          _tileIds.add(tileId);
        }
        downloaded.value = i + 1;
      }

      // Delete trail & the relationships to avoid error
      await txn.delete('saved_trail_tiles',
          where: 'trail_id = ?', whereArgs: [trail.id]);
      await txn.delete('saved_trails', where: 'id = ?', whereArgs: [trail.id]);

      // Save trail
      int id = await txn
          .insert('saved_trails', {'id': trail.id, 'trail': jsonEncode(trail)});

      // Save relationships
      for (int i = 0; i < _tileIds.length; i++) {
        await txn.insert(
            'saved_trail_tiles', {'trail_id': id, 'tile_id': _tileIds[i]});
      }
    });
    if (!cancelToken.isCancelled) Get.back();
  }

  Future<List<Trail>> getTrails(int offset) async {
    final database = await loadTrailsDb();
    List<Map> records = await database.query('saved_trails',
        orderBy: 'created_at DESC', limit: 10, offset: offset);
    return records
        .map((e) => Trail.fromJson(jsonDecode(e['trail']))..offline = true)
        .toList();
  }

  Future<void> deleteTrail(int trailId) async {
    final database = await loadTrailsDb();
    await database
        .delete('saved_trails', where: 'id = ?', whereArgs: [trailId]);
  }

  Future<List<OfflineRecord>> getOfflineRecords(int offset) async {
    final database = await loadTrailsDb();
    List<Map> records = await database.query('saved_records',
        orderBy: 'created_at DESC', limit: 10, offset: offset);
    List<Map> markers =
        await database.query('markers', orderBy: 'created_at DESC');
    List<MapMarker> mapMarkers = markers
        .map((e) => MapMarker(
            locationInLatLng:
                LatLng(e['latitude'] as double, e['longitude'] as double),
            title: e['title'] as String,
            color: Color(e['color'] as int)))
        .toList();
    return records
        .map((e) => OfflineRecord(
            id: e['id'],
            date: DateTime.fromMillisecondsSinceEpoch(e['date']),
            time: e['time'],
            regionId: e['region_id'],
            name: e['name'],
            userPath: e['user_path'],
            markers: mapMarkers))
        .toList();
  }

  Future<int> createOfflineRecord({
    required DateTime date,
    required int time,
    required String name,
    int? referenceTrailId,
    required int regionId,
    required List<LatLng> userPath,
  }) async {
    var encodedPath = GeoUtils.encodePath(userPath);
    final db = await loadTrailsDb();
    return await db.insert('saved_records', {
      'date': date.millisecondsSinceEpoch,
      'time': time,
      'name': name,
      'region_id': regionId,
      'user_path': encodedPath,
      'reference_trail_id': referenceTrailId
    });
  }

  Future<void> deleteOfflineRecord(int recordId) async {
    final db = await loadTrailsDb();
    await db.delete('saved_records', where: 'id = ?', whereArgs: [recordId]);
  }

  Future<ImageProvider<Object>?> loadTileFromOfflineMap(
      MapProvider mapProvider, int z, int x, int y) async {
    var appDocDir = await getApplicationDocumentsDirectory();
    File f = File(appDocDir.path + '/${mapProvider.resIdentifier}.mbtiles');

    Database db = await openDatabase(f.path);
    List<Map> res = await db.query('tiles',
        where: 'zoom_level = ? AND tile_column = ? AND tile_row = ?',
        whereArgs: [z, x, (pow(2, z.toInt()) - 1) - y.toInt()]);
    if (res.length > 0) {
      var record = res.first;
      Uint8List bytes = record['tile_data'];
      return Image.memory(bytes).image;
    } else {
      return null;
    }
  }

  double _minmax(double a, double b, double c) {
    a = max(a, b);
    a = min(a, c);
    return a;
  }

  Tuple2<double, double> _projectPixels(LatLng location, int zoom,
      List<Tuple2<double, double>> zc, List<double> bc, List<double> cc) {
    var d = zc[zoom];
    var e = round(d.item1 + location.longitude * bc[zoom]);
    var f = _minmax(sin(DEG_TO_RAD * location.latitude), -0.9999, 0.9999);
    var g = round(d.item2 + 0.5 * log((1 + f) / (1 - f)) * -cc[zoom]);
    return Tuple2(e, g);
  }
}
