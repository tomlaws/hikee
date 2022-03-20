import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/map.dart';
import 'package:latlong2/latlong.dart';

class PolylineLayerOptions extends LayerOptions {
  final List<Polyline> polylines;
  final bool polylineCulling;

  PolylineLayerOptions({
    Key? key,
    this.polylines = const [],
    this.polylineCulling = false,
    Stream<Null>? rebuild,
  }) : super(key: key, rebuild: rebuild) {
    if (polylineCulling) {
      for (var polyline in polylines) {
        polyline.boundingBox = LatLngBounds.fromPoints(polyline.points);
      }
    }
  }
}

class Polyline {
  final List<LatLng> points;
  final List<Offset> offsets = [];
  final double strokeWidth;
  final Color color;
  final double borderStrokeWidth;
  final Color? borderColor;
  final List<Color>? gradientColors;
  final List<Color>? borderGradientColors;
  final List<Color>? shadowGradientColors;
  final List<double>? colorsStop;
  final bool isDotted;
  final bool arrow;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  late LatLngBounds boundingBox;

  Polyline({
    required this.points,
    this.strokeWidth = 1.0,
    this.color = const Color(0xFF00FF00),
    this.borderStrokeWidth = 0.0,
    this.borderColor = const Color(0xFF000000),
    this.gradientColors,
    this.borderGradientColors,
    this.shadowGradientColors,
    this.colorsStop,
    this.isDotted = false,
    this.arrow = false,
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
  });
}

class PolylineLayerWidget extends StatelessWidget {
  final PolylineLayerOptions options;

  PolylineLayerWidget({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
    return PolylineLayer(options, mapState, mapState.onMoved);
  }
}

class PolylineLayer extends StatelessWidget {
  final PolylineLayerOptions polylineOpts;
  final MapState map;
  final Stream<Null>? stream;

  PolylineLayer(this.polylineOpts, this.map, this.stream)
      : super(key: polylineOpts.key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints bc) {
        final size = Size(bc.maxWidth, bc.maxHeight);
        return _build(context, size);
      },
    );
  }

  Widget _build(BuildContext context, Size size) {
    return StreamBuilder<void>(
      stream: stream, // a Stream<void> or null
      builder: (BuildContext context, _) {
        var polylines = <Widget>[];

        for (var polylineOpt in polylineOpts.polylines) {
          polylineOpt.offsets.clear();

          if (polylineOpts.polylineCulling &&
              !polylineOpt.boundingBox.isOverlapping(map.bounds)) {
            // skip this polyline as it's offscreen
            continue;
          }

          _fillOffsets(polylineOpt.offsets, polylineOpt.points);

          polylines.add(CustomPaint(
            painter: PolylinePainter(polylineOpt),
            size: size,
            willChange: true,
          ));
        }

        return Container(
          child: Stack(
            children: polylines,
          ),
        );
      },
    );
  }

  void _fillOffsets(final List<Offset> offsets, final List<LatLng> points) {
    for (var i = 0, len = points.length; i < len; ++i) {
      var point = points[i];

      var pos = map.project(point);
      pos = pos.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
          map.getPixelOrigin();
      offsets.add(Offset(pos.x.toDouble(), pos.y.toDouble()));
      if (i > 0) {
        offsets.add(Offset(pos.x.toDouble(), pos.y.toDouble()));
      }
    }
  }
}

class PolylinePainter extends CustomPainter {
  final Polyline polylineOpt;

  PolylinePainter(this.polylineOpt);

