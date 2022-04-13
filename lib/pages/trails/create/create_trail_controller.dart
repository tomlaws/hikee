import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/pin.dart';
import 'package:hikees/models/region.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/trail.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/geo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';

class CreateTrailController extends GetxController {
  final _trailProvider = Get.put<TrailProvider>(TrailProvider());
  var coordinates = RxList<Pin>([]);
  var selectedCoordinates = Rxn<Pin>();
  Future<Tuple2<int, int>> lengthAndDuration = Future.value(Tuple2(0, 0));
  final step = 0.obs;
  final ImagePicker _picker = ImagePicker();

  late StreamSubscription<List<Pin>>? subscriptionCoordinates;
  var pointMessageTextController = TextInputController(text: '');
  var nameController = TextInputController(text: '');
  var descriptionController = TextInputController(text: '');
  var difficulty = 0;
  var region = Rxn<Region>();
  final images = RxList<Uint8List>();
  var publishing = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments?.containsKey('path') == true) {
      var decoded = GeoUtils.decodePath(Get.arguments['path']!);
      coordinates.value =
          decoded.map((e) => new Pin(location: e, message: null)).toList();
      nameController.text = Get.arguments['name'].toString();
      region.value = Get.arguments['region'];
      step.value = 1;
    }
    subscriptionCoordinates = coordinates.listen((c) {
      lengthAndDuration = GeoUtils.calculateLengthAndDuration(
          c.map((e) => e.location).toList());
    });
  }

  @override
  void onClose() {
    subscriptionCoordinates?.cancel();
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

  void editMessage(Pin? pin) async {
    if (pin == null) {
      DialogUtils.showDialog("Error", "Please select a point");
      return;
    }
    final formkey = GlobalKey<FormState>();
    await DialogUtils.showActionDialog(
        "Message",
        Form(
          key: formkey,
          child: Column(
            children: [
              TextInput(
                hintText: "Custom message here...",
                maxLines: 6,
                initialValue: pin.message,
                onSaved: (v) => pin.message = v ?? '',
                validator: (v) {
                  if (v == null || v.length == 0) {
                    return 'fieldCannotBeEmpty'
                        .trParams({'field': 'message'.tr});
                  }
                  if (v.length > 100) {
                    return 'fieldTooLong'.trParams({'field': 'message'.tr});
                  }
                  return null;
                },
              )
            ],
          ),
        ), onOk: () {
      if (formkey.currentState?.validate() == true) {
        formkey.currentState?.save();
        coordinates.refresh();
        return true;
      } else {
        return null;
      }
    });
    pointMessageTextController.text = '';
  }

  void removeMessage() {
    if (selectedCoordinates.value != null) {
      selectedCoordinates.value!.message = null;
    }
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
    return await _trailProvider.createTrail(
        name: nameController.text,
        regionId: region.value!.id,
        difficulty: difficulty,
        description: descriptionController.text,
        path: path,
        pins: pins,
        images: images);
  }
}
