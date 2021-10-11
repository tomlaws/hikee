import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/providers/route.dart';
import 'package:hikee/utils/geo.dart';

class RouteController extends GetxController with StateMixin<HikingRoute> {
  final _routeProvider = Get.put(RouteProvider());

  PageController carouselController = PageController();
  final carouselPage = 0.0.obs;
  final bookmarked = false.obs;
  final points = Rxn<List<LatLng>>();

  @override
  void onInit() {
    super.onInit();
    append(() => loadRoute);

    carouselController.addListener(() {
      double page = carouselController.page ?? 0;
      carouselPage.value = page;
    });
  }

  Future<HikingRoute> loadRoute() async {
    int id = int.parse(Get.parameters['routeId'] ?? Get.parameters['id'] ?? '');
    var route = await _routeProvider.getRoute(id);
    bookmarked.value = route.bookmark != null;
    points.value = GeoUtils.decodePath(route.path);
    return route;
  }

  @override
  void onClose() {
    carouselController.dispose();
    super.onClose();
  }
}
