import 'package:get/get.dart';
import 'package:hikee/pages/topics/create/create_topic_controller.dart';

class CreateTopicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTopicController>(() => CreateTopicController());
  }
}
