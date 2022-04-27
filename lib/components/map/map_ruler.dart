/// from: https://github.com/ibrierley/flutter_map_MapRuler
/// modified
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/floating_tooltip.dart';
import 'package:hikees/utils/geo.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class MapRulerPluginOptions extends LayerOptions {
  MapRulerPluginOptions();
}

class MapRulerWidget extends StatelessWidget {
  final MapRulerPluginOptions? options;

  MapRulerWidget({Key? key, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
    return MapRulerLayer(
      options: options,
      mapState: mapState,
      stream: mapState.onMoved,
    );
  }
}

class MapRulerLayer extends StatefulWidget {
  MapRulerLayer({
    Key? key,
    this.mapState,
    this.stream,
    this.options,
  }) : super(key: key);

  final MapState? mapState;
  final Stream<Null>? stream;
  final LayerOptions? options;

  @override
  _MapRulerLayerState createState() => _MapRulerLayerState();
}

class _MapRulerLayerState extends State<MapRulerLayer> {
  @override
  void initState() {
    super.initState();
  }

  MapState? get _mapState {
    return widget.mapState ?? MapState.maybeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context, snapshot) {
          var zoom = _mapState!.zoom;
          // https://gis.stackexchange.com/questions/7430/what-ratio-scales-do-google-maps-zoom-levels-correspond-to
          var a = 156543.03392 * cos(_mapState!.center.latitude * pi / 180);
          var b = pow(2, zoom);
          var metersPerPixel = a / b;
          var pixelsPerMeter = b / a;
          var widgetWidth = screenWidth * .3;
          var meters = widgetWidth * metersPerPixel;
          var max = double.parse(meters.toStringAsPrecision(1));
          var mid = max / 2;
          var min = 0;
          // meters back to pixel
          return Container(
            width: max * pixelsPerMeter,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black45),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: FractionalTranslation(
                          translation: ui.Offset(-0.5, 0),
                          child: Text(GeoUtils.formatMetres(min),
                              style: TextStyle(fontSize: 10, shadows: [
                                Shadow(
                                    // bottomLeft
                                    offset: Offset(-0.5, -0.5),
                                    color: Colors.white),
                                Shadow(
                                    // bottomRight
                                    offset: Offset(0.5, -0.5),
                                    color: Colors.white),
                                Shadow(
                                    // topRight
                                    offset: Offset(0.5, 0.5),
                                    color: Colors.white),
                                Shadow(
                                    // topLeft
                                    offset: Offset(-0.5, 0.5),
                                    color: Colors.white),
                              ])),
                        ),
                      ),
                      Positioned(
                        child: Text(GeoUtils.formatMetres(mid.round()),
                            style: TextStyle(fontSize: 10, shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-0.5, -0.5),
                                  color: Colors.white),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(0.5, -0.5),
                                  color: Colors.white),
                              Shadow(
                                  // topRight
                                  offset: Offset(0.5, 0.5),
                                  color: Colors.white),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-0.5, 0.5),
                                  color: Colors.white),
                            ])),
                      ),
                      Positioned(
                        right: 0,
                        child: FractionalTranslation(
                          translation: ui.Offset(0.5, 0),
                          child: Text(GeoUtils.formatMetres(max.round()),
                              style: TextStyle(fontSize: 10, shadows: [
                                Shadow(
                                    // bottomLeft
                                    offset: Offset(-0.5, -0.5),
                                    color: Colors.white),
                                Shadow(
                                    // bottomRight
                                    offset: Offset(0.5, -0.5),
                                    color: Colors.white),
                                Shadow(
                                    // topRight
                                    offset: Offset(0.5, 0.5),
                                    color: Colors.white),
                                Shadow(
                                    // topLeft
                                    offset: Offset(-0.5, 0.5),
                                    color: Colors.white),
                              ])),
                        ),
                      )
                    ],
                  ),
                ),
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(GeoUtils.formatMetres(min),
                //           style: TextStyle(fontSize: 10)),
                //       Text(GeoUtils.formatMetres((mid).round()),
                //           style: TextStyle(fontSize: 10)),
                //       Text(GeoUtils.formatMetres((max).round()),
                //           style: TextStyle(fontSize: 10)),
                //     ]),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.black45),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 4, width: 1, color: Colors.black45),
                        Container(height: 4, width: 1, color: Colors.black45),
                        Container(height: 4, width: 1, color: Colors.black45)
                      ]),
                )
              ],
            ),
          );
        });
  }
}
