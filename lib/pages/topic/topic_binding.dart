import 'package:get/get.dart';
import 'package:hikee/pages/topic/topic_controller.dart';

class TopicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopicController>(() => TopicController());
  }
}
