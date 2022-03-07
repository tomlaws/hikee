import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/models/topic_category.dart';
import 'package:hikees/models/topic_reply.dart';
import 'package:hikees/providers/shared/base.dart';

class TopicProvider extends BaseProvider {
  Future<Paginated<Topic>> getTopics(Map<String, dynamic>? query) async {
    return await get('topics', query: query).then((value) {
      return Paginated<Topic>.fromJson(
          value.body, (o) => Topic.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Topic> getTopic(int id) async {
    var res = await get('topics/$id');
    return Topic.fromJson(res.body);
  }

  Future<Topic> like(int id) async {
    var res = await post('topics/$id/likes', {});
    return Topic.fromJson(res.body);
  }

  Future<Topic> revokeLike(int id) async {
    var res = await delete('topics/$id/likes');
    return Topic.fromJson(res.body);
  }

  Future<Paginated<TopicReply>> getTopicReplies(
      int topicId, Map<String, dynamic>? query) async {
    return await get('topics/$topicId/replies', query: query).then((value) {
      return Paginated<TopicReply>.fromJson(
          value.body, (o) => TopicReply.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<List<TopicCategory>> getCategories() async {
    List<TopicCategory> categories =
        ((await get('topics/categories')).body as List<dynamic>)
            .map((c) => TopicCategory.fromJson(c))
            .toList();
    categories.insert(
        0, TopicCategory(id: null, name_zh: '一般', name_en: 'General'));
    return categories;
  }

  Future<Topic> createTopic(
      {required String title,
      required String content,
      required List<Uint8List> images,
      int? categoryId}) async {
    var params = {
      'title': title,
      'content': content,
      'images': images
          .asMap()
          .map((i, e) => MapEntry(
              i,
              MultipartFile(
                e,
                filename: '${i.toString()}.jpeg',
              )))
          .values
          .toList()
    };
    if (categoryId != null) {
      params['categoryId'] = categoryId;
    }
    final form = FormData(params);
    var res = await post('topics', form);
    Topic newTopic = Topic.fromJson(res.body);
    return newTopic;
  }

  createTopicReply(
      {required int topicId,
      required String content,
      required List<Uint8List> images}) async {
    var params = {
      'content': content,
      'images': images
          .asMap()
          .map((i, e) => MapEntry(
              i,
              MultipartFile(
                e,
                filename: '${i.toString()}.jpeg',
              )))
          .values
          .toList()
    };
    final form = FormData(params);
    var res = await post('topics/$topicId/replies', form);
    TopicReply newReply = TopicReply.fromJson(res.body);
    return newReply;
  }
}
