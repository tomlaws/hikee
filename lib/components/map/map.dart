import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'
    hide Polyline, PolylineLayer, PolylineLayerOptions, PolylineLayerWidget;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/components/map/drag_marker.dart';
import 'package:hikees/components/map/map_controller.dart';
import 'package:hikees/components/map/mbtiles_provider.dart';
import 'package:hikees/components/trails/hkpd_profile.dart';
import 'package:hikees/models/hk_datum.dart';
import 'package:hikees/models/preferences.dart';
import 'package:hikees/providers/preferences.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/color.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikees/utils/geo.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'polyline_layer.dart';

class HikeeMap extends StatelessWidget {
  HikeeMap(
      {Key? key,
      this.path,
      this.userPath,
      this.zoom = 10,
      this.pathOnly = false,
      this.showCenterOnLocationUpdateButton = false,
      this.positionStream,
      this.headingStream,
      this.onTap,
      this.onLongPress,
      this.markers,
      this.onMapCreated,
      this.interactiveFlag,
      this.watermarkAlignment = Alignment.bottomLeft,
      this.verticalDatum = true,
      this.contentMargin = const EdgeInsets.all(8),
      bool offlineTrail = false})
      : super(key: key) {
    _key = key?.toString();
    controller = Get.put(HikeeMapController(), tag: key?.toString());
    if ((path == null || path?.length == 0) &&
        (userPath == null || userPath?.length == 0))
      controller.focusCurrentLocationOnce(positionStream);
    controller.offlineTrail.value = offlineTrail;
  }

  late final String? _key;
  late final HikeeMapController controller;
  final List<LatLng>? path;
  final List<LatLng>? userPath;
  final double zoom;
  final bool pathOnly;
  final bool showCenterOnLocationUpdateButton;
  final Stream<LocationMarkerPosition?>? positionStream;
  final Stream<LocationMarkerHeading?>? headingStream;
  final Function(LatLng)? onTap;
  final void Function(LatLng)? onLongPress;
  final List<DragMarker>? markers;
  final void Function(HikeeMapController)? onMapCreated;
  final int? interactiveFlag;
  final AlignmentGeometry watermarkAlignment;
  final EdgeInsets contentMargin;
  final bool verticalDatum;

  String get urlTemplate {
    switch (controller.mapProvider) {
      case MapProvider.OpenStreetMap:
        return "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
      case null:
      case MapProvider.OpenStreetMapCyclOSM:
        return "https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png";
      case MapProvider.LandsDepartment:
        return controller.imagery.value
            ? "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/imagery/WGS84/{z}/{x}/{y}.png"
            : "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/basemap/WGS84/{z}/{x}/{y}.png";
    }
  }

