import 'package:get_it/get_it.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/topic_reply.dart';
import 'package:hikee/old_providers/auth.dart';
import 'package:hikee/old_providers/pagination_change_notifier.dart';
import 'package:hikee/old_providers/topic.dart';
import 'package:hikee/services/topic.dart';

class TopicRepliesProvider extends PaginationChangeNotifier<TopicReply> {
  AuthProvider _authProvider;
  TopicProvider _topicProvider;
  TopicService _topicService = GetIt.I<TopicService>();

  TopicRepliesProvider(
      {required AuthProvider authProvider,
      required TopicProvider topicProvider})
      : _authProvider = authProvider,
        _topicProvider = topicProvider;

  Future<TopicReply> createReply(String content) async {
    TopicReply topicReply = await _topicService.createReply(
      _authProvider.getToken(),
      topicId: _topicProvider.topic!.id.toString(),
      content: content,
    );
    insert(items.length, topicReply);
    return topicReply;
  }

  @override
  Future<Paginated<TopicReply>> get({cursor}) async {
    return await _topicService.getReplies(_topicProvider.topic?.id ?? 1,
        cursor: cursor);
  }
}
