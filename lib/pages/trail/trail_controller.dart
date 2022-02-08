import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/trail.dart';
import 'package:hikee/utils/geo.dart';

class TrailController extends GetxController with StateMixin<Trail> {
  final _trailProvider = Get.put(TrailProvider());

  MapController? mapController;
  PageController carouselController = PageController();
  final carouselPage = 0.0.obs;
  final bookmarked = false.obs;
  final points = Rxn<List<LatLng>>();

  @override
  void onInit() {
    super.onInit();
    append(() => loadTrail);

    carouselController.addListener(() {
      double page = carouselController.page ?? 0;
      carouselPage.value = page;
    });
  }

  Future<Trail> loadTrail() async {
    int id = int.parse(Get.parameters['trailId'] ?? Get.parameters['id'] ?? '');
    var trail = await _trailProvider.getTrail(id);
    bookmarked.value = trail.bookmark != null;
    points.value = GeoUtils.decodePath(trail.path);
    return trail;
  }

  @override
  void onClose() {
    carouselController.dispose();
    super.onClose();
  }
}
