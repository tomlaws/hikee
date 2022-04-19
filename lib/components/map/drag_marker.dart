/// from: https://github.com/ibrierley/flutter_map_dragmarker
/// modified
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/floating_tooltip.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class DragMarkerPluginOptions extends LayerOptions {
  List<DragMarker> markers;
  List<Color>? gradientColors;

  DragMarkerPluginOptions({this.markers = const [], this.gradientColors});
}

class DragMarkerPlugin implements MapPlugin {
  @override
  Widget createLayer(LayerOptions options, MapState mapState, stream) {
    if (options is DragMarkerPluginOptions) {
      return StreamBuilder<int?>(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
            var dragMarkers = <Widget>[];
            DragMarker? selectedMarker =
                options.markers.firstWhereOrNull((m) => m.selected == true);
            if (selectedMarker == null && options.markers.length > 0) {
              options.markers.last.selected = true;
            }
            for (int i = 0; i < options.markers.length; ++i) {
              if (!_boundsContainsMarker(mapState, options.markers[i]))
                continue;
              List<Color>? colors = options.gradientColors;
              dragMarkers.add(DragMarkerLayer(
                mapState: mapState,
                marker: options.markers[i],
                color: colors?[i],
                stream: stream,
                options: options,
              ));
            }
            return Container(
              child: Stack(children: dragMarkers),
            );
          });
    }

    throw Exception('Unknown options type for MyCustom'
        'plugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is DragMarkerPluginOptions;
  }

  static bool _boundsContainsMarker(MapState map, DragMarker marker) {
    var pixelPoint = map.project(marker.point);

    final width = marker.width - marker.anchor.left;
    final height = marker.height - marker.anchor.top;

    var sw = CustomPoint(pixelPoint.x + width, pixelPoint.y - height);
    var ne = CustomPoint(pixelPoint.x - width, pixelPoint.y + height);

    return map.pixelBounds.containsPartialBounds(Bounds(sw, ne));
  }
}

class DragMarkerWidget extends StatelessWidget {
  final DragMarkerPluginOptions? options;
  final DragMarker marker;
  final Color? color;

  DragMarkerWidget({Key? key, required this.marker, this.options, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
    return DragMarkerLayer(
      marker: marker,
      options: options,
      mapState: mapState,
      stream: mapState.onMoved,
      color: color,
    );
  }
}

class DragMarkerLayer extends StatefulWidget {
  DragMarkerLayer({
    Key? key,
    this.mapState,
    required this.marker,
    AnchorPos? anchorPos,
    this.stream,
    this.options,
    this.color,
  }) : super(
            key:
                key); //: anchor = Anchor.forPos(anchorPos, marker.width, marker.height);

  final MapState? mapState;
  //final Anchor anchor;
  final DragMarker marker;
  final Stream<Null>? stream;
  final LayerOptions? options;
  final Color? color;

  @override
  _DragMarkerLayerState createState() => _DragMarkerLayerState();
}

class _DragMarkerLayerState extends State<DragMarkerLayer> {
  CustomPoint pixelPosition = CustomPoint(0.0, 0.0);
  late LatLng dragPosStart;
  late LatLng markerPointStart;
  late LatLng oldDragPosition;
  bool isDragging = false;

  static Timer? autoDragTimer;

  @override
  void initState() {
    super.initState();
  }

