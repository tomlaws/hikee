import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/providers/shared/base.dart';

class RouteProvider extends BaseProvider {
  Future<HikingRoute> getRoute(int id) async =>
      await get('routes/$id').then((value) => HikingRoute.fromJson(value.body));

  Future<Paginated<HikingRoute>> getRoutes(Map<String, dynamic>? query) async {
    return await get('routes', query: query).then((value) {
      return Paginated<HikingRoute>.fromJson(
          value.body, (o) => HikingRoute.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Paginated<HikingRoute>> getPopularRoutes() async {
    var query = {'sort': 'rating', 'order': 'DESC'};
    return await get('routes', query: query).then((value) {
      return Paginated<HikingRoute>.fromJson(
          value.body, (o) => HikingRoute.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<HikingRoute> getFeaturedRoute() async {
    return await get('routes/featured').then((value) {
      return HikingRoute.fromJson(value.body);
    });
  }
}
