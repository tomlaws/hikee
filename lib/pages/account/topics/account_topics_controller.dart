import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/providers/topic.dart';

class AccountTopicsController extends PaginationController<Topic> {
  final _topicProvider = Get.put(TopicProvider());
  final _authProvider = Get.find<AuthProvider>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<Paginated<Topic>> fetch(Map<String, dynamic> query) {
    query['creatorId'] = _authProvider.me.value?.id.toString();
    return _topicProvider.getTopics(query);
  }
}
