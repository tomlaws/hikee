import 'package:get/get.dart';
import 'package:hikee/pages/auth/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
