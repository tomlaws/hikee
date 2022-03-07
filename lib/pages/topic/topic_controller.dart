import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/models/topic_reply.dart';
import 'package:hikees/providers/topic.dart';

class TopicController extends GetxController with StateMixin<Topic> {
  final _topicProvider = Get.put(TopicProvider());
  late GetPaginationController<TopicReply> topicReplyController;
  late ScrollController scrollController;
  late int id;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    id = int.parse(Get.parameters['id']!);
    append(() => () => _topicProvider.getTopic(id));
    topicReplyController = Get.put(GetPaginationController((queries) {
      queries['sort'] = 'id';
      queries['order'] = 'ASC';
      return _topicProvider.getTopicReplies(id, queries);
    }));
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<Topic> toggleLike() async {
    if (state?.liked == true) {
      var t = await _topicProvider.revokeLike(id);
      change(t, status: RxStatus.success());
      return t;
    } else {
      var t = await _topicProvider.like(id);
      change(t, status: RxStatus.success());
      return t;
    }
  }
}
