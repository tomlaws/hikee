import 'package:flutter/widgets.dart' as widgets;
import 'package:hikee/models/route.dart';

class ActiveRoute extends widgets.ChangeNotifier {
  int _id = 0;
  Route? _route;
  int get id => _id;
  Route? get route => _route;

  void update(Route? route) {
    _id++;
    this._route = route;
    notifyListeners();
  }
}
