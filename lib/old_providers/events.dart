import 'package:get_it/get_it.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/models/event_category.dart';
import 'package:hikee/models/order.dart';
import 'package:hikee/old_providers/auth.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/old_providers/pagination_change_notifier.dart';
import 'package:hikee/services/event.dart';

class EventsProvider
    extends AdvancedPaginationChangeNotifier<Event, EventSortable> {
  AuthProvider _authProvider;
  EventService _eventService = GetIt.I<EventService>();

  EventsProvider({required AuthProvider authProvider})
      : _authProvider = authProvider,
        super(
            sortable: EventSortable.values,
            defaultSort: EventSortable.createdAt,
            defaultOrder: Order.DESC);

  update({required AuthProvider authProvider}) {
    this._authProvider = authProvider;
  }

  Future<Event> createEvent(int routeId) async {
    Event bookmark = await _eventService.createEvent(_authProvider.getToken(),
        routeId: routeId);
    insert(0, bookmark);
    return bookmark;
  }

  deleteEvent(int bookmarkId) async {
    await _eventService.deleteEvent(_authProvider.getToken(), id: bookmarkId);
    delete((element) => element.id == bookmarkId);
  }

  @override
  Future<Paginated<Event>> get(
      {String? cursor, String? query, String? sort, String? order}) async {
    return await _eventService.getEvents(_authProvider.getToken(),
        cursor: cursor, query: query, sort: sort, order: order);
  }

  Future<List<EventCategory>> getCategories() {
    return _eventService.getEventCategories();
  }
}

enum EventSortable { createdAt, date }
