import 'package:get/get.dart';
import 'package:hikees/pages/account/topics/account_topics_controller.dart';

class AccountTopicsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountTopicsController());
  }
}
