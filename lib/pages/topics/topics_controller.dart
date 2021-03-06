import 'package:get/get.dart';

import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/models/topic_category.dart';
import 'package:hikees/providers/topic.dart';

class TopicsController extends PaginationController<Topic> {
  final _topicProvider = Get.put(TopicProvider());
  int? categoryId;

  @override
  Future<Paginated<Topic>> fetch(Map<String, dynamic> query) {
    if (categoryId != null) {
      query['categoryId'] = categoryId.toString();
    }
    int? userId = int.tryParse(Get.parameters['userId'] ?? '');
    if (userId != null) {
      query['userId'] = userId.toString();
    }
    return _topicProvider.getTopics(query);
  }

  Future<List<TopicCategory>> getCategories(Map<String, dynamic> query) {
    return _topicProvider.getCategories();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
