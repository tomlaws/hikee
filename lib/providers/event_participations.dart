import 'package:get_it/get_it.dart';
import 'package:hikee/models/event_participation.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route_review.dart';
import 'package:hikee/providers/event.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/services/event.dart';

class EventParticipationsProvider
    extends PaginationChangeNotifier<EventParticipation> {
  EventProvider _eventProvider;
  EventService _eventService = GetIt.I<EventService>();

  EventParticipationsProvider({required EventProvider eventProvider})
      : _eventProvider = eventProvider;

  update({required EventProvider eventProvider}) {
    this._eventProvider = eventProvider;
  }

  @override
  Future<Paginated<EventParticipation>> get({cursor}) async {
    return await _eventService
        .getEventParticipations(_eventProvider.event?.id ?? 1, cursor: cursor);
  }
}
