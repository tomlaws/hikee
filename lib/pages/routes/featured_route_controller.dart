import 'package:get/get.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/providers/route.dart';

class FeaturedRouteController extends GetxController
    with StateMixin<HikingRoute> {
  final _routeProvider = Get.put(RouteProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => _routeProvider.getFeaturedRoute);
  }
}
