import 'package:hikees/models/bookmark.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/user.dart';
import 'package:hikees/providers/shared/base.dart';

class UserProvider extends BaseProvider {
  Future<User> getUser(int userId) async {
    var res = await get('users/${userId.toString()}');
    return User.fromJson(res.body);
  }

  Future<Paginated<Event>> getEvents(Map<String, dynamic>? query) async {
    return await get('users/events', query: query).then((value) {
      return Paginated<Event>.fromJson(
          value.body, (o) => Event.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Paginated<Bookmark>> getBookmarks(Map<String, dynamic>? query) async {
    return await get('users/bookmarks', query: query).then((value) {
      return Paginated<Bookmark>.fromJson(
          value.body, (o) => Bookmark.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<User> update({String? nickname, bool? isPrivate}) async {
    Map<String, dynamic> payload = {};
    if (nickname != null) payload['nickname'] = nickname;
    if (isPrivate != null) payload['isPrivate'] = isPrivate;
    return await patch('users', payload).then((value) {
      return User.fromJson(value.body);
    });
  }
}
