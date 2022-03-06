import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide TextInput;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/dropdown.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/map/drag_marker.dart';
import 'package:hikee/components/map/map.dart';
import 'package:hikee/components/core/mutation_builder.dart';
import 'package:hikee/models/region.dart';
import 'package:hikee/models/trail.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/pages/trails/create/create_trail_controller.dart';
import 'package:hikee/utils/geo.dart';
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
              secondary: true,
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.add_comment_rounded),
              onPressed: () {
                controller.addMessage();
              }));
        actions.add(Button(
            secondary: true,
            backgroundColor: Colors.transparent,
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
                    markers: controller.coordinates
                        .map(
                          (pos) => DragMarker(
                            draggable: false,
                            point: pos.location,
                            width: 10,
                            height: 10,
                            hasPopup: pos.message != null,
                            builder: (_) {
                              return Container(
                                decoration: BoxDecoration(
                                    color:
                                        controller.selectedCoordinates.value ==
                                                pos
                                            ? Colors.orange
                                            : Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.deepOrange.shade900)),
                              );
                            },
                          ),
                        )
                        .toList(),
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
        )
      ],
    );
  }

  Widget _step0() {
    return Obx(() {
      var coordinates = controller.coordinates;
      return Stack(children: [
        Positioned.fill(child: _map()),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: kBottomNavigationBarHeight + 16,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26)),
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
                            controller.step.value = 1;
                          }
                        })
                  ],
                ),
              ),
            ))
      ]);
    });
  }

  Widget _map() {
    return HikeeMap(
      key: Key('create-trail-map'),
      zoom: 10,
      contentMargin: EdgeInsets.only(bottom: 80, right: 8),
      markers: controller.coordinates
          .map(
            (pos) => DragMarker(
              point: pos.location,
              width: pos == controller.coordinates.last ? 25 : 10,
              height: pos == controller.coordinates.last ? 25 : 10,
              hasPopup: pos.message != null,
              onPopupTap: () {
                controller.editMessage(pos);
              },
              builder: (_) {
                if (pos == controller.coordinates.last)
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12.5),
                        color: Color.fromARGB(255, 149, 65, 197)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.flag_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  );
                return Container(
                  decoration: BoxDecoration(
                      color: controller.selectedCoordinates.value == pos
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 2, color: Colors.white)),
                );
              },
              onTap: (LatLng latlng) {
                controller.selectedCoordinates.value = pos;
                controller.coordinates.refresh();
              },
              onDragUpdate: (_, position) {
                pos.location.latitude = position.latitude;
                pos.location.longitude = position.longitude;
                controller.coordinates.refresh();
              },
              onDragEnd: (_, position) {
                pos.location.latitude = position.latitude;
                pos.location.longitude = position.longitude;
                controller.coordinates.refresh();
              },
            ),
          )
          .toList(),
      path: controller.coordinates.map((c) => c.location).toList(),
      onTap: (LatLng l) {
        controller.addLocation(l);
      },
    );
  }
}
