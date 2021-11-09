import 'package:get/get.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/providers/topic.dart';

class TopicController extends GetxController with StateMixin<Topic> {
  final _topicProvider = Get.put(TopicProvider());
  late int id;

  @override
  void onInit() {
    super.onInit();
    id = int.parse(Get.parameters['id']!);
    append(() => () => _topicProvider.getTopic(id));
  }
}
