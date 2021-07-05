import 'package:flutter/widgets.dart';
import 'package:hikee/models/route.dart';

class ActiveHikingRoute extends ChangeNotifier {
  int _id = 0;
  HikingRoute? _route;
  int get id => _id;
  HikingRoute? get route => _route;

  void update(HikingRoute? route) {
    _id++;
    this._route = route;
    notifyListeners();
  }
}
