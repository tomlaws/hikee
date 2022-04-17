import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/pin.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/models/trail_category.dart';
import 'package:hikees/models/trail_review.dart';
import 'package:hikees/providers/shared/base.dart';

class TrailProvider extends BaseProvider {
  Future<Trail> getTrail(int id) async =>
      await get('trails/$id').then((value) => Trail.fromJson(value.body));

  Future<Paginated<Trail>> getTrails(Map<String, dynamic>? query) async {
    return await get('trails', query: query).then((value) {
      return Paginated<Trail>.fromJson(
          value.body, (o) => Trail.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Paginated<TrailReview>> getTrailReviews(
      int trailId, Map<String, dynamic>? query) async {
    return await get('trails/$trailId/reviews', query: query).then((value) {
      return Paginated<TrailReview>.fromJson(
          value.body, (o) => TrailReview.fromJson(o as Map<String, dynamic>));
    });
  }

  // Future<List<Elevation>> getElevations(int trailId) async {
  //   return await get('trails/$trailId/elevation').then((value) {
  //     return (value.body as List).map((e) => Elevation.fromJson(e)).toList();
  //   });
  // }

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

  Future<Trail> createTrail({
    required String name,
    required int regionId,
    required int difficulty,
    required String description,
    required String path,
    required List<Pin> pins,
    required List<String> images,
  }) async {
    var params = {
      'name_en': name,
      'name_zh': name,
      'description_en': description,
      'description_zh': description,
      'difficulty': difficulty,
      'regionId': regionId,
      'path': path,
      'pins': jsonEncode(pins),
      'images': images,
    };
    var res = await post('trails', params);
    Trail newTopic = Trail.fromJson(res.body);
    return newTopic;
  }

  Future<TrailReview> createTrailReview(
      {required int id, required int rating, required String content}) async {
    var params = {
      'rating': rating,
      'content': content,
    };
    var res = await post('trails/$id/reviews', params);
    TrailReview newReview = TrailReview.fromJson(res.body);
    return newReview;
  }
}
