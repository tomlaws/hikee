import 'package:get/get.dart';
import 'package:hikees/pages/account/account_controller.dart';

class AccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }
}
