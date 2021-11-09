import 'package:get/get.dart';
import 'package:hikee/pages/trails/featured_trail_controller.dart';
import 'package:hikee/pages/trails/popular_trails_controller.dart';

class TrailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PopularTrailsController());
    Get.lazyPut(() => FeaturedTrailController());
  }
}
