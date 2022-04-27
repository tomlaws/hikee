import 'dart:async';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart' hide TextInput;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/dropdown.dart';
import 'package:hikees/components/core/futurer.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/components/map/drag_marker.dart';
import 'package:hikees/components/map/map_controller.dart';
import 'package:hikees/components/map/tooltip_shape_border.dart';
import 'package:hikees/data/distance_posts/reader.dart';
import 'package:hikees/models/facility.dart';
import 'package:hikees/models/map_marker.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/models/region.dart';
import 'package:hikees/providers/active_trail.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/providers/geodata.dart';
import 'package:hikees/providers/offline.dart';
import 'package:hikees/providers/record.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/time.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikees/components/compass/sliding_up_panel.dart';
import 'package:hikees/models/active_trail.dart';
import 'package:hikees/models/distance_post.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class CompassController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _authProvider = Get.find<AuthProvider>();
  final activeTrailProvider = Get.find<ActiveTrailProvider>();
  final _offlineProvider = Get.find<OfflineProvider>();
  final _geodataProvider = Get.put(GeodataProvider());
  final _recordProvider = Get.put(RecordProvider());
  final panelController = PanelController();
  final panelPageController = PageController(
    initialPage: 0,
  );
  HikeeMapController? mapController;

  // UI
  final double collapsedPanelHeight = kBottomNavigationBarHeight;
  final panelPosition = 0.0.obs;
  final panelPage = 0.0.obs;
  final double maxPanelHeight = 320.0;
  final double panelHeaderHeight = 60;
  final lockPosition = false.obs;
  final nearbyFacilities = Rxn<List<Facility>>();
  final markers = Rx<List<DragMarker>>([]);

  // tooltip
  late AnimationController tooltipController;
  late Animation<int> alpha;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    panelPageController.addListener(() {
      panelPage.value = panelPageController.page ?? 0;
    });

    tooltipController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    Animation<double> curve =
        CurvedAnimation(parent: tooltipController, curve: Curves.easeInOutSine);
    alpha = IntTween(begin: 0, end: 15).animate(curve);
    tooltipController.repeat(reverse: true);
  }

  @override
  void onClose() {
    panelPageController.dispose();
    tooltipController.dispose();
    super.onClose();
  }

  RxBool get isCloseToStart {
    return activeTrailProvider.isCloseToStart;
  }

  RxBool get isCloseToGoal {
    return activeTrailProvider.isCloseToGoal;
  }

  Rxn<ActiveTrail> get activeTrail {
    return activeTrailProvider.activeTrail;
  }

  Rxn<LocationMarkerPosition> get currentLocation {
    return activeTrailProvider.currentLocation;
  }

  List<LatLng>? get userPath {
    return activeTrailProvider.activeTrail.value?.userPath;
  }

  // m per hour
  int? get speed {
    return activeTrailProvider.activeTrail.value?.speed;
  }

  int? get estimatedFinishTime {
    return activeTrailProvider.activeTrail.value?.estimatedFinishTime;
  }

  int get activeTrailLength {
    if (activeTrail.value?.referenceTrailId == null) {
      return activeTrail.value?.length ?? 0;
    }
    return (activeTrail.value?.originalLength ?? 0);
  }

  int get activeTrailDuration {
    return activeTrail.value?.originalDuration ??
        ((activeTrail.value?.elapsed ?? 0.0) / 60).round();
  }

  List<DragMarker> mapMarkers(
      Widget startMarkerContent, Widget endMarkerContent) {
    List<DragMarker> result = [];
    if (activeTrail.value == null) return result;
    result.addAll(activeTrail.value!.markers.mapIndexed(
      (i, e) => DragMarker(
        draggable: false,
        point: e.locationInLatLng,
        width: 24,
        height: 24 + 8,
        anchorPos: AnchorPos.align(AnchorAlign.top),
        builder: (_, color) {
          return Container(
            decoration: ShapeDecoration(
              color: e.color,
              shape: TooltipShapeBorder(),
            ),
            child: Icon(
              Icons.star,
              size: 16,
              color: Colors.white,
            ),
          );
        },
        onTap: (_) {
          DialogUtils.showActionDialog(
              e.title,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentLocation.value != null)
                      Obx(() => Futurer(
                            future: GeoUtils.calculateLengthAndDuration([
                              currentLocation.value!.latLng,
                              e.locationInLatLng
                            ]),
                            builder: (Tuple2<int, int> data) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'distance'.tr,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      if (currentLocation.value != null)
                                        Text(
                                          '~' +
                                              GeoUtils.formatMetres(data.item1),
                                          style: TextStyle(fontSize: 14),
                                        )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'estimatedTime'.tr,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        TimeUtils.formatMinutes(data.item2),
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            placeholder: SizedBox(),
                          )),
                    if (e.message != null) ...[
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'message'.tr,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        e.message!,
                        maxLines: 10,
                      )
                    ]
                  ],
                ),
              ),
              mutate: false,
              cancelText: 'remove'.tr, onCancel: () {
            activeTrail.update((t) {
              t?.markers.removeAt(i);
            });
            Get.back();
          });
        },
      ),
    ));
    return result;
  }

  void addMarker(
      {required LatLng location,
      required String title,
      String? message,
      Color color = const Color.fromARGB(255, 64, 66, 196)}) {
    if (message != null && message.length == 0) {
      message = null;
    }
    activeTrail.update((t) {
      t?.markers.add(MapMarker(
          locationInLatLng: location,
          title: title,
          message: message,
          color: color));
    });
  }

  void promptAddMarker(LatLng location) {
    final formkey = GlobalKey<FormState>();
    var title = '';
    var message = '';
    DialogUtils.showActionDialog(
        'addMarker'.tr,
        Form(
          key: formkey,
          child: Column(
            children: [
              TextInput(
                label: 'title'.tr,
                hintText: 'title'.tr,
                onSaved: (v) => title = v ?? '',
                validator: (v) {
                  if (v == null || v.length == 0) {
                    return 'fieldCannotBeEmpty'.trArgs(['title'.tr]);
                  }
                  if (v.length > 50) {
                    return 'fieldTooLong'.trArgs(['title'.tr]);
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextInput(
                label: 'message'.tr,
                hintText: 'message'.tr,
                onSaved: (v) => message = v ?? '',
                maxLines: 5,
                validator: (v) {
                  if (v != null && v.length > 500) {
                    return 'fieldTooLong'.trArgs(['message'.tr]);
                  }
                  return null;
                },
              )
            ],
          ),
        ), onOk: () {
      if (formkey.currentState?.validate() == true) {
        formkey.currentState?.save();
        addMarker(
            location: location,
            title: title,
            message: message,
            color: Colors.indigo);
        return true;
      } else {
        throw new Error();
      }
    });
  }

  void record() {
    activeTrailProvider.record();
  }

  Future<void> showDistancePost(DistancePost dp) async {
    try {
      lockPosition.value = false;
      addMarker(
          location: dp.location, title: dp.trail_name_en, color: Colors.red);
      mapController?.mapController?.move(dp.location, 17);
    } catch (e) {
      print(e);
    }
  }

  final formkey = GlobalKey<FormState>();
  Future<bool> customizeRecord() async {
    String? trailName = activeTrail.value!.name ?? activeTrail.value!.name;
    int? regionId = activeTrail.value!.regionId ??
        activeTrail.value!.regionId ??
        GeoUtils.determineRegion(activeTrail.value!.userPath)?.id;
    var regions = Region.allRegions().toList();
    var result = await DialogUtils.showActionDialog(
        "record".tr,
        Form(
            key: formkey,
            child: Column(
              children: [
                TextInput(
                  label: 'recordName'.tr,
                  hintText: 'recordName'.tr,
                  initialValue: trailName,
                  onSaved: (v) {
                    trailName = v;
                  },
                  validator: (v) {
                    if (v == null || v.length == 0) {
                      return 'fieldCannotBeEmpty'.trArgs(['recordName'.tr]);
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DropdownField<Region>(
                    label: 'region'.tr,
                    items: regions,
                    selected: regions
                        .firstWhereOrNull((element) => element.id == regionId),
                    itemBuilder: (r) {
                      return Text(r.name);
                    },
                    onSaved: (v) {
                      regionId = v!.id;
                    },
                    validator: (v) {
                      if (v == null) {
                        return 'fieldCannotBeEmpty'.trArgs(['region'.tr]);
                      }
                      return null;
                    },
                  ),
                )
              ],
            )), onOk: () {
      if (formkey.currentState?.validate() == true && regionId != null) {
        formkey.currentState?.save();
        return true;
      } else {
        throw new Error();
      }
    });
    if (result != null) {
      activeTrail.update((t) {
        t?.name = trailName;
        t?.regionId = regionId;
      });
      return true;
    } else {
      return false;
    }
  }

  finishTrail() async {
    try {
      int? trailId;
      int elapsed = activeTrail.value!.elapsed;
      int startTime = activeTrail.value!.startTime!;
      int distance = activeTrail.value!.length;
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(startTime); // local use only
      int? regionId = activeTrail.value!.regionId ??
          GeoUtils.determineRegion(activeTrail.value!.userPath)!.id;
      String? recordName = activeTrail.value!.name;
      if (recordName == null || regionId == null) {
        bool result = await customizeRecord();
        if (!result) return;
        recordName = activeTrail.value!.name!;
        regionId = activeTrail.value!.regionId!;
      }

      // Store to device first
      int offlineRecordId = await _offlineProvider.createOfflineRecord(
          date: date,
          time: elapsed,
          name: recordName,
          referenceTrailId: trailId,
          regionId: regionId,
          userPath: userPath!);
      Record? record;
      if (_authProvider.loggedIn.value) {
        record = await _recordProvider.createRecord(
            time: elapsed,
            name: recordName,
            referenceTrailId: trailId,
            regionId: regionId,
            userPath: userPath!);
        _offlineProvider.deleteOfflineRecord(offlineRecordId);
      }
      DialogUtils.showSimpleDialog(
          "congratulations".tr,
          Column(
            children: [
              Text("youveCompletedTheTrail".tr),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Icon(
                      LineAwesomeIcons.award,
                      size: 48,
                      color: Colors.amber[700],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            recordName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('startTime'.tr),
                        Text(DateFormat('yyyy-MM-dd HH:mm')
                            .format(record?.date.toLocal() ?? date))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('timeUsed'.tr),
                        Text(TimeUtils.formatSeconds(elapsed))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('distance'.tr),
                        Text(
                          GeoUtils.formatMetres(distance),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )
            ],
          ));
    } catch (ex) {
      throw ex;
    }
    activeTrailProvider.quit();
    panelController.close();
  }

  void googleMapDir() {
    if (currentLocation.value == null) return;
    var origin =
        '${currentLocation.value!.latitude.toString()},${currentLocation.value!.longitude.toString()}';
    var destination =
        '${activeTrail.value!.originalPath!.first.latitude.toString()},${activeTrail.value!.originalPath!.first.longitude.toString()}';
    launch(
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=transit');
  }

  Future<void> discoverNearbyFacilities() async {
    if (currentLocation.value == null) {
      nearbyFacilities.value = [];
      return;
    }
    nearbyFacilities.value = await _geodataProvider
        .getNearbyFacilities(currentLocation.value!.latLng);
  }

  Future<void> emergency() async {
    LatLng? location = currentLocation.value?.latLng;

    DialogUtils.showActionDialog(
        "emergency".tr,
        FutureBuilder<DistancePost?>(
          future: location == null
              ? Future.value(null)
              : DistancePostsReader.findClosestDistancePost(location),
          builder: (_, snapshot) {
            var nearestDistancePost = snapshot.data;
            if (snapshot.connectionState != ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            int dist = 999;
            if (location != null && nearestDistancePost != null) {
              dist = GeoUtils.calculateDistance(
                  nearestDistancePost.location, location);

              if (dist > 1500) {
                nearestDistancePost = null;
              }
            }
            return Column(
              children: [
                if (nearestDistancePost != null) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      children: [
                        Text(nearestDistancePost.trail_name_en),
                        Text(nearestDistancePost.trail_name_zh),
                        Text(nearestDistancePost.no,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 6,
                        ),
                        Button(
                            child: Text('showInMap'.tr),
                            onPressed: () {
                              showDistancePost(nearestDistancePost!);
                              Get.back();
                            }),
                      ],
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  SizedBox(
                    width: 300,
                    child: Opacity(
                      opacity: .75,
                      child: Text(
                        'youAreAwayFromThisDistancePost'
                                .trArgs([GeoUtils.formatMetres(dist)]) +
                            " " +
                            'thisMayHelpTheRescueTeamToLocateYou'.tr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ]
              ],
            );
          },
        ),
        okText: 'dial'.tr + ' 112', onOk: () {
      launchUrl(Uri.parse("tel://112"));
    }, critical: true);
  }

  Future<void> shareLiveLocation() async {
    if (!activeTrailProvider.hasLive) {
      const availableDuration = [1, 2, 4, 8, 12];
      int hours = 4;
      await DialogUtils.showActionDialog(
          'shareLiveLocation'.tr,
          Column(
            children: [
              DropdownField<int>(
                label: 'expiresIn'.tr,
                itemBuilder: (v) {
                  return Text(v.toString() + ' ' + 'hours'.tr);
                },
                items: availableDuration,
                selected: hours,
                onChange: (v) => hours = v,
              ),
            ],
          ),
          mutate: true,
          okText: 'ok'.tr, onOk: () async {
        await activeTrailProvider.createLive(hours: hours);
      });
    }
    if (activeTrailProvider.hasLive) {
      int id = activeTrailProvider.activeTrail.value!.live!.id!;
      String secret = activeTrailProvider.activeTrail.value!.live!.secret!;
      var url = 'https://www.hikees.com/live/$id?secret=$secret';
      await DialogUtils.showActionDialog(
          'shareLiveLocation'.tr,
          Column(
            children: [
              Text(
                'shareYouLiveLocation'.tr,
                style: TextStyle(color: Colors.black38),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextInput(
                      initialValue: url,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    height: 44,
                    child: Button(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: url));
                        },
                        child: Text('copy'.tr)),
                  )
                ],
              )
            ],
          ),
          critical: true,
          okText: 'stopSharing'.tr, onOk: () async {
        await DialogUtils.showActionDialog(
            'warning'.tr, Text('stopSharingWarning'.tr), critical: true,
            onOk: () {
          return activeTrailProvider.deleteLive();
        }, okText: 'yes'.tr);
      });
    }
  }
}
