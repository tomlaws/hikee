import 'package:get/get.dart';
import 'package:hikee/pages/account/bookmarks/account_bookmarks_controller.dart';

class AccountBookmarksBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountBookmarksController());
  }
}
