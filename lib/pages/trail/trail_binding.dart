import 'package:get/get.dart';
import 'package:hikee/pages/trail/trail_controller.dart';

class TrailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrailController());
  }
}
