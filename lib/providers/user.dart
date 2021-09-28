import 'package:hikee/models/event.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/shared/base.dart';

class UserProvider extends BaseProvider {
  Future<Paginated<Event>> getEvents(Map<String, dynamic>? query) async {
    return await get('users/events', query: query).then((value) {
      return Paginated<Event>.fromJson(
          value.body, (o) => Event.fromJson(o as Map<String, dynamic>));
    });
  }
}
