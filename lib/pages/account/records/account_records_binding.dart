import 'package:get/get.dart';
import 'package:hikee/pages/account/records/account_records_controller.dart';

class AccountRecordsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountRecordsController());
  }
}
