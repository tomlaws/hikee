import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/pin.dart';
import 'package:hikee/models/region.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/trail.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/geo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class CreateTrailController extends GetxController {
  final _trailProvider = Get.put<TrailProvider>(TrailProvider());
  var coordinates = RxList<Pin>([]);
  var selectedCoordinates = Rxn<Pin>();
  final step = 0.obs;
  final ImagePicker _picker = ImagePicker();

  var pointMessageTextController = TextInputController(text: '');
  var nameController = TextInputController(text: '');
  var descriptionController = TextInputController(text: '');
  var durationController = TextInputController(text: '');
  var difficulty = 0;
  var region = Rxn<Region>();
  final images = RxList<Uint8List>();
  var publishing = false.obs;

  @override
  void onClose() {
    pointMessageTextController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void addLocation(LatLng location) {
    var newPin = new Pin(location: location, message: null);
    coordinates.add(newPin);
    selectedCoordinates.value = newPin;
  }

  void removeLocation() {
    coordinates.remove(selectedCoordinates.value);
    selectedCoordinates.value = null;
  }

  void addMessage() async {
    if (selectedCoordinates.value == null) {
      DialogUtils.showDialog("Error", "Please select a point");
      return;
    }
    await DialogUtils.showActionDialog(
        "Message",
        Column(
          children: [
            TextInput(
              hintText: "Custom message here...",
              maxLines: 6,
              controller: pointMessageTextController,
            )
          ],
        ), onOk: () {
      if (pointMessageTextController.text.length == 0) {
        DialogUtils.showDialog("Error", "Message cannot be empty");
        throw new Error();
      }
      if (selectedCoordinates.value != null) {
        selectedCoordinates.value!.message = pointMessageTextController.text;
      }
      coordinates.refresh();
    });
    pointMessageTextController.text = '';
  }

  void removeMessage() {
    if (selectedCoordinates.value != null) {
      selectedCoordinates.value!.message = null;
    }
  }

  void editMessage(Pin pos) async {
    if (pos.message == null) return;
    pointMessageTextController.text = pos.message!;
    await DialogUtils.showActionDialog(
        "Message",
        Column(
          children: [
            TextInput(
              hintText: "Custom message here...",
              maxLines: 6,
              controller: pointMessageTextController,
            )
          ],
        ), onOk: () {
      pos.message = pointMessageTextController.text;
      coordinates.refresh();
    });
    pointMessageTextController.text = '';
  }

  void remove(int i) {
    coordinates.removeAt(i);
  }

  void pickImages() async {
    List<XFile> files =
        await _picker.pickMultiImage(imageQuality: 80, maxWidth: 1280) ?? [];
    for (var file in files) {
      images.add(await file.readAsBytes());
    }
  }

  void removeImage(Uint8List image) {
    images.remove(image);
  }

  Future<Trail> create() async {
    var path = GeoUtils.encodePath(coordinates.map((e) => e.location).toList());
    var pins = coordinates.where((c) => c.message != null).toList();
    var length = (GeoUtils.getPathLength(
                path: coordinates.map((c) => c.location).toList()) *
            1000)
        .truncate();
    int duration = int.parse(durationController.text);
    return await _trailProvider.createTrail(
        name: nameController.text,
        regionId: region.value!.id,
        difficulty: difficulty,
        duration: duration,
        length: length,
        description: descriptionController.text,
        path: path,
        pins: pins,
        images: images);
  }
}
