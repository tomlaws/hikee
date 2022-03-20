import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Migrated to sound null safety
/// Source: https://github.com/DonWasyl/flutter_map_mbtiles_provider/blob/master/lib/flutter_map_mbtiles_provider.dart
class MBTilesProvider extends TileProvider {
  final Future<Database>? database;
  Database? _loadedDb;
  bool isDisposed = false;
  final bool autoClose;

  MBTilesProvider._({this.database, this.autoClose = true}) {}

  factory MBTilesProvider.fromDatabase(Future<Database> database,
          [bool autoClose = true]) =>
      MBTilesProvider._(database: database, autoClose: autoClose);

  @override
  void dispose() {
    if (_loadedDb != null) {
      if (autoClose) _loadedDb?.close();
      _loadedDb = null;
    }
    isDisposed = true;
  }

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    var x = coords.x.round();
    var y = options.tms
        ? invertY(coords.y.round(), coords.z.round())
        : coords.y.round();
    var z = coords.z.round();

    return MBTileImage(
      database!,
      Coords<int>(x, y)..z = z,
    );
  }
}

class MBTileImage extends ImageProvider<MBTileImage> {
  final Future<Database> database;
  final Coords<int> coords;

  MBTileImage(this.database, this.coords);

  @override
  ImageStreamCompleter load(MBTileImage key, decode) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: 1,
        informationCollector: () sync* {
          yield DiagnosticsProperty<ImageProvider>('Image provider', this);
          yield DiagnosticsProperty<ImageProvider>('Image key', key);
        });
  }

  Future<Codec> _loadAsync(MBTileImage key) async {
    assert(key == this);

    final db = await key.database;
    List<Map> result = await db.rawQuery('select tile_data from tiles '
        'where zoom_level = ${coords.z} AND '
        'tile_column = ${coords.x} AND '
        'tile_row = ${coords.y} limit 1');

    final Uint8List? bytes =
        result.isNotEmpty ? result.first['tile_data'] : null;

    if (bytes == null) {
      return Future<Codec>.error('Failed to load tile for coords: $coords');
    }
    return await PaintingBinding.instance!.instantiateImageCodec(bytes);
  }

  @override
  Future<MBTileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode => coords.hashCode;

  @override
  bool operator ==(other) {
    return other is MBTileImage &&
        coords == other.coords &&
        database == other.database;
  }
}
