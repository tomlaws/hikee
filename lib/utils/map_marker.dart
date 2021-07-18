import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker {
  static final MapMarker _mapMarker = MapMarker._internal();

  BitmapDescriptor? _startMarker, _endMarker;

  BitmapDescriptor get start => _startMarker ?? BitmapDescriptor.defaultMarker;
  BitmapDescriptor get end => _endMarker ?? BitmapDescriptor.defaultMarker;

  factory MapMarker() {
    return _mapMarker;
  }

  MapMarker._internal() {
    _buildMarkers();
  }

  void _buildMarkers() async {
    if (_startMarker == null)
      BitmapDescriptor.fromAssetImage(ImageConfiguration(),
              'assets/images/marker_start.png')
          .then((bd) => _startMarker = bd);
    if (_endMarker == null)
      BitmapDescriptor.fromAssetImage(ImageConfiguration(),
              'assets/images/marker_end.png')
          .then((bd) => _endMarker = bd);
  }

  Future<BitmapDescriptor> _buildMarker(Color color) async {
    final int diameter = 56;
    final double borderWidth = 4;
    final center = Offset(diameter / 2, diameter / 2);
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double radius = (diameter / 2) - borderWidth;

    Paint paintCircle = Paint()..color = color;
    Paint paintBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - (borderWidth / 2), paintCircle);
    canvas.drawCircle(center, radius, paintBorder);

    final img =
        await pictureRecorder.endRecording().toImage(diameter, diameter);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
