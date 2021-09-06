import 'package:get_it/get_it.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/services/event.dart';

class EventsProvider extends PaginationChangeNotifier<Event> {
  AuthProvider _authProvider;
  EventService _bookmarkService = GetIt.I<EventService>();

  EventsProvider({required AuthProvider authProvider}) : _authProvider = authProvider;

  update({required AuthProvider authProvider}) {
    this._authProvider = authProvider;
  }

  Future<Event> createEvent(int routeId) async {
    Event bookmark = await _bookmarkService
        .createEvent(_authProvider.getToken(), routeId: routeId);
    insert(0, bookmark);
    return bookmark;
  }

  deleteEvent(int bookmarkId) async {
    await _bookmarkService.deleteEvent(_authProvider.getToken(),
        id: bookmarkId);
    delete((element) => element.id == bookmarkId);
  }

  @override
  Future<Paginated<Event>> get({String? cursor}) async {
    return await _bookmarkService.getEvents(_authProvider.getToken(),
        cursor: cursor);
  }
}