  Widget get providerAttribution {
    switch (controller.mapProvider) {
      case null:
      case MapProvider.OpenStreetMap:
      case MapProvider.OpenStreetMapCyclOSM:
        return Container(
            margin: contentMargin,
            child: Text("© OpenStreetMap",
                style: TextStyle(
                    color: Colors.white.withOpacity(.85),
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        color: Color.fromARGB(132, 0, 0, 0),
                      ),
                    ],
                    fontWeight: FontWeight.w600)));
      case MapProvider.LandsDepartment:
        return Container(
            margin: contentMargin,
            child: Opacity(
              opacity: .5,
              child: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset('assets/images/lands_department.png'),
              ),
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var center = LatLng(22.302711, 114.177216);
    final LatLngBounds hkBounds = LatLngBounds(
      LatLng(22.56998, 114.45588),
      LatLng(22.152586, 113.826099),
    );
    var bounds = hkBounds;

    List<LatLng>? focusingPath;
    if (pathOnly) {
      focusingPath = path ?? userPath;
      if (focusingPath != null && focusingPath.length > 0) {
        var _bounds = GeoUtils.getPathBounds(focusingPath);
        bounds = _bounds;
      }
    }

    center = bounds.center;

    LatLng? finishMarker;
    if (path != null) {
      if (path!.length > 1) {
        finishMarker = path!.last;
      }
    }
    if (pathOnly && path != null) {
      if (path!.length > 1) finishMarker = path!.last;
    }
    LatLng? startMarker;
    double startMarkerAngle = 0.0;
    if (path != null && path!.length > 0) {
      startMarker = path!.first;
      // get next 5 point and avg
      if (path!.length > 1) {
        var prevPt = path!.elementAt(0);
        var pt = path!.elementAt(1);
        var startLat = prevPt.latitude * pi / 180;
        var startLng = prevPt.longitude * pi / 180;
        var destLat = pt.latitude * pi / 180;
        var destLng = pt.longitude * pi / 180;
        var y = sin(destLng - startLng) * cos(destLat);
        var x = cos(startLat) * sin(destLat) -
            sin(startLat) * cos(destLat) * cos(destLng - startLng);
        double theta = atan2(y, x);
        startMarkerAngle = theta;
      }
    }
    // check if start marker and finish marker are too close
    if (startMarker != null && finishMarker != null) {
      final distBetweenStartAndEndInMeters =
          GeoUtils.calculateDistance(startMarker, finishMarker) * 1000;
      // difference < 10meters
      if (distBetweenStartAndEndInMeters < 10) {
        // try differentiate them to avoid the start marker overlap with the finish marker
        for (int i = 1; i < 10; ++i) {
          finishMarker = path?.elementAt(path!.length - 1 - i);
          startMarker = path?.elementAt(i);
          final newDist =
              GeoUtils.calculateDistance(startMarker!, finishMarker!) * 1000;
          if (newDist > 15) {
            break;
          }
        }
      }
    }
    return FlutterMap(
      key: Key(_key ?? '-flutter-map'),
      children: [
        Obx(() => TileLayerWidget(
            key: Key(controller.mapProvider.toString()),
            options: TileLayerOptions(
              tms: controller.tms,
              urlTemplate: urlTemplate,
              subdomains: ['a', 'b', 'c'],
              errorImage: Image.asset('assets/images/not_available.jpg').image,
              errorTileCallback: (tile, __) {
                controller.loadFallbackTile(tile);
              },
              tileProvider: controller.offlineTrail.value
                  ? (controller.offlineTrailProvider ??
                      NonCachingNetworkTileProvider())
                  : NonCachingNetworkTileProvider(),
              backgroundColor: Colors.transparent,
            ))),
        Obx(() => controller.mapProvider == MapProvider.LandsDepartment &&
                controller.offlineTrail.value == false
            ? TileLayerWidget(
                options: TileLayerOptions(
                    urlTemplate:
                        "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/label/hk/en/WGS84/{z}/{x}/{y}.png",
                    backgroundColor: Colors.transparent),
              )
            : SizedBox()),
        PolylineLayerWidget(
          options: PolylineLayerOptions(
            polylines: [
              if (path != null)
                Polyline(
                    gradientColors: Themes.gradientColors,
                    shadowGradientColors: userPath != null
                        ? [
                            Color.fromARGB(99, 37, 124, 153),
                            Color.fromARGB(99, 31, 189, 147),
                          ]
                        : [
                            Color.fromARGB(255, 37, 124, 153),
                            Color.fromARGB(255, 31, 189, 147),
                          ],
                    borderColor: Colors.white,
                    borderStrokeWidth: 2.0,
                    points: path!,
                    strokeWidth: userPath != null ? 8.0 : 4.0,
                    isDotted: userPath != null ? true : false),
              if (userPath != null)
                Polyline(
                  gradientColors: Themes.gradientColors,
                  strokeWidth: 4.0,
                  shadowGradientColors: [
                    Color.fromARGB(255, 37, 124, 153),
                    Color.fromARGB(255, 31, 189, 147),
                  ],
                  borderColor: Colors.white,
                  borderStrokeWidth: 2.0,
                  points: userPath!,
                ),
            ],
          ),
        ),
        MarkerLayerWidget(
            options: MarkerLayerOptions(
          markers: [
            if (startMarker != null)
              Marker(
                width: 20,
                height: 20,
                point: startMarker,
                builder: (ctx) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: Themes.gradientColors.first,
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Themes.gradientColors.first.withOpacity(.75),
                              blurRadius: 4,
                              spreadRadius: 2)
                        ]),
                    child: Center(
                      child: Transform.rotate(
                        angle: pi / 2 + startMarkerAngle,
                        child: Icon(Icons.chevron_left_rounded,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            if (finishMarker != null)
              Marker(
                width: 20,
                height: 20,
                point: finishMarker,
                builder: (ctx) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromARGB(255, 31, 189, 147),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 31, 189, 147)
                                  .withOpacity(.75),
                              blurRadius: 4,
                              spreadRadius: 2)
                        ]),
                    child: Center(
                      child: Icon(Icons.flag_rounded,
                          size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (userPath != null && userPath!.length > 0) ...[
              Marker(
                width: 20,
                height: 20,
                point: userPath!.first,
                builder: (ctx) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: Themes.gradientColors.first,
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Themes.gradientColors.first.withOpacity(.75),
                              blurRadius: 4,
                              spreadRadius: 2)
                        ]),
                    child: Center(
                      child: Icon(Icons.directions_walk_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Marker(
                width: 20,
                height: 20,
                point: userPath!.last,
                builder: (ctx) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: Themes.gradientColors.first,
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Themes.gradientColors.last.withOpacity(.75),
                              blurRadius: 4,
                              spreadRadius: 2)
                        ]),
                    child: Center(
                      child: Icon(Icons.done, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ]
          ],
        )),
        if (positionStream != null)
          Obx(
            () => LocationMarkerLayerWidget(
              options: LocationMarkerLayerOptions(
                  positionStream: positionStream!
                      .where((event) => event != null)
                      .map((event) => event!),
                  headingStream: headingStream
                      ?.where((event) => event != null)
                      .map((event) {
                    return event!;
                  })),
              plugin: LocationMarkerPlugin(
                centerCurrentLocationStream:
                    controller.centerCurrentLocationStreamController.stream,
                centerOnLocationUpdate: controller.centerOnLocationUpdate.value
                    ? CenterOnLocationUpdate.always
                    : CenterOnLocationUpdate.never,
              ),
            ),
          ),
      ],
      nonRotatedChildren: [
        Align(alignment: Alignment.bottomLeft, child: providerAttribution),
        if (verticalDatum)
          Obx(() {
            if (controller.showHeights.value &&
                controller.heights.value != null) {
              return Container(
                margin: contentMargin.copyWith(right: 56 + 8),
                padding: EdgeInsets.only(top: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: HKPDProfile(datums: controller.heights.value!),
              );
            }
            return SizedBox();
          }),
        if (verticalDatum && focusingPath != null)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: contentMargin,
              child: MutationBuilder<List<HKDatum>>(
                mutation: () {
                  if (focusingPath == null) return Future.value([]);
                  return controller.getHeights(focusingPath);
                },
                builder: (mutate, loading) {
                  return Obx(() => Button(
                      icon: Icon(
                        LineAwesomeIcons.mountain,
                        color: controller.showHeights.value
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                      invert: controller.showHeights.value ? false : true,
                      loading: loading,
                      onPressed: () {
                        mutate();
                      }));
                },
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: contentMargin,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (interactiveFlag != InteractiveFlag.none &&
                    (focusingPath != null && focusingPath.length > 0))
                  Button(
                    icon: Icon(
                      LineAwesomeIcons.expand,
                      color: Theme.of(context).primaryColor,
                    ),
                    invert: true,
                    onPressed: () {
                      if (path == null) {
                        if (userPath != null) {
                          if (userPath!.length > 0)
                            controller.focusPath(userPath!);
                        }
                      } else {
                        if (path!.length > 0) controller.focusPath(path!);
                      }
                    },
                  ),
                Obx(() =>
                    controller.mapProvider == MapProvider.LandsDepartment &&
                            controller.offlineTrail.value == false
                        ? Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            child: Button(
                              icon: Icon(
                                LineAwesomeIcons.layer_group,
                                color: controller.imagery.value
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              invert: controller.imagery.value ? false : true,
                              onPressed: () {
                                controller.imagery.value =
                                    !controller.imagery.value;
                              },
                            ),
                          )
                        : SizedBox()),
                if (showCenterOnLocationUpdateButton) ...[
                  Container(
                    height: 8,
                  ),
                  Obx(() => Button(
                        icon: Icon(
                          LineAwesomeIcons.map_marker,
                          color: controller.centerOnLocationUpdate.value
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        invert: controller.centerOnLocationUpdate.value
                            ? false
                            : true,
                        onPressed: () async {
                          controller.centerOnLocationUpdate.toggle();
                          controller.focusCurrentLocation();
                        },
                      ))
                ]
              ],
            ),
          ),
        )
      ],
      options: MapOptions(
          interactiveFlags: interactiveFlag ?? InteractiveFlag.all,
          onTap: (_, pos) {
            if (this.onTap != null) {
              this.onTap!(pos);
            }
          },
          onMapCreated: (mapController) {
            controller.mapController = mapController;
            if (onMapCreated != null) onMapCreated!(controller);
            if (pathOnly) {
              if (focusingPath == null || focusingPath.length > 0) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  var r = mapController.centerZoomFitBounds(bounds,
                      options: FitBoundsOptions(padding: EdgeInsets.all(64)));
                  mapController.move(r.center, r.zoom);
                });
              }
            }
          },
          onLongPress: onLongPress == null
              ? null
              : (_, location) => onLongPress!(location),
          zoom: zoom,
          maxZoom: 17,
          minZoom: 11,
          slideOnBoundaries: true,
          //allowPanningOnScrollingParent: false,
          center: center,
          nePanBoundary: hkBounds.northEast,
          swPanBoundary: hkBounds.southWest,
          onPositionChanged: (MapPosition position, bool hasGesture) {
            if (hasGesture) {
              if (controller.centerOnLocationUpdate.value) {
                controller.centerOnLocationUpdate.value = false;
              }
            }
          },
          plugins: [
            DragMarkerPlugin(),
          ]),
      layers: [
        if (markers != null) DragMarkerPluginOptions(markers: markers!),
      ],
    );
  }
}
