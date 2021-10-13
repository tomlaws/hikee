import 'package:get/get.dart';
import 'package:hikee/pages/auth/register_controller.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
