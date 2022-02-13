import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/drag_marker.dart';
import 'package:hikee/components/map/map_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/utils/geo.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
      this.markers,
      this.onMapCreated,
      this.interactiveFlag,
      this.watermarkAlignment = Alignment.bottomLeft,
      this.contentMargin = const EdgeInsets.all(8)})
      : super(key: key) {
    controller = Get.put(HikeeMapController(), tag: key?.toString());
  }
  late final HikeeMapController controller;
  final List<LatLng>? path;
  final List<LatLng>? userPath;
  final double zoom;
  final bool pathOnly;
  final bool showCenterOnLocationUpdateButton;
  final Stream<LocationMarkerPosition?>? positionStream;
  final Stream<LocationMarkerHeading?>? headingStream;
  final Function(LatLng)? onTap;
  final List<DragMarker>? markers;
  final void Function(HikeeMapController)? onMapCreated;
  final int? interactiveFlag;
  final AlignmentGeometry watermarkAlignment;
  final EdgeInsets contentMargin;

  bool isOutOfBounds(LatLng? center, LatLng? sw, LatLng? ne) {
    if (sw != null && ne != null) {
      if (center == null) {
        return true;
      } else if (center.latitude < sw.latitude ||
          center.latitude > ne.latitude) {
        return true;
      } else if (center.longitude < sw.longitude ||
          center.longitude > ne.longitude) {
        return true;
      }
    }
    return false;
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
    if (markers == null && path != null) {
      if (path!.length > 1) {
        finishMarker = path!.last;
      }
    }
    if (pathOnly && path != null) {
      if (path!.length > 1) finishMarker = path!.last;
    }

    return FlutterMap(
      children: [
        Obx(() => TileLayerWidget(
            options: TileLayerOptions(
                urlTemplate: controller.imagery.value
                    ? "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/imagery/WGS84/{z}/{x}/{y}.png"
                    : "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/basemap/WGS84/{z}/{x}/{y}.png",
                errorTileCallback: (_, __) {},
                evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
                backgroundColor: Colors.transparent,
                tilesContainerBuilder: (context, child, _) {
                  return child;
                }))),
        TileLayerWidget(
          options: TileLayerOptions(
              urlTemplate:
                  "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/label/hk/en/WGS84/{z}/{x}/{y}.png",
              errorTileCallback: (_, __) {},
              evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
              backgroundColor: Colors.transparent),
        ),
        PolylineLayerWidget(
          options: PolylineLayerOptions(
            polylines: [
              if (path != null)
                Polyline(
                  gradientColors: [
                    Color.fromARGB(255, 0, 138, 202)
                        .withOpacity(userPath != null ? .5 : 1),
                    Color.fromARGB(255, 149, 65, 197)
                        .withOpacity(userPath != null ? .5 : 1),
                  ],
                  borderColor: Colors.white,
                  borderStrokeWidth: 4.0,
                  points: path!,
                  strokeWidth: 6.0,
                ),
              if (userPath != null)
                Polyline(
                  gradientColors: [
                    Color.fromARGB(255, 0, 138, 202),
                    Color.fromARGB(255, 149, 65, 197),
                  ],
                  points: userPath!,
                  strokeWidth: 6.0,
                  borderStrokeWidth: 4.0,
                  borderColor: Colors.white,
                ),
            ],
          ),
        ),
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
                centerOnLocationUpdate: controller.centerOnLocationUpdate.value
                    ? CenterOnLocationUpdate.always
                    : CenterOnLocationUpdate.never,
              ),
            ),
          ),
      ],
      nonRotatedChildren: [
        Align(
          alignment: watermarkAlignment,
          child: Opacity(
            opacity: .4,
            child: Container(
              margin: contentMargin,
              width: 32,
              height: 32,
              child: Image.asset('assets/images/lands_department.png'),
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
                Container(
                  height: 8,
                ),
                Obx(() => Button(
                      icon: Icon(
                        LineAwesomeIcons.layer_group,
                        color: controller.imagery.value
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                      invert: controller.imagery.value ? false : true,
                      onPressed: () {
                        controller.imagery.value = !controller.imagery.value;
                      },
                    )),
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
              } else {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  if (!controller.centerOnLocationUpdate.value) {
                    controller.centerOnLocationUpdate.value = true;
                  }
                });
              }
            }
          },
          zoom: zoom,
          maxZoom: 18,
          minZoom: 10,
          allowPanningOnScrollingParent: false,
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
        MarkerLayerOptions(
          markers: [
            if (finishMarker != null)
              Marker(
                width: 24,
                height: 24,
                point: finishMarker,
                builder: (ctx) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromARGB(255, 149, 65, 197),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(144, 153, 100, 184),
                              blurRadius: 8,
                              spreadRadius: 4)
                        ]),
                    child: Center(
                      child: Icon(Icons.flag_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
