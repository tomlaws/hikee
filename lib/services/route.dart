import 'package:hikee/constants.dart';
import 'package:hikee/models/elevation.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/utils/http.dart';

class RouteService {
  /// Return a list of routes
  ///
  /// Search function can be achieved with [query] and [after] can be provided for pagination.
  /// For sorting, use [sort] and [order].
  Future<List<HikingRoute>> getRoutes(
      {String? query, int? after, String? sort, String? order = 'DESC'}) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (query != null && query.length > 0) queryParams['query'] = query;
      if (after != null) queryParams['after'] = after.toString();
      if (sort != null) queryParams['sort'] = sort;
      if (order != null) queryParams['order'] = order;
      print(queryParams);
      final uri = Uri.https(API_HOST, '/routes', queryParams);
      List<dynamic> routes = await HttpUtils.get(uri);
      return routes.map((r) => HikingRoute.fromJson(r)).toList();
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<HikingRoute> getRoute(int id) async {
    final uri = Uri.https(API_HOST, '/routes/$id');
    dynamic route = await HttpUtils.get(uri);
    return HikingRoute.fromJson(route);
  }

  Future<List<Elevation>> getElevations(int routeId) async {
    List<dynamic> e =
        await HttpUtils.get(Uri.https(API_HOST, '/routes/$routeId/elevation'));
    return e.map((e) => Elevation.fromJson(e)).toList();
  }
}
