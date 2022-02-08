import 'package:get/get.dart';
import 'package:hikee/pages/account/privacy/account_privacy_controller.dart';

class AccountPrivacyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountPrivacyController());
  }
}
