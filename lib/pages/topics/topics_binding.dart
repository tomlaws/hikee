import 'package:get/get.dart';
import 'package:hikee/pages/topics/topics_controller.dart';

class TopicsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopicsController>(() {
      return TopicsController();
    });
  }
}
