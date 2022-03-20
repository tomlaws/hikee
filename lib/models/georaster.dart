import 'dart:io';
import 'dart:typed_data';

import 'package:geoimage/geoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/geoinfo.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';

/// Custom GeoRaster class for Hikees' exported GeoTiff
class GeoRaster extends AbstractGeoRaster {
  Uint8List _bytes;
  HdrImage? _raster;
  GeoInfo? _geoInfo;
  int? _rows;
  int? _cols;
  TiffInfo? _tiffInfo;
  TiffImage? _tiffImage;
  late List<List<double>> dataList;
  bool isEsriAsc = false;
  bool isTiff = false;
  bool writeMode = false;

  GeoRaster(this._bytes);

  @override
  void read([int? imageIndex]) {
    if (imageIndex == null) {
      imageIndex = 0;
    }

    // right now geotiff ad esri ascii grids are supported
    var tiffDecoder = TiffDecoder();
    _raster = tiffDecoder.decodeHdrImage(_bytes, frame: imageIndex);
    _tiffInfo = tiffDecoder.info;
    _tiffImage = _tiffInfo?.images[imageIndex];

    if (_raster == null) {
      throw StateError("Unable to decode tiff.");
    }

    _geoInfo = GeoInfo(_tiffImage!);
    _rows = _geoInfo!.rows;
    _cols = _geoInfo!.cols;
    isTiff = true;
  }

  @override
  void write(String path) {
    throw StateError("This raster is not in write mode.");
  }

  @override
  Image? get image => null;

  @override
  List<int>? get imageBytes => null;

  @override
  GeoInfo? get geoInfo => _geoInfo;

  @override
  int? get bands => _raster?.numberOfChannels;

  @override
  void loopWithFloatValue(Function colRowValueFunction) {
    if (_rows == null || _cols == null) {
      throw StateError("rows and cols are null");
    }
    for (var r = 0; r < _rows!; r++) {
      for (var c = 0; c < _cols!; c++) {
        colRowValueFunction(c, r, getDouble(c, r));
      }
    }
  }

  @override
  void loopWithIntValue(Function colRowValueFunction) {
    if (_rows == null || _cols == null) {
      throw StateError("rows and cols are null");
    }
    for (var r = 0; r < _rows!; r++) {
      for (var c = 0; c < _cols!; c++) {
        colRowValueFunction(c, r, getInt(c, r));
      }
    }
  }

  @override
  void loopWithGridNode(Function gridNodeFunction) {
    if (_rows == null || _cols == null) {
      throw StateError("rows and cols are null");
    }
    for (var r = 0; r < _rows!; r++) {
      for (var c = 0; c < _cols!; c++) {
        gridNodeFunction(GridNode(this, c, r));
      }
    }
  }

  @override
  double getDouble(int col, int row, [int? band]) {
    if (isEsriAsc) {
      return dataList[row][col].toDouble();
    } else {
      if (_raster == null) {
        throw StateError("raster is null");
      }
      if (band == null || band == 0) {
        return _raster!.red!.getFloat(col, row);
      } else if (band == 1) {
        return _raster!.green!.getFloat(col, row);
      } else if (band == 2) {
        return _raster!.blue!.getFloat(col, row);
      }
      throw StateError("invalid band number");
    }
  }

  @override
  int getInt(int col, int row, [int? band]) {
    if (isEsriAsc) {
      return dataList[row][col].toInt();
    } else {
      if (_raster == null) {
        throw StateError("raster is null");
      }
      if (band == null || band == 0) {
        return _raster!.red!.getInt(col, row);
      } else if (band == 1) {
        return _raster!.green!.getInt(col, row);
      } else if (band == 2) {
        return _raster!.blue!.getInt(col, row);
      }
      throw StateError("invalid band number");
    }
  }

  @override
  void setDouble(int col, int row, double value, [int? band]) {
    if (isEsriAsc) {
      dataList[row][col] = value;
    } else {
      throw UnsupportedError("Only esri asc types are writable");
    }
  }

  @override
  void setInt(int col, int row, int value, [int? band]) {
    if (isEsriAsc) {
      dataList[row][col] = value.toDouble();
    } else {
      throw UnsupportedError("Only esri asc types are writable");
    }
  }

  @override
  List<int>? getTag(int key) {
    if (_tiffImage != null) {
      var tag = _tiffImage!.tags[key];
      if (tag != null) {
        return tag.readValues();
      }
    }
    return null;
  }

  @override
  bool hasTags() {
    return _tiffImage != null ? true : false;
  }
}
