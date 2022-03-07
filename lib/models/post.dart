import 'package:hikees/models/user.dart';

class HikingPost {
  final int id;
  final User user;
  final String title;
  final String content;
  final int likes;
  final List<Comment> comments;

  HikingPost(
      this.id, this.user, this.title, this.content, this.likes, this.comments);

  HikingPost.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = json['user'],
        title = json['title'],
        content = json['content'],
        likes = json['likes'],
        comments = json['comments'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'title': title,
        'content': content,
        'likes': content,
        'comments': comments
      };
}

class Comment {
  final int id;
  final User user;
  final String comment;
  final int likes;

  Comment(this.id, this.user, this.comment, this.likes);

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = json['user'],
        comment = json['comment'],
        likes = json['likes'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'user': user, 'comment': comment, 'likes': likes};
}
