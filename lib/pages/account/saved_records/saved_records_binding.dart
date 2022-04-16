import 'package:get/get.dart';
import 'package:hikees/pages/account/saved_records/saved_records_controller.dart';

class SavedRecordsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SavedRecordsController());
  }
}
