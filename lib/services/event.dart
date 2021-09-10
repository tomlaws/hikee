import 'package:hikee/api.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/models/event_category.dart';
import 'package:hikee/models/event_participation.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/utils/http.dart';

class EventService {
  Future<Paginated<Event>> getEvents(Future<Token?> token,
      {String? query,
      String? cursor,
      String? sort,
      String? order = 'DESC'}) async {
    Map<String, String> queryParams = {};
    if (query != null && query.length > 0) queryParams['query'] = query;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;

    final uri = API.getUri('/events', queryParams: queryParams);
    dynamic paginated =
        await HttpUtils.get(uri, accessToken: (await token)?.accessToken);
    return Paginated<Event>.fromJson(
        paginated, (o) => Event.fromJson(o as Map<String, dynamic>));
  }

  Future<Event> createEvent(Future<Token?> token,
      {required int routeId}) async {
    final uri = API.getUri('/events');
    dynamic res = await HttpUtils.post(uri, {'routeId': routeId},
        accessToken: (await token)?.accessToken);
    return Event.fromJson(res);
  }

  Future<bool> deleteEvent(Future<Token?> token, {required int id}) async {
    final uri = API.getUri('/events/$id');
    dynamic res =
        await HttpUtils.delete(uri, accessToken: (await token)?.accessToken);
    return res;
  }

  Future<Event> getEvent(int id, {required Future<Token?> token}) async {
    final uri = API.getUri('/events/$id');
    dynamic event =
        await HttpUtils.get(uri, accessToken: (await token)?.accessToken);
    return Event.fromJson(event);
  }

  Future<List<EventCategory>> getEventCategories() async {
    final uri = API.getUri('/events/categories');
    List<dynamic> categories = await HttpUtils.get(uri);
    return categories.map((c) => EventCategory.fromJson(c)).toList();
  }

  Future<Event> joinEvent(int id, {required Future<Token?> token}) async {
    final uri = API.getUri('/events/$id/participations');
    dynamic event = await HttpUtils.post(
      uri,
      {},
      accessToken: (await token)?.accessToken,
    );
    return Event.fromJson(event);
  }

  Future<Event> quitEvent(int id, {required Future<Token?> token}) async {
    final uri = API.getUri('/events/$id/participations');
    dynamic event = await HttpUtils.delete(
      uri,
      accessToken: (await token)?.accessToken,
    );
    return Event.fromJson(event);
  }

  Future<Paginated<EventParticipation>> getEventParticipations(int id,
      {String? query,
      String? cursor,
      String? sort = 'createdAt',
      String? order = 'DESC'}) async {
    Map<String, String> queryParams = {};
    if (query != null && query.length > 0) queryParams['query'] = query;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;

    final uri =
        API.getUri('/events/$id/participations', queryParams: queryParams);
    dynamic paginated = await HttpUtils.get(uri);
    return Paginated<EventParticipation>.fromJson(paginated,
        (o) => EventParticipation.fromJson(o as Map<String, dynamic>));
  }
}
