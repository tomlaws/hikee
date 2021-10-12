import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/providers/topic.dart';

class TopicsController extends PaginationController<Paginated<Topic>> {
  final _topicProvider = Get.put(TopicProvider());
  ScrollController scrollController = ScrollController();

  @override
  Future<Paginated<Topic>> fetch(Map<String, dynamic> query) {
    return _topicProvider.getTopics(query);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}