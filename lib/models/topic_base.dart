import 'package:hikees/models/user.dart';

abstract class TopicBase {
  final int id;
  final User user;
  final String content;
  final List<String>? images;
  final DateTime createdAt;

  TopicBase(this.id, this.user, this.content, this.createdAt, this.images);
}
