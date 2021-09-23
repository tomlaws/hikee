import 'package:get/get.dart';
import 'package:hikee/pages/route/route_controller.dart';

class RouteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RouteController());
  }
}
