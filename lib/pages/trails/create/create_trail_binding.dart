import 'package:get/get.dart';
import 'package:hikee/pages/trails/create/create_trail_controller.dart';

class CreateTrailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateTrailController());
  }
}
