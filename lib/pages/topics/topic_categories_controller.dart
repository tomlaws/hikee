import 'package:get/get.dart';

import 'package:hikees/models/topic_category.dart';
import 'package:hikees/pages/topics/topics_controller.dart';
import 'package:hikees/providers/topic.dart';

class TopicCategoriesController extends GetxController
    with StateMixin<List<TopicCategory>> {
  final _topicProvider = Get.put(TopicProvider());
  final currentCategory = Rxn<int?>();

  @override
  void onInit() {
    super.onInit();
    append(() => _topicProvider.getCategories);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setCategory(int? id) {
    currentCategory.value = id;
    var c = Get.find<TopicsController>();
    c.categoryId = id;
    c.refetch();
  }
}
