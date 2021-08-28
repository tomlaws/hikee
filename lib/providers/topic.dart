import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/services/topic.dart';

class TopicProvider extends ChangeNotifier {
  AuthProvider _authProvider;
  TopicService _topicService = GetIt.I<TopicService>();
  Topic? _topic;
  Topic? get topic => _topic;

  TopicProvider({required AuthProvider authProvider}): _authProvider = authProvider;
  
  Future<Topic?> getTopic(int id) async {
    _topic = await _topicService.getTopic(id);
    return _topic;
  }
}
