import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/map_marker.dart';
import 'package:hikees/models/pin.dart';
import 'package:hikees/models/region.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/trail.dart';
import 'package:hikees/providers/upload.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/geo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';

class CreateTrailController extends GetxController {
  final _trailProvider = Get.put<TrailProvider>(TrailProvider());
  final _uploadProvider = Get.put(UploadProvider());
  var coordinates = RxList<LatLng>([]);
  var selectedCoordinates = Rxn<LatLng>();
  Future<Tuple2<int, int>> lengthAndDuration = Future.value(Tuple2(0, 0));
  final step = 0.obs;
  final ImagePicker _picker = ImagePicker();

  late StreamSubscription<List<LatLng>>? subscriptionCoordinates;
  final markers = RxList<MapMarker>([]);
  var pointMessageTextController = TextInputController(text: '');
  var nameController = TextInputController(text: '');
  var descriptionController = TextInputController(text: '');
  var difficulty = 0;
  var region = Rxn<Region>();
  final images = RxList<Uint8List>();
  final imageNames = RxList<String>();
  var publishing = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments?.containsKey('path') == true) {
      var decoded = GeoUtils.decodePath(Get.arguments['path']!);
      coordinates.value = decoded;
      nameController.text = Get.arguments['name'].toString();
      region.value = Get.arguments['region'];
      step.value = 1;
    }
    subscriptionCoordinates = coordinates.listen((c) {
      lengthAndDuration = GeoUtils.calculateLengthAndDuration(c);
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
    coordinates.add(location);
    selectedCoordinates.value = location;
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
        markers.add(MapMarker(
            locationInLatLng: location,
            title: title,
            message: message,
            color: Colors.indigo));
        return true;
      } else {
        throw new Error();
      }
    });
  }

  void removeLocation() {
    coordinates.remove(selectedCoordinates.value);
    selectedCoordinates.value = null;
  }

  void remove(int i) {
    coordinates.removeAt(i);
  }

  void pickImages() async {
    List<XFile> files =
        await _picker.pickMultiImage(imageQuality: 80, maxWidth: 1280) ?? [];
    for (var file in files) {
      images.add(await file.readAsBytes());
      imageNames.add(file.name);
    }
  }

  void removeImage(Uint8List image) {
    var i = images.indexOf(image);
    images.removeAt(i);
    imageNames.removeAt(i);
  }

  Future<Trail> create() async {
    var path = GeoUtils.encodePath(coordinates);

    var futures = <Future<String?>>[];
    for (int i = 0; i < images.length; i++) {
      futures.add(_uploadProvider.uploadBytes(images[i], imageNames[i]));
    }
    List<String?> uploadedImages = await Future.wait(futures);
    List<String> nonNullImages = uploadedImages.whereType<String>().toList();

    return await _trailProvider.createTrail(
        name: nameController.text,
        regionId: region.value!.id,
        difficulty: difficulty,
        description: descriptionController.text,
        path: path,
        markers: markers,
        images: nonNullImages);
  }
}
