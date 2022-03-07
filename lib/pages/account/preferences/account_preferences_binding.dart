import 'package:get/get.dart';
import 'package:hikees/pages/account/preferences/account_preferences_controller.dart';

class AccountPreferencesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountPreferencesController());
  }
}
