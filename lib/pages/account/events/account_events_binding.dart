import 'package:get/get.dart';
import 'package:hikee/pages/account/events/account_events_controller.dart';

class AccountEventsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountEventsController());
  }
}
