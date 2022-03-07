import 'package:hikees/models/event.dart';
import 'package:hikees/models/event_category.dart';
import 'package:hikees/models/event_participation.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/providers/shared/base.dart';

class EventProvider extends BaseProvider {
  Future<Event> getEvent(int id) async =>
      await get('events/$id').then((value) => Event.fromJson(value.body));

  Future<Paginated<Event>> getEvents(Map<String, dynamic>? query) async {
    return await get('events', query: query).then((res) {
      return Paginated<Event>.fromJson(
          res.body, (o) => Event.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<List<EventCategory>> getCategories() async {
    List<EventCategory> categories =
        ((await get('events/categories')).body as List<dynamic>)
            .map((c) => EventCategory.fromJson(c))
            .toList();
    return categories;
  }

  Future<Event> createEvent(
      {required String name,
      required String description,
      required DateTime date,
      required int trailId}) async {
    var res = await post('events', {
      'name': name,
      'description': description,
      'date': date.toString(),
      'trailId': trailId
    });
    return Event.fromJson(res.body);
  }

  Future<EventParticipation> joinEvent(int id) async {
    var res = await post('events/$id/participations', {});
    return EventParticipation.fromJson(res.body);
  }

  Future<EventParticipation> quitEvent(int id) async {
    var res = await delete('events/$id/participations');
    return EventParticipation.fromJson(res.body);
  }

  Future<Paginated<EventParticipation>> getParticipation(int id) async {
    var res = await get('events/$id/participations');
    return Paginated<EventParticipation>.fromJson(res.body,
        (o) => EventParticipation.fromJson(o as Map<String, dynamic>));
  }
}
