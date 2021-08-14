import 'package:hikee/api.dart';
import 'package:hikee/constants.dart';
import 'package:hikee/models/elevation.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/models/route_review.dart';
import 'package:hikee/models/token.dart';
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
      final uri = API.getUri('/routes', queryParams: queryParams);
      List<dynamic> routes = await HttpUtils.get(uri);
      return routes.map((r) => HikingRoute.fromJson(r)).toList();
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<HikingRoute> getRoute(int id, {required Future<Token?> token}) async {
    final uri = API.getUri('/routes/$id');
    dynamic route =
        await HttpUtils.get(uri, accessToken: (await token)?.accessToken);
    return HikingRoute.fromJson(route);
  }

  Future<List<Elevation>> getElevations(int routeId) async {
    List<dynamic> e =
        await HttpUtils.get(API.getUri('/routes/$routeId/elevation'));
    return e.map((e) => Elevation.fromJson(e)).toList();
  }

  Future<Paginated<RouteReview>> getRouteReviews(int id,
      {String? cursor}) async {
    Map<String, String> queryParams = {};
    if (cursor != null) queryParams['cursor'] = cursor;
    final uri = API.getUri('/routes/$id/reviews', queryParams: queryParams);
    dynamic paginated = await HttpUtils.get(uri);
    return Paginated<RouteReview>.fromJson(
        paginated, (o) => RouteReview.fromJson(o as Map<String, dynamic>));
  }

  Future<RouteReview> createRouteReview(Future<Token?> token,
      {required int routeId,
      required String content,
      required int rating}) async {
    final uri = API.getUri('/routes/$routeId/reviews');
    print(uri);
    dynamic review = await HttpUtils.post(
        uri, {'content': content, 'rating': rating},
        accessToken: (await token)?.accessToken);
    print({'content': content, 'rating': rating});
    return RouteReview.fromJson(review);
  }
}
