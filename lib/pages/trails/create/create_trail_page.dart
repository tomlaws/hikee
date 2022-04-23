import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/dropdown.dart';
import 'package:hikees/components/core/futurer.dart';
import 'package:hikees/components/core/rating_input.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/components/map/drag_marker.dart';
import 'package:hikees/components/map/map.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/components/map/tooltip_shape_border.dart';
import 'package:hikees/models/region.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/time.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/pages/trails/create/create_trail_controller.dart';
import 'package:hikees/utils/geo.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

class CreateTrailPage extends GetView<CreateTrailController> {
  final formkey = GlobalKey<FormState>();
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
        if (controller.markers.firstWhereOrNull((e) =>
                e.locationInLatLng == controller.selectedCoordinates.value) ==
            null)
          actions.add(Button(
              invert: true,
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.add_comment_rounded),
              onPressed: () {
                controller
                    .promptAddMarker(controller.selectedCoordinates.value!);
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
    return Form(
      key: formkey,
      child: Column(
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
                                                      BorderRadius.circular(
                                                          16)),
                                              child: Image.memory(image,
                                                  fit: BoxFit.cover),
                                            ),
                                            Positioned(
                                                top: -4,
                                                right: -4,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .removeImage(image);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black87,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0)),
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
                      path: controller.coordinates,
                      interactiveFlag: InteractiveFlag.none,
                      markers: _dragMarkers,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextInput(
                    label: 'trailName'.tr,
                    hintText: 'trailName'.tr,
                    controller: controller.nameController,
                    validator: (v) {
                      if (v == null || v.length == 0) {
                        return 'fieldCannotBeEmpty'
                            .trParams({'field': 'recordName'.tr});
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownField<Region>(
                      label: 'region'.tr,
                      items: Region.allRegions().toList(),
                      selected:
                          GeoUtils.determineRegion(controller.coordinates),
                      itemBuilder: (r) {
                        return Text(r.name);
                      },
                      validator: (v) {
                        if (v == null) {
                          return 'fieldCannotBeEmpty'
                              .trParams({'field': 'region'.tr});
                        }
                        return null;
                      },
                      onSaved: (r) {
                        controller.region.value = r;
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: RatingInput(
                    label: 'difficulty'.tr,
                    onSaved: (v) {
                      controller.difficulty = v!;
                    },
                    invalidRatingMessage: 'fieldCannotBeEmpty'
                        .trParams({'field': 'difficulty'.tr}),
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
                          if (formkey.currentState?.validate() == true) {
                            formkey.currentState?.save();
                            mutate();
                          } else {
                            throw new Error();
                          }
                        },
                        child: Text('publish'.tr),
                      ),
                      onDone: (Trail? trail) {
                        if (trail != null) {
                          Get.back();
                          Get.toNamed('/trails/${trail.id}');
                        }
                      },
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
      ),
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
                      Futurer(
                          future: controller.lengthAndDuration,
                          placeholder: Shimmer(
                            fontSize: 18,
                            width: 56,
                          ),
                          builder: (Tuple2 data) => Text(
                                GeoUtils.formatMetres(data.item1),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              )),
                      Container(width: 8),
                      Icon(
                        LineAwesomeIcons.clock,
                        size: 24,
                      ),
                      Container(width: 4),
                      Futurer(
                          future: controller.lengthAndDuration,
                          placeholder: Shimmer(
                            fontSize: 18,
                            width: 56,
                          ),
                          builder: (Tuple2 data) => Text(
                                TimeUtils.formatMinutes(data.item2),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ))
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
    List<DragMarker> markers = controller.coordinates
        .map(
          (pos) => DragMarker(
            point: pos,
            draggable: controller.step.value == 0,
            width: pos == controller.coordinates.last ||
                    pos == controller.coordinates.first
                ? 20 + 8
                : 16 + 8,
            height: pos == controller.coordinates.last ||
                    pos == controller.coordinates.first
                ? 20 + 8
                : 16 + 8,
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
                    pos.latitude = position.latitude;
                    pos.longitude = position.longitude;
                    controller.coordinates.refresh();
                  }
                : null,
            onDragEnd: controller.step.value == 0
                ? (_, position) {
                    pos.latitude = position.latitude;
                    pos.longitude = position.longitude;
                    controller.coordinates.refresh();
                  }
                : null,
          ),
        )
        .toList();
    List<DragMarker> customMarkers = controller.markers
        .map((e) => DragMarker(
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
                          if (e.message != null) ...[
                            Text(
                              'message'.tr,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
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
                  controller.markers.remove(e);
                  Get.back();
                });
              },
            ))
        .toList();
    return [...markers, ...customMarkers];
  }

  Widget _map() {
    return Obx(() {
      // do not remove this line
      var m = controller.markers.length;
      return HikeeMap(
        key: Key('create-trail-map'),
        zoom: 10,
        contentMargin: EdgeInsets.only(
            bottom: 88 + WidgetsBinding.instance!.window.viewPadding.bottom,
            right: 8,
            left: 8),
        markers: _dragMarkers,
        defaultMarkers: false,
        path: controller.coordinates,
        onTap: (LatLng l) {
          if (hkBounds.contains(l)) controller.addLocation(l);
        },
        onLongPress: (location) {
          controller.promptAddMarker(location);
        },
      );
    });
  }
}
