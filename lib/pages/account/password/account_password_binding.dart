import 'package:get/get.dart';
import 'package:hikee/pages/account/password/account_password_controller.dart';

class AccountPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountPasswordController());
  }
}
