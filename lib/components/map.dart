import 'dart:math' as Math;
import 'package:background_locator/location_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:get/get.dart';
import 'package:hikee/components/drag_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/utils/geo.dart';

class HikeeMap extends StatelessWidget {
  const HikeeMap(
      {Key? key,
      this.mapController,
      this.path,
      this.lock = false,
      this.zoom = 16,
      this.pathOnly = false,
      this.showMyLocation = false,
      this.centerOnLocationUpdate,
      this.onTap,
      this.markers,
      this.onMapCreated,
      this.interactiveFlag})
      : super(key: key);
  final MapController? mapController;
  final List<LatLng>? path;
  final bool lock;
  final double zoom;
  final bool pathOnly;
  final bool showMyLocation;
  final Rx<bool>? centerOnLocationUpdate;
  final Function(LatLng)? onTap;
  final List<DragMarker>? markers;
  final void Function(MapController)? onMapCreated;
  final int? interactiveFlag;

  @override
  Widget build(BuildContext context) {
    //if (path == null && target == null) {
    //  return Shimmer();
    //}
    var center = LatLng(22.302711, 114.177216);
    var bounds = LatLngBounds(LatLng(22.58, 114.51), LatLng(22.13, 113.76));
    if (path != null) {
      var _bounds = GeoUtils.getPathBounds(path!);
      if (pathOnly) bounds = _bounds;
      center = bounds.center;
    }
    LatLng? finishMarker;
    if ((markers != null && markers!.length > 1)) {
      finishMarker = markers!.last.point;
    }
    if (path != null) {
      if (path!.length > 1) {
        finishMarker = path!.last;
      }
    }
    return FlutterMap(
      options: MapOptions(
          interactiveFlags: interactiveFlag ?? InteractiveFlag.all,
          onTap: (_, pos) {
            if (this.onTap != null) {
              this.onTap!(pos);
            }
          },
          onMapCreated: (controller) {
            if (onMapCreated != null) onMapCreated!(controller);
            Future.microtask(() {
              if (pathOnly) {
                var r = controller.centerZoomFitBounds(bounds,
                    options: FitBoundsOptions(padding: EdgeInsets.all(64)));
                controller.move(r.center, r.zoom);
              }
            });
          },
          zoom: zoom,
          maxZoom: 18,
          minZoom: 10,
          allowPanning: !lock,
          allowPanningOnScrollingParent: false,
          enableScrollWheel: !lock,
          center: center,
          bounds: bounds,
          onPositionChanged: (MapPosition position, bool hasGesture) {
            if (hasGesture) {
              if (centerOnLocationUpdate != null) {
                centerOnLocationUpdate!.value = false;
              }
            }
          },
          plugins: [
            TappablePolylineMapPlugin(),
            if (showMyLocation && centerOnLocationUpdate != null)
              LocationMarkerPlugin(
                centerOnLocationUpdate: centerOnLocationUpdate!.value
                    ? CenterOnLocationUpdate.always
                    : CenterOnLocationUpdate.never,
              ),
            DragMarkerPlugin(),
          ]),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/basemap/WGS84/{z}/{x}/{y}.png",
          errorTileCallback: (_, __) {},
          evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
        ),
        TappablePolylineLayerOptions(
            polylineCulling: true,
            polylines: [
              if (path != null)
                TaggedPolyline(
                    tag: "Path",
                    gradientColors: [
                      Colors.amber.shade200,
                      Colors.orange.shade600,
                    ],
                    points: path!,
                    strokeWidth: 5.0,
                    color: Colors.amber.shade400.withOpacity(.5),
                    borderStrokeWidth: 2.0,
                    borderColor: Colors.deepOrange.shade900),
            ],
            onTap: (polylines, tapPosition) => print('Tapped: ' +
                polylines.map((polyline) => polyline.tag).join(',') +
                ' at ' +
                tapPosition.globalPosition.toString()),
            onMiss: (tapPosition) {
              print('No polyline was tapped at position ' +
                  tapPosition.globalPosition.toString());
            }),
        TileLayerOptions(
            urlTemplate:
                "https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/label/hk/en/WGS84/{z}/{x}/{y}.png",
            errorTileCallback: (_, __) {},
            evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
            backgroundColor: Colors.transparent),
        if (markers != null) DragMarkerPluginOptions(markers: markers!),
        MarkerLayerOptions(
          markers: [
            if (finishMarker != null)
              Marker(
                width: 25,
                height: 25,
                point: finishMarker,
                builder: (ctx) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepOrange.shade900,
                      ),
                      borderRadius: BorderRadius.circular(12.5),
                      color: Colors.orange.shade600,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.flag_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (showMyLocation) LocationMarkerLayerOptions(),
      ],
    );
  }
}
