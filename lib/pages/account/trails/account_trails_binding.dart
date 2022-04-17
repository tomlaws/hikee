import 'package:get/get.dart';
import 'package:hikees/pages/account/trails/account_trails_controller.dart';

class AccountTrailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountTrailsController());
  }
}
