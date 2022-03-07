import 'package:get/get.dart';
import 'package:hikees/pages/topics/create/create_topic_controller.dart';

class CreateTopicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTopicController>(() => CreateTopicController());
  }
}
