import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/services/route.dart';

class RouteProvider extends ChangeNotifier {
  AuthProvider _authProvider;
  RouteService _routeService = GetIt.I<RouteService>();
  HikingRoute? _route;
  HikingRoute? get route => _route;

  RouteProvider({required AuthProvider authProvider}): _authProvider = authProvider {
    print('rp');
  }

  Future<HikingRoute?> getRoute(int id) async {
    _route = await _routeService.getRoute(id, token: _authProvider.getToken());
    return _route;
  }
}
