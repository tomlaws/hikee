import 'package:get/get.dart';
import 'package:hikees/pages/account/offline_trails/offline_trails_controller.dart';

class OfflineTrailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OfflineTrailsController());
  }
}
