import 'package:hikee/api.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/models/topic_reply.dart';
import 'package:hikee/utils/http.dart';

class TopicService {
  Future<Paginated<Topic>> getTopics(
      {String? query,
      String? cursor,
      String? sort,
      String? order = 'DESC'}) async {
    Map<String, dynamic> queryParams = {};
    if (query != null && query.length > 0) queryParams['query'] = query;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;
    final uri = API.getUri('/topics', queryParams: queryParams);
    dynamic paginated = await HttpUtils.get(uri);
    return Paginated<Topic>.fromJson(
        paginated, (o) => Topic.fromJson(o as Map<String, dynamic>));
  }

  Future<Topic> createTopic(Future<Token?> token,
      {required String title, required String content}) async {
    final uri = API.getUri('/topics');
    dynamic res = await HttpUtils.post(
        uri, {'title': title, 'content': content},
        accessToken: (await token)?.accessToken);
    return Topic.fromJson(res);
  }

  Future<Topic> getTopic(int id) async {
    final uri = API.getUri('/topics/$id');
    dynamic topic = await HttpUtils.get(uri);
    return Topic.fromJson(topic);
  }

  Future<TopicReply> createReply(Future<Token?> token,
      {required String topicId, required String content}) async {
    final uri = API.getUri('/topics/$topicId/replies');
    dynamic reply = await HttpUtils.post(uri, {'content': content},
        accessToken: (await token)?.accessToken);
        print(reply);
    return TopicReply.fromJson(reply);
  }

  Future<Paginated<TopicReply>> getReplies(int topicId,
      {String? cursor}) async {
    final uri = API.getUri('/topics/$topicId/replies');
    dynamic paginated = await HttpUtils.get(uri);
    return Paginated<TopicReply>.fromJson(
        paginated, (o) => TopicReply.fromJson(o as Map<String, dynamic>));
  }
}
