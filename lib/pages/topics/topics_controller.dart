import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/models/topic_category.dart';
import 'package:hikee/providers/topic.dart';

class TopicsController extends PaginationController<Topic> {
  final _topicProvider = Get.put(TopicProvider());
  int? categoryId;

  @override
  Future<Paginated<Topic>> fetch(Map<String, dynamic> query) {
    if (categoryId != null) {
      query['categoryId'] = categoryId.toString();
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
