import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/services/event.dart';

class EventProvider extends ChangeNotifier {
  AuthProvider _authProvider;
  EventService _eventService = GetIt.I<EventService>();
  Event? _event;
  Event? get event => _event;
  set event(e) {
    _event = e;
    notifyListeners();
  }

  EventProvider({required AuthProvider authProvider})
      : _authProvider = authProvider;

  update({required AuthProvider authProvider}) {
    this._authProvider = authProvider;
  }

  Future<Event?> getEvent(int id) async {
    _event = await _eventService.getEvent(id, token: _authProvider.getToken());
    notifyListeners();
    return _event;
  }
}
