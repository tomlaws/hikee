import 'package:get/get.dart';
import 'package:hikees/pages/topic/topic_controller.dart';

class TopicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopicController>(() => TopicController());
  }
}
