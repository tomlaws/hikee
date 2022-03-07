import 'package:get/get.dart';
import 'package:hikees/pages/trail/trail_controller.dart';

class TrailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrailController());
  }
}
