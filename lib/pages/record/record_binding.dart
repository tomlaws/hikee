import 'package:get/get.dart';
import 'package:hikees/pages/record/record_controller.dart';

class RecordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecordController());
  }
}