  @override
  void paint(Canvas canvas, Size size) {
    if (polylineOpt.offsets.isEmpty) {
      return;
    }
    final rect = Offset.zero & size;
    canvas.clipRect(rect);
    final paint = Paint()
      ..strokeWidth = polylineOpt.strokeWidth
      ..strokeCap = polylineOpt.strokeCap
      ..strokeJoin = polylineOpt.strokeJoin
      ..blendMode = BlendMode.color;

    if (polylineOpt.gradientColors == null) {
      paint.color = polylineOpt.color;
    } else {
      polylineOpt.gradientColors!.isNotEmpty
          ? paint.shader = _paintGradient()
          : paint.color = polylineOpt.color;
    }

    Paint? filterPaint;
    if (polylineOpt.borderColor != null) {
      filterPaint = Paint()
        ..color = polylineOpt.borderColor!.withAlpha(255)
        ..strokeWidth = polylineOpt.strokeWidth
        ..strokeCap = polylineOpt.strokeCap
        ..strokeJoin = polylineOpt.strokeJoin
        ..blendMode = BlendMode.dstIn;
    }
    if (polylineOpt.gradientColors != null &&
        polylineOpt.gradientColors!.isNotEmpty) {
      filterPaint?.shader = _paintGradient();
    }

    final borderPaint = polylineOpt.borderStrokeWidth > 0.0
        ? (Paint()
          ..color = polylineOpt.borderColor ?? Color(0x00000000)
          ..strokeWidth =
              polylineOpt.strokeWidth + polylineOpt.borderStrokeWidth
          ..strokeCap = polylineOpt.strokeCap
          ..strokeJoin = polylineOpt.strokeJoin)
        : null;
    if (polylineOpt.borderGradientColors == null) {
      borderPaint?.color = polylineOpt.borderColor ?? Color(0x00000000);
    } else {
      polylineOpt.borderGradientColors!.isNotEmpty
          ? borderPaint?.shader = _paintBorderGradient()
          : borderPaint?.color = polylineOpt.borderColor ?? Color(0x00000000);
    }
    var radius = paint.strokeWidth / 2;
    var borderRadius = radius + (polylineOpt.borderStrokeWidth) / 2;
    if (polylineOpt.isDotted) {
      var spacing = borderRadius * 2 * 2;
      canvas.saveLayer(rect, Paint());
      if (borderPaint != null && filterPaint != null) {
        if (polylineOpt.shadowGradientColors != null) {
          //shadow
          Paint shadowPaint = Paint()
            ..color = Color(0xFF000000)
            ..shader = _paintShadowGradient()
            ..strokeWidth = polylineOpt.strokeWidth
            ..strokeCap = polylineOpt.strokeCap
            ..style = PaintingStyle.stroke
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6)
            ..strokeJoin = polylineOpt.strokeJoin;
          _paintLine(canvas, polylineOpt.offsets, shadowPaint);
        }
        _paintDottedLine(
            canvas, polylineOpt.offsets, borderRadius, spacing, borderPaint);
        _paintDottedLine(
            canvas, polylineOpt.offsets, radius, spacing, filterPaint);
      }
      canvas.restore();
      canvas.saveLayer(rect, Paint());
      _paintDottedLine(canvas, polylineOpt.offsets, radius, spacing, paint);
      canvas.restore();
    } else {
      paint.style = PaintingStyle.stroke;
      canvas.saveLayer(rect, Paint());
      if (borderPaint != null && filterPaint != null) {
        if (polylineOpt.shadowGradientColors != null) {
          //shadow
          Paint shadowPaint = Paint()
            ..color = Color(0xFF000000)
            ..shader = _paintShadowGradient()
            ..strokeWidth = polylineOpt.strokeWidth
            ..strokeCap = polylineOpt.strokeCap
            ..style = PaintingStyle.stroke
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6)
            ..strokeJoin = polylineOpt.strokeJoin;
          _paintLine(canvas, polylineOpt.offsets, shadowPaint);
        }
        borderPaint.style = PaintingStyle.stroke;
        _paintLine(canvas, polylineOpt.offsets, borderPaint);
        filterPaint.style = PaintingStyle.stroke;
        _paintLine(canvas, polylineOpt.offsets, filterPaint);
      }
      canvas.restore();
      canvas.saveLayer(rect, Paint());
      _paintLine(canvas, polylineOpt.offsets, paint);
      // if (polylineOpt.arrow) {
      //   Paint arrowPaint = Paint()..color = Color(0xFFFFFFFF);
      //   _paintArrowedLine(
      //       canvas, polylineOpt.offsets, radius, 24.0, arrowPaint);
      // }
      canvas.restore();
    }
  }

  Offset rotatePoint(Offset offset, Offset centerOffset, double radian) {
    var newx = (offset.dx - centerOffset.dx) * cos(radian) -
        (offset.dy - centerOffset.dy) * sin(radian) +
        centerOffset.dx;
    var newy = (offset.dx - centerOffset.dx) * sin(radian) +
        (offset.dy - centerOffset.dy) * cos(radian) +
        centerOffset.dy;
    return ui.Offset(newx, newy);
  }

  void _paintDottedLine(Canvas canvas, List<Offset> offsets, double radius,
      double stepLength, Paint paint) {
    final path = ui.Path();
    var startDistance = 0.0;
    for (var i = 0; i < offsets.length - 1; i++) {
      var o0 = offsets[i];
      var o1 = offsets[i + 1];
      var totalDistance = _dist(o0, o1);
      var distance = startDistance;
      while (distance < totalDistance) {
        var f1 = distance / totalDistance;
        var f0 = 1.0 - f1;
        var offset = Offset(o0.dx * f0 + o1.dx * f1, o0.dy * f0 + o1.dy * f1);
        path.addOval(Rect.fromCircle(center: offset, radius: radius));
        distance += stepLength;
      }
      startDistance = distance < totalDistance
          ? stepLength - (totalDistance - distance)
          : distance - totalDistance;
    }

    path.addOval(
        Rect.fromCircle(center: polylineOpt.offsets.last, radius: radius));
    canvas.drawPath(path, paint);
  }

  void _paintArrowedLine(Canvas canvas, List<Offset> offsets, double radius,
      double stepLength, Paint paint) {
    final path = ui.Path();
    var startDistance = 0.0;
    Offset? lastOffset;
    for (var i = 0; i < offsets.length - 1; i++) {
      var o0 = offsets[i];
      var o1 = offsets[i + 1];
      var totalDistance = _dist(o0, o1);
      var distance = startDistance;
      while (distance < totalDistance) {
        var f1 = distance / totalDistance;
        var f0 = 1.0 - f1;
        var offset = Offset(o0.dx * f0 + o1.dx * f1, o0.dy * f0 + o1.dy * f1);

        // draw back arrow for last point
        if (lastOffset != null) {
          var w = 2.0;
          var hh = 4.0;
          double radian =
              atan2(offset.dy - lastOffset.dy, offset.dx - lastOffset.dx);
          path.addPolygon(
              [
                lastOffset,
                lastOffset.translate(-hh, -hh),
                lastOffset.translate(-hh + w, -hh),
                lastOffset.translate(w, 0),
                lastOffset.translate(-hh + w, hh),
                lastOffset.translate(-hh, hh)
              ].map((e) => rotatePoint(e, lastOffset!, radian)).toList(),
              true);
        }
        lastOffset = offset;
        //path.addRect(Rect.fromCenter(center: offset, width: 14, height: 14));

        //path.addOval(Rect.fromCircle(center: offset, radius: radius));
        distance += stepLength;
      }
      startDistance = distance < totalDistance
          ? stepLength - (totalDistance - distance)
          : distance - totalDistance;
    }

    //path.addOval(
    //    Rect.fromCircle(center: polylineOpt.offsets.last, radius: radius));
    canvas.drawPath(path, paint);
  }

  void _paintLine(Canvas canvas, List<Offset> offsets, Paint paint) {
    if (offsets.isNotEmpty) {
      final path = ui.Path()..moveTo(offsets[0].dx, offsets[0].dy);
      for (var offset in offsets) {
        path.lineTo(offset.dx, offset.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  ui.Gradient _paintGradient() => ui.Gradient.linear(
      polylineOpt.offsets.first,
      polylineOpt.offsets.last,
      polylineOpt.gradientColors!,
      _getColorsStop(polylineOpt.gradientColors!));

  ui.Gradient _paintBorderGradient() => ui.Gradient.linear(
      polylineOpt.offsets.first,
      polylineOpt.offsets.last,
      polylineOpt.borderGradientColors!,
      _getColorsStop(polylineOpt.borderGradientColors!));

  ui.Gradient _paintShadowGradient() => ui.Gradient.linear(
      polylineOpt.offsets.first,
      polylineOpt.offsets.last,
      polylineOpt.shadowGradientColors!,
      _getColorsStop(polylineOpt.shadowGradientColors!));

  List<double>? _getColorsStop(List<Color> colors) =>
      (polylineOpt.colorsStop != null &&
              polylineOpt.colorsStop!.length == colors.length)
          ? polylineOpt.colorsStop
          : _calculateColorsStop(colors);

  List<double> _calculateColorsStop(List<Color> colors) {
    final colorsStopInterval = 1.0 / colors.length;
    return colors
        .map((gradientColor) =>
            colors.indexOf(gradientColor) * colorsStopInterval)
        .toList();
  }

  @override
  bool shouldRepaint(PolylinePainter other) => false;
}

double _dist(Offset v, Offset w) {
  return sqrt(_dist2(v, w));
}

double _dist2(Offset v, Offset w) {
  return _sqr(v.dx - w.dx) + _sqr(v.dy - w.dy);
}

double _sqr(double x) {
  return x * x;
}
