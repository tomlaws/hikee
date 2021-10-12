import 'package:get/get.dart';
import 'package:hikee/pages/record/record_controller.dart';

class RecordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecordController());
  }
}
