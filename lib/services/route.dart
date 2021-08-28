import 'package:hikee/api.dart';
import 'package:hikee/models/elevation.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/models/route_review.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/utils/http.dart';

class RouteService {
  /// Returns a list of routes
  ///
  /// Search function can be achieved with [query] and [after] can be provided for pagination.
  /// For sorting, use [sort] and [order].
  Future<Paginated<HikingRoute>> getRoutes(
      {String? query,
      String? cursor,
      String? sort,
      String? order = 'DESC',
      int? regionId,
      int? minDifficulty,
      int? maxDifficulty,
      int? minRating,
      int? maxRating,
      int? minLength,
      int? maxLength,
      int? minDuration,
      int? maxDuration}) async {
    Map<String, dynamic> queryParams = {};
    if (query != null && query.length > 0) queryParams['query'] = query;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;
    if (regionId != null) queryParams['regionId'] = regionId.toString();
    if (minDifficulty != null)
      queryParams['minDifficulty'] = minDifficulty.toString();
    if (maxDifficulty != null)
      queryParams['maxDifficulty'] = maxDifficulty.toString();
    if (minRating != null) queryParams['minRating'] = minRating.toString();
    if (maxRating != null) queryParams['maxRating'] = maxRating.toString();
    if (minDuration != null)
      queryParams['minDuration'] = minDuration.toString();
    if (maxDuration != null)
      queryParams['maxDuration'] = maxDuration.toString();
    if (minLength != null) queryParams['minLength'] = minLength.toString();
    if (maxLength != null) queryParams['maxLength'] = maxLength.toString();
    final uri = API.getUri('/routes', queryParams: queryParams);
    dynamic paginated = await HttpUtils.get(uri);
    return Paginated<HikingRoute>.fromJson(
        paginated, (o) => HikingRoute.fromJson(o as Map<String, dynamic>));
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
    dynamic review = await HttpUtils.post(
        uri, {'content': content, 'rating': rating},
        accessToken: (await token)?.accessToken);
    return RouteReview.fromJson(review);
  }

}
