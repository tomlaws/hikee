import 'package:hikee/models/event.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/shared/base.dart';

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

  Future<User> update({String? nickname, bool? isPrivate}) async {
    Map<String, dynamic> payload = {};
    if (nickname != null) payload['nickname'] = nickname;
    if (isPrivate != null) payload['isPrivate'] = isPrivate;
    print(payload);
    return await patch('users', payload).then((value) {
      return User.fromJson(value.body);
    });
  }
}
