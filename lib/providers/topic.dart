import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/models/topic_category.dart';
import 'package:hikee/providers/shared/base.dart';

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
}
