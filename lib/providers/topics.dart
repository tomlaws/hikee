import 'package:get_it/get_it.dart';
import 'package:hikee/models/order.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/services/topic.dart';

class TopicsProvider
    extends AdvancedPaginationChangeNotifier<Topic, TopicSortable> {
  AuthProvider _authProvider;
  TopicService _topicService = GetIt.I<TopicService>();

  TopicsProvider({required AuthProvider authProvider})
      : _authProvider = authProvider,
        super(
            sortable: TopicSortable.values,
            defaultSort: TopicSortable.createdAt,
            defaultOrder: Order.DESC);

  void update({required AuthProvider authProvider}) {
    _authProvider = authProvider;
  }

  @override
  Future<Paginated<Topic>> get(
      {String? cursor, String? sort, String? order, String? query}) async {
    return await _topicService.getTopics(
        cursor: cursor, query: query, sort: sort, order: order);
  }

  Future<Topic> createTopic(String title, String content) async {
    Topic topic = await _topicService.createTopic(
      _authProvider.getToken(),
      content: content,
      title: title,
    );
    insert(0, topic);
    return topic;
  }
}

enum TopicSortable { createdAt, likeCount, replyCount }

extension TopicsSortableExtension on TopicSortable {
  String get name {
    return ['Date', 'Likes', 'Replies'][this.index];
  }
}
