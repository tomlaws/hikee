import 'package:get/get.dart';
import 'package:hikees/pages/profile/profile_controller.dart';
import 'package:hikees/pages/topics/topics_controller.dart';
import 'package:hikees/pages/trails/trails_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileController(),
    );
    Get.lazyPut(() => TrailsController(), tag: 'profile-trails');
    Get.lazyPut(() => TopicsController(), tag: 'profile-topics');
  }
}
