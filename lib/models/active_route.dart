import 'package:flutter/widgets.dart' as widgets;
import 'package:hikee/models/route.dart';

class ActiveRoute extends widgets.ChangeNotifier {
  Route? _route;

  Route? get route => _route;

  void update(Route? route) {
    this._route = route;
    notifyListeners();
  }
}
