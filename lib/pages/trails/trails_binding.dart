import 'package:get/get.dart';
import 'package:hikees/pages/trails/featured_trail_controller.dart';
import 'package:hikees/pages/trails/popular_trails_controller.dart';

class TrailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PopularTrailsController());
    Get.lazyPut(() => FeaturedTrailController());
  }
}