  MapState? get _mapState {
    return widget.mapState ?? MapState.maybeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context, _) {
          DragMarker marker = widget.marker;
          updatePixelPos(widget.marker.point);

          return GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onLongPressStart:
                widget.marker.draggable == false ? null : onLongPressStart,
            onLongPressMoveUpdate:
                widget.marker.draggable == false ? null : onLongPressMoveUpdate,
            onLongPressEnd:
                widget.marker.draggable == false ? null : onLongPressEnd,
            onTap: () {
              if (marker.onTap != null) marker.onTap!(marker.point);
            },
            onLongPress: () {
              if (marker.onLongPress != null) marker.onLongPress!(marker.point);
            },
            child: Stack(children: [
              if (marker.builder != null || marker.feedbackBuilder != null)
                Positioned(
                  width: marker.width,
                  height: marker.height,
                  left: pixelPosition.x +
                      ((isDragging && (marker.feedbackOffset != null))
                          ? marker.feedbackOffset.dx
                          : marker.offset.dx),
                  top: pixelPosition.y +
                      ((isDragging && (marker.feedbackOffset != null))
                          ? marker.feedbackOffset.dy
                          : marker.offset.dy),
                  child: (isDragging && (marker.feedbackBuilder != null))
                      ? marker.feedbackBuilder!(context)
                      : marker.builder!(context, widget.color),
                ),
              // if (marker.hasPopup)
              //   Positioned(
              //     child: GestureDetector(
              //       behavior: HitTestBehavior.translucent,
              //       onTap: marker.onPopupTap,
              //       child: FloatingTooltip(
              //           ignorePointer: false,
              //           compact: true,
              //           color: marker.popupColor,
              //           child: Icon(
              //             marker.popupIcon,
              //             color: Colors.white,
              //             size: 16,
              //           )),
              //     ),
              //     left: pixelPosition.x +
              //         ((isDragging && (marker.feedbackOffset != null))
              //             ? marker.feedbackOffset.dx
              //             : marker.offset.dx) +
              //         -6,
              //     top: pixelPosition.y +
              //         ((isDragging && (marker.feedbackOffset != null))
              //             ? marker.feedbackOffset.dy
              //             : marker.offset.dy) -
              //         32,
              //   ),
            ]),
          );
        });
  }

  void updatePixelPos(point) {
    DragMarker marker = widget.marker;
    MapState? mapState = _mapState;

    var pos;
    if (mapState != null) pos = mapState.project(point);
    if (mapState != null && pos != null)
      pos =
          pos.multiplyBy(mapState.getZoomScale(mapState.zoom, mapState.zoom)) -
              mapState.getPixelOrigin();

    pixelPosition = CustomPoint(
        (pos.x - (marker.width - widget.marker.anchor.left)).toDouble(),
        (pos.y - (marker.height - widget.marker.anchor.top)).toDouble());
  }

  void onLongPressStart(details) {
    isDragging = true;
    dragPosStart = _offsetToCrs(details.localPosition);
    markerPointStart =
        LatLng(widget.marker.point.latitude, widget.marker.point.longitude);

    if (widget.marker.onDragStart != null)
      widget.marker.onDragStart!(details, widget.marker.point);
    setState(() {});
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    bool isDragging = true;
    DragMarker marker = widget.marker;
    MapState? mapState = _mapState;

    var dragPos = _offsetToCrs(details.localPosition);

    var deltaLat = dragPos.latitude - dragPosStart.latitude;
    var deltaLon = dragPos.longitude - dragPosStart.longitude;

    var pixelB = mapState?.getLastPixelBounds();
    var pixelPoint = mapState?.project(widget.marker.point);

    /// If we're near an edge, move the map to compensate.

    if (marker.updateMapNearEdge) {
      /// How much we'll move the map by to compensate

      var autoOffsetX = 0.0;
      var autoOffsetY = 0.0;
      if (pixelB != null && pixelPoint != null) {
        if (pixelPoint.x + marker.width * marker.nearEdgeRatio >=
            pixelB.topRight.x) autoOffsetX = marker.nearEdgeSpeed;
        if (pixelPoint.x - marker.width * marker.nearEdgeRatio <=
            pixelB.bottomLeft.x) autoOffsetX = -marker.nearEdgeSpeed;
        if (pixelPoint.y - marker.height * marker.nearEdgeRatio <=
            pixelB.topRight.y) autoOffsetY = -marker.nearEdgeSpeed;
        if (pixelPoint.y + marker.height * marker.nearEdgeRatio >=
            pixelB.bottomLeft.y) autoOffsetY = marker.nearEdgeSpeed;
      }

      /// Sometimes when dragging the onDragEnd doesn't fire, so just stops dead.
      /// Here we allow a bit of time to keep dragging whilst user may move
      /// around a bit to keep it going.

      var lastTick = 0;
      if (autoDragTimer != null) lastTick = autoDragTimer!.tick;

      if ((autoOffsetY != 0.0) || (autoOffsetX != 0.0)) {
        adjustMapToMarker(widget, autoOffsetX, autoOffsetY);

        if ((autoDragTimer == null || autoDragTimer?.isActive == false) &&
            (isDragging == true)) {
          autoDragTimer =
              Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
            var tick = autoDragTimer?.tick;
            bool tickCheck = false;
            if (tick != null) {
              if (tick > lastTick + 15) tickCheck = true;
            }
            if (isDragging == false || tickCheck) {
              autoDragTimer?.cancel();
            } else {
              /// Note, we may have adjusted a few lines up in same drag,
              /// so could test for whether we've just done that
              /// this, but in reality it seems to work ok as is.

              adjustMapToMarker(widget, autoOffsetX, autoOffsetY);
            }
          });
        }
      }
    }

    setState(() {
      marker.point = LatLng(markerPointStart.latitude + deltaLat,
          markerPointStart.longitude + deltaLon);
      updatePixelPos(marker.point);
    });

    if (marker.onDragUpdate != null)
      marker.onDragUpdate!(details, marker.point);
  }

  /// If dragging near edge of the screen, adjust the map so we keep dragging

  void adjustMapToMarker(DragMarkerLayer widget, autoOffsetX, autoOffsetY) {
    DragMarker marker = widget.marker;
    MapState? mapState = _mapState;

    var oldMapPos = mapState?.project(mapState.center);
    var newMapLatLng;
    var oldMarkerPoint;
    if (oldMapPos != null) {
      newMapLatLng = mapState?.unproject(
          CustomPoint(oldMapPos.x + autoOffsetX, oldMapPos.y + autoOffsetY));
      oldMarkerPoint = mapState?.project(marker.point);
    }
    if (mapState != null) {
      marker.point = mapState.unproject(CustomPoint(
          oldMarkerPoint.x + autoOffsetX, oldMarkerPoint.y + autoOffsetY));

      mapState.move(newMapLatLng, mapState.zoom, source: MapEventSource.onDrag);
    }
  }

  void onLongPressEnd(details) {
    isDragging = false;
    if (autoDragTimer != null) autoDragTimer?.cancel();
    if (widget.marker.onDragEnd != null)
      widget.marker.onDragEnd!(details, widget.marker.point);
    setState(() {}); // Needed if using a feedback widget
  }

  static CustomPoint _offsetToPoint(Offset offset) {
    return CustomPoint(offset.dx, offset.dy);
  }

  LatLng _offsetToCrs(Offset offset) {
    // Get the widget's offset
    var renderObject = context.findRenderObject() as RenderBox;
    var width = renderObject.size.width;
    var height = renderObject.size.height;
    var mapState = _mapState!;

    // convert the point to global coordinates
    var localPoint = _offsetToPoint(offset);
    var localPointCenterDistance =
        CustomPoint((width / 2) - localPoint.x, (height / 2) - localPoint.y);
    if (mapState != null) {
      var mapCenter = mapState.project(mapState.center);
      var point = mapCenter - localPointCenterDistance;
      return mapState.unproject(point);
    }
    return LatLng(0, 0);
  }
}

