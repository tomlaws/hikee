import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide TextInput;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/dropdown.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/components/map/drag_marker.dart';
import 'package:hikees/components/map/map.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/models/region.dart';
import 'package:hikees/models/trail.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/pages/trails/create/create_trail_controller.dart';
import 'package:hikees/utils/geo.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CreateTrailPage extends GetView<CreateTrailController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var body = _step0();
      switch (controller.step.value) {
        case 0:
          body = _step0();
          break;
        case 1:
          body = _step1();
          break;
        default:
          body = _step0();
      }
      List<Widget> actions = [];
      if (controller.step.value == 0 &&
          controller.selectedCoordinates.value != null) {
        if (controller.selectedCoordinates.value?.message == null)
          actions.add(Button(
              invert: true,
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.add_comment_rounded),
              onPressed: () {
                controller.editMessage(controller.selectedCoordinates.value);
              }));
        actions.add(Button(
            invert: true,
            icon: Icon(Icons.delete_rounded),
            onPressed: () {
              controller.removeLocation();
            }));
      }
      return Scaffold(
          appBar: HikeeAppBar(title: Text("createTrail".tr), actions: actions),
          body: body);
    });
  }

  Widget _step1() {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  height: 240,
                  decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(24)),
                  child: controller.images.length == 0
                      ? Button(
                          child: Text('uploadImage'.tr),
                          onPressed: () {
                            controller.pickImages();
                          },
                          backgroundColor: Colors.transparent,
                          secondary: true)
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding:
                              EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: Wrap(
                            spacing: 16,
                            children: [
                              ...controller.images
                                  .map((image) => Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: 240,
                                            height: 240 - 16 * 2,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Image.memory(image,
                                                fit: BoxFit.cover),
                                          ),
                                          Positioned(
                                              top: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.removeImage(image);
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black87,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                topRight: Radius
                                                                    .circular(
                                                                        16),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            8),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8))),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 18,
                                                    )),
                                              )),
                                        ],
                                      ))
                                  .toList(),
                              Container(
                                width: 240,
                                height: 240 - 16 * 2,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Button(
                                    child: Text('uploadImage'.tr),
                                    onPressed: () {
                                      controller.pickImages();
                                    },
                                    backgroundColor: Colors.transparent,
                                    secondary: true),
                              ),
                            ],
                          ))),
              Container(
                  height: 240,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(24)),
                  child: HikeeMap(
                    key: Key('create-trail-map-2'),
                    pathOnly: true,
                    path:
                        controller.coordinates.map((c) => c.location).toList(),
                    interactiveFlag: InteractiveFlag.none,
                    markers: _dragMarkers,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextInput(
                  label: 'trailName'.tr,
                  hintText: 'trailName'.tr,
                  controller: controller.nameController,
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextInput(
                          label: 'duration'.tr,
                          hintText: 'minutes'.tr,
                          controller: controller.durationController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Dropdown<Region>(
                            label: 'region'.tr,
                            items: Region.allRegions().toList(),
                            selected: controller.region.value,
                            itemBuilder: (r) {
                              return Text(r.name);
                            },
                            onChanged: (r) {
                              controller.region.value = r;
                            },
                          )),
                    ],
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                child: Text('difficulty'.tr,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: RatingBar.builder(
                  glow: false,
                  initialRating: 0,
                  itemSize: 20,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: EdgeInsets.only(right: 8.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (difficulty) {
                    controller.difficulty = difficulty.truncate();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 160,
                  child: TextInput(
                      label: 'description'.tr,
                      expand: true,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      hintText: 'description'.tr,
                      controller: controller.descriptionController),
                ),
              ),
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                blurRadius: 16,
                spreadRadius: -8,
                color: Colors.black.withOpacity(.09),
                offset: Offset(0, -6))
          ]),
          child: SafeArea(
            child: Row(
              children: [
                Button(
                  secondary: true,
                  onPressed: () {
                    controller.step.value = 0;
                  },
                  icon: Icon(Icons.chevron_left, color: Colors.white),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: MutationBuilder<Trail>(
                    userOnly: true,
                    builder: (mutate, loading) => Button(
                      loading: loading,
                      onPressed: () {
                        mutate();
                      },
                      child: Text('publish'.tr),
                    ),
                    onDone: (Trail? trail) {
                      if (trail != null) {
                        Get.back();
                        Get.toNamed('/trails/${trail.id}');
                      }
                    },
                    onError: (err) {},
                    mutation: () async {
                      return controller.create();
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _step0() {
    return Stack(children: [
      Positioned.fill(child: _map()),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26), topRight: Radius.circular(26)),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        LineAwesomeIcons.walking,
                        size: 24,
                      ),
                      Container(width: 4),
                      Text(
                          "${GeoUtils.formatDistance(GeoUtils.getPathLength(path: controller.coordinates.map((c) => c.location).toList()))}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Button(
                      child: Text(
                        'next'.tr,
                      ),
                      disabled: controller.coordinates.length < 2,
                      onPressed: () {
                        if (controller.coordinates.length >= 2) {
                          controller.selectedCoordinates.value = null;
                          controller.step.value = 1;
                        }
                      })
                ],
              ),
            ),
          ))
    ]);
  }

  List<DragMarker> _dragMarkers(
      Widget startMarkerContent, Widget endMarkerContent) {
    return controller.coordinates
        .map(
          (pos) => DragMarker(
            point: pos.location,
            draggable: controller.step.value == 0,
            width: pos == controller.coordinates.last ||
                    pos == controller.coordinates.first
                ? 20 + 8
                : 16 + 8,
            height: pos == controller.coordinates.last ||
                    pos == controller.coordinates.first
                ? 20 + 8
                : 16 + 8,
            hasPopup: pos.message != null,
            onPopupTap: controller.step.value == 0
                ? () {
                    controller.editMessage(pos);
                  }
                : null,
            builder: (_, color) {
              return Container(
                padding: EdgeInsets.all(
                    controller.selectedCoordinates.value == pos ? 0.0 : 4.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          width: controller.selectedCoordinates.value == pos
                              ? 2.5
                              : 1.25,
                          color: Colors.white)),
                  child: pos == controller.coordinates.first
                      ? startMarkerContent
                      : pos == controller.coordinates.last
                          ? endMarkerContent
                          : null,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            },
            onTap: controller.step.value == 0
                ? (LatLng latlng) {
                    controller.selectedCoordinates.value = pos;
                    controller.coordinates.refresh();
                  }
                : null,
            onDragUpdate: controller.step.value == 0
                ? (_, position) {
                    pos.location.latitude = position.latitude;
                    pos.location.longitude = position.longitude;
                    controller.coordinates.refresh();
                  }
                : null,
            onDragEnd: controller.step.value == 0
                ? (_, position) {
                    pos.location.latitude = position.latitude;
                    pos.location.longitude = position.longitude;
                    controller.coordinates.refresh();
                  }
                : null,
          ),
        )
        .toList();
  }

  Widget _map() {
    double startMarkerAngle = 0.0;
    if (controller.coordinates.length > 1) {
      var prevPt = controller.coordinates.elementAt(0);
      var pt = controller.coordinates.elementAt(1);
      var startLat = prevPt.location.latitude * pi / 180;
      var startLng = prevPt.location.longitude * pi / 180;
      var destLat = pt.location.latitude * pi / 180;
      var destLng = pt.location.longitude * pi / 180;
      var y = sin(destLng - startLng) * cos(destLat);
      var x = cos(startLat) * sin(destLat) -
          sin(startLat) * cos(destLat) * cos(destLng - startLng);
      double theta = atan2(y, x);
      startMarkerAngle = theta;
    }
    return HikeeMap(
      key: Key('create-trail-map'),
      zoom: 10,
      contentMargin: EdgeInsets.only(
          bottom: 80 + WidgetsBinding.instance!.window.viewPadding.bottom - 16,
          right: 8,
          left: 8),
      markers: _dragMarkers,
      defaultMarkers: false,
      path: controller.coordinates.map((c) => c.location).toList(),
      onTap: (LatLng l) {
        controller.addLocation(l);
      },
    );
  }
}
