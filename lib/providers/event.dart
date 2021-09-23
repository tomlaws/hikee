import 'package:hikee/models/event.dart';
import 'package:hikee/models/event_category.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/shared/base.dart';

class EventProvider extends BaseProvider {
  Future<Event> getEvent(int id) async =>
      await get('events/$id').then((value) => Event.fromJson(value.body));

  Future<Paginated<Event>> getEvents(Map<String, dynamic>? query) async {
    return await get('events', query: query).then((value) {
      return Paginated<Event>.fromJson(
          value.body, (o) => Event.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<List<EventCategory>> getCategories() async {
    List<EventCategory> categories =
        ((await get('events/categories')).body as List<dynamic>)
            .map((c) => EventCategory.fromJson(c))
            .toList();
    return categories;
  }

  Future<Event> joinEvent(int id) async {
    var res = await post('events/$id/participations', {});
    return Event.fromJson(res.body);
  }

  Future<Event> quitEvent(int id) async {
    var res = await delete('events/$id/participations');
    return Event.fromJson(res.body);
  }
}
