import 'package:hikee/models/elevation.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/models/trail_category.dart';
import 'package:hikee/providers/shared/base.dart';

class TrailProvider extends BaseProvider {
  Future<Trail> getTrail(int id) async =>
      await get('trails/$id').then((value) => Trail.fromJson(value.body));

  Future<Paginated<Trail>> getTrails(Map<String, dynamic>? query) async {
    return await get('trails', query: query).then((value) {
      return Paginated<Trail>.fromJson(
          value.body, (o) => Trail.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<List<Elevation>> getElevations(int trailId) async {
    return await get('trails/$trailId/elevation').then((value) {
      return (value.body as List).map((e) => Elevation.fromJson(e)).toList();
    });
  }

  Future<Paginated<Trail>> getPopularTrails() async {
    var query = {'sort': 'rating', 'order': 'DESC'};
    return await get('trails', query: query).then((value) {
      return Paginated<Trail>.fromJson(
          value.body, (o) => Trail.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Trail> getFeaturedTrail() async {
    return await get('trails/featured').then((value) {
      return Trail.fromJson(value.body);
    });
  }

  Future<List<TrailCategory>> getTrailCategories() async {
    return await get('trails/categories').then((value) {
      return (value.body as List)
          .map((e) => TrailCategory.fromJson(e))
          .toList();
    });
  }
}
