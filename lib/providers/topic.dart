import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/providers/shared/base.dart';

class TopicProvider extends BaseProvider {
  Future<Paginated<Topic>> getTopics(Map<String, dynamic>? query) async {
    return await get('topics', query: query).then((value) {
      return Paginated<Topic>.fromJson(
          value.body, (o) => Topic.fromJson(o as Map<String, dynamic>));
    });
  }
}
