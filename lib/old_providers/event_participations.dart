import 'package:get_it/get_it.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/models/event_participation.dart';
import 'package:hikee/old_providers/auth.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route_review.dart';
import 'package:hikee/old_providers/event.dart';
import 'package:hikee/old_providers/pagination_change_notifier.dart';
import 'package:hikee/services/event.dart';

class EventParticipationsProvider
    extends PaginationChangeNotifier<EventParticipation> {
  AuthProvider _authProvider;
  EventProvider _eventProvider;
  EventService _eventService = GetIt.I<EventService>();

  EventParticipationsProvider(
      {required AuthProvider authProvider,
      required EventProvider eventProvider})
      : _authProvider = authProvider,
        _eventProvider = eventProvider;

  update(
      {required AuthProvider authProvider,
      required EventProvider eventProvider}) {
    this._authProvider = authProvider;
    this._eventProvider = eventProvider;
  }

  @override
  Future<Paginated<EventParticipation>> get({cursor}) async {
    return await _eventService
        .getEventParticipations(_eventProvider.event?.id ?? 1, cursor: cursor);
  }

  Future<Event?> joinEvent() async {
    Event event = await _eventService.joinEvent(_eventProvider.event!.id,
        token: _authProvider.getToken());
    _eventProvider.event = event;
    fetch(false);
    return event;
  }

  Future<Event?> quitEvent() async {
    Event event = await _eventService.quitEvent(_eventProvider.event!.id,
        token: _authProvider.getToken());
    _eventProvider.event = event;
    fetch(false);
    return event;
  }
}
