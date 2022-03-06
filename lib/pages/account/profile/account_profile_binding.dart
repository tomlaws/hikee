import 'package:get/get.dart';
import 'package:hikee/pages/account/profile/account_profile_controller.dart';

class AccountProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountProfileController());
  }
}
