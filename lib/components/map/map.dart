import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/map/drag_marker.dart';
import 'package:hikee/components/map/map_controller.dart';
import 'package:hikee/models/preferences.dart';
import 'package:hikee/providers/preferences.dart';
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
      this.onLongPress,
      this.markers,
      this.onMapCreated,
      this.interactiveFlag,
      this.watermarkAlignment = Alignment.bottomLeft,
      this.contentMargin = const EdgeInsets.all(8)})
      : super(key: key) {
    _key = key?.toString();
    controller = Get.put(HikeeMapController(), tag: key?.toString());
    if ((path == null || path?.length == 0) &&
        (userPath == null || userPath?.length == 0))
      controller.focusCurrentLocationOnce(positionStream);
  }

  final _preferencesProvider = Get.find<PreferencesProvider>();
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

  MapProvider? get mapProvider {
    return _preferencesProvider.preferences.value?.mapProvider;
  }

  String get urlTemplate {
    switch (mapProvider) {
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
    switch (mapProvider) {
      case null:
      case MapProvider.OpenStreetMap:
      case MapProvider.OpenStreetMapCyclOSM:
        return Container(
            margin: contentMargin,
            child: Text("© OpenStreetMap",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)));
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
    if (markers == null && path != null) {
      if (path!.length > 1) {
        finishMarker = path!.last;
      }
    }
    if (pathOnly && path != null) {
      if (path!.length > 1) finishMarker = path!.last;
    }
    return FlutterMap(
      key: Key(_key ?? '-flutter-map'),
      children: [
        Obx(() => TileLayerWidget(
            key: Key(mapProvider.toString()),
            options: TileLayerOptions(
              urlTemplate: urlTemplate,
              subdomains: ['a', 'b', 'c'],
              errorTileCallback: (_, __) {},
              evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
              backgroundColor: Colors.transparent,
              attributionAlignment: Alignment.bottomLeft,
              attributionBuilder: mapProvider == MapProvider.LandsDepartment
                  ? null
                  : (_) {
                      return providerAttribution;
                    },
            ))),
        Obx(() => mapProvider == MapProvider.LandsDepartment
            ? TileLayerWidget(
                options: TileLayerOptions(
                    urlTemplate:
                        "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/label/hk/en/WGS84/{z}/{x}/{y}.png",
                    attributionAlignment: Alignment.bottomLeft,
                    attributionBuilder: (_) {
                      return providerAttribution;
                    },
                    errorTileCallback: (_, __) {},
                    evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
                    backgroundColor: Colors.transparent),
              )
            : SizedBox()),
        PolylineLayerWidget(
          options: PolylineLayerOptions(
            polylineCulling: false,
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
                Obx(() => mapProvider == MapProvider.LandsDepartment
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
