import 'package:get/get.dart';
import 'package:hikee/pages/routes/featured_route_controller.dart';
import 'package:hikee/pages/routes/popular_routes_controller.dart';

class RoutesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PopularRoutesController());
    Get.lazyPut(() => FeaturedRouteController());
  }
}