class DragMarker {
  LatLng point;
  final Widget Function(BuildContext context, Color? color)? builder;
  final WidgetBuilder? feedbackBuilder;
  final Color color;
  final IconData popupIcon;
  final Function()? onPopupTap;
  final double width;
  final double height;
  final Offset offset;
  final Offset feedbackOffset;
  final Function(LongPressStartDetails, LatLng)? onDragStart;
  final Function(LongPressMoveUpdateDetails, LatLng)? onDragUpdate;
  final Function(LongPressEndDetails, LatLng)? onDragEnd;
  final Function(LatLng)? onTap;
  final Function(LatLng)? onLongPress;
  final bool updateMapNearEdge;
  final double nearEdgeRatio;
  final double nearEdgeSpeed;
  late Anchor anchor;
  bool? selected;
  bool draggable;

  DragMarker({
    required this.point,
    this.builder,
    this.feedbackBuilder,
    this.color = const Color(0xAF000000),
    this.popupIcon = Icons.message_rounded,
    this.onPopupTap,
    this.width = 30.0,
    this.height = 30.0,
    this.offset = const Offset(0.0, 0.0),
    this.feedbackOffset = const Offset(0.0, 0.0),
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onTap,
    this.onLongPress,
    this.updateMapNearEdge = false, // experimental
    this.nearEdgeRatio = 1.5,
    this.nearEdgeSpeed = 1.0,
    this.draggable = true,
    AnchorPos? anchorPos,
    Key? key,
  }) {
    anchor = Anchor.forPos(anchorPos, width, height);
  }
}
