import 'dart:async';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/dropdown.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/map/drag_marker.dart';
import 'package:hikee/components/map/map_controller.dart';
import 'package:hikee/models/facility.dart';
import 'package:hikee/models/map_marker.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/models/region.dart';
import 'package:hikee/providers/active_trail.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/geodata.dart';
import 'package:hikee/providers/record.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/time.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/components/compass/sliding_up_panel.dart';
import 'package:hikee/models/active_trail.dart';
import 'package:hikee/models/distance_post.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CompassController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _authProvider = Get.find<AuthProvider>();
  final activeTrailProvider = Get.find<ActiveTrailProvider>();
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
  final nearestDistancePost = Rxn<DistancePost>();
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
    _timer?.cancel();
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

  Rxn<LocationMarkerHeading> get currentHeading {
    return activeTrailProvider.currentHeading;
  }

  Rxn<LocationMarkerPosition> get currentLocation {
    return activeTrailProvider.currentLocation;
  }

  List<LatLng>? get userPath {
    return activeTrailProvider.activeTrail.value?.userPath;
  }

  // km per hour
  double? get speed {
    return activeTrailProvider.activeTrail.value?.speed;
  }

  int? get estimatedFinishTime {
    return activeTrailProvider.activeTrail.value?.estimatedFinishTime;
  }

  List<DragMarker> get mapMarkers {
    List<DragMarker> result = [];
    if (activeTrail.value == null) return result;
    if (activeTrail.value!.trail?.pins != null) {
      result.addAll(activeTrail.value!.trail!.pins!.map(
        (pos) => DragMarker(
          draggable: false,
          point: pos.location,
          width: 10,
          height: 10,
          hasPopup: pos.message != null,
          onTap: (_) {
            DialogUtils.showDialog("Message", pos.message!);
          },
        ),
      ));
    }
    result.addAll(activeTrail.value!.markers.mapIndexed(
      (i, e) => DragMarker(
        draggable: false,
        point: e.location,
        width: 10,
        height: 10,
        hasPopup: true,
        popupColor: e.color,
        popupIcon: Icons.star,
        onTap: (_) {
          DialogUtils.showActionDialog(
              e.title,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Distance',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              if (currentLocation.value != null)
                                Obx(() => Text(
                                      '~' +
                                          GeoUtils.formatDistance(
                                              GeoUtils.calculateDistance(
                                                  currentLocation.value!.latLng,
                                                  e.location)),
                                      style: TextStyle(fontSize: 14),
                                    ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimated Time',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Obx(() => Text(
                                    speed == null || speed! == 0
                                        ? 'N/A'
                                        : '~' +
                                            TimeUtils.formatMinutes(
                                                (GeoUtils.calculateDistance(
                                                            currentLocation
                                                                .value!.latLng,
                                                            e.location) /
                                                        (speed! / 60))
                                                    .round()),
                                    style: TextStyle(fontSize: 14),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (e.message != null) ...[
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Message',
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
              cancelText: 'Remove', onCancel: () {
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
          location: location, title: title, message: message, color: color));
    });
  }

  void promptAddMarker(LatLng location) {
    final formkey = GlobalKey<FormState>();
    var title = '';
    var message = '';
    DialogUtils.showActionDialog(
        'Add Marker',
        Form(
          key: formkey,
          child: Column(
            children: [
              TextInput(
                label: 'Title',
                hintText: 'Title of the marker',
                onSaved: (v) => title = v ?? '',
                validator: (v) {
                  if (v == null || v.length == 0) {
                    return 'Cannot be empty';
                  }
                  if (v.length > 50) {
                    return 'Title length exceeded the limit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextInput(
                label: 'Message',
                hintText: 'Put some message here...',
                onSaved: (v) => message = v ?? '',
                maxLines: 5,
                validator: (v) {
                  if (v != null && v.length > 500) {
                    return 'Title length exceeded the limit';
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
      nearestDistancePost.value = dp;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> customizeRecord() async {
    String? trailName =
        activeTrail.value!.name ?? activeTrail.value!.trail?.name_en;
    int? regionId = activeTrail.value!.regionId ??
        activeTrail.value!.trail?.regionId ??
        GeoUtils.determineRegion(activeTrail.value!.userPath)?.id;
    final formkey = GlobalKey<FormState>();
    var regions = Region.allRegions().toList();
    var result = await DialogUtils.showActionDialog(
        "Record",
        Form(
            key: formkey,
            child: Column(
              children: [
                TextInput(
                  label: 'Record Name',
                  hintText: 'Give this record a name',
                  initialValue: trailName,
                  onSaved: (v) {
                    trailName = v;
                  },
                  validator: (v) {
                    if (v == null || v.length == 0) {
                      return "Record name cannot be empty";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Dropdown<Region>(
                    label: 'Region',
                    items: regions,
                    selected: regions
                        .firstWhereOrNull((element) => element.id == regionId),
                    itemBuilder: (r) {
                      return Text(r.name_en);
                    },
                    onChanged: (r) {
                      regionId = r.id;
                    },
                  ),
                )
              ],
            )), onOk: () {
      if (formkey.currentState?.validate() == true && regionId != null) {
        formkey.currentState?.save();
        return true;
      } else {
        return false;
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
      if (_authProvider.loggedIn.value) {
        int? trailId;
        int elapsed = activeTrail.value!.elapsed;
        int startTime = activeTrail.value!.startTime!;
        List<double> altitudes = activeTrail.value!.userElevation;
        double distance = activeTrail.value!.length;
        DateTime date = DateTime.fromMillisecondsSinceEpoch(startTime);
        late int regionId;
        String? recordName;
        if (activeTrailProvider.recordMode) {
          recordName = activeTrail.value!.name;
          regionId = activeTrail.value!.regionId =
              GeoUtils.determineRegion(activeTrail.value!.userPath)!.id;
          if (recordName == null) {
            bool result = await customizeRecord();
            if (!result) return;
            recordName = activeTrail.value!.name;
            regionId = activeTrail.value!.regionId!;
          }
        } else {
          //upload stats
          trailId = activeTrail.value!.trail!.id;
          recordName = activeTrail.value!.trail!.name_en;
          regionId = activeTrail.value!.trail!.regionId;
        }
        Record record = await _recordProvider.createRecord(
            date: date,
            time: elapsed,
            name: recordName!,
            referenceTrailId: trailId,
            regionId: regionId,
            length: (GeoUtils.getPathLength(path: userPath) * 1000).truncate(),
            userPath: userPath!,
            altitudes: altitudes);
        DialogUtils.showDialog(
            "Congratulations",
            Column(
              children: [
                Text("You've completed the trail!"),
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
                        children: [
                          Text('Start Time'),
                          Text(DateFormat('yyyy-MM-dd HH:mm').format(date))
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Time Used'),
                          Text(TimeUtils.formatSeconds(elapsed))
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Distance'),
                          Text(
                            '${(distance / 1000).toString()}km',
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
      }
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
        '${activeTrail.value!.trail!.path!.first.latitude.toString()},${activeTrail.value!.trail!.path!.first.longitude.toString()}';
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
}
