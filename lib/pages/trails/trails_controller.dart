import 'package:get/get.dart';

import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/region.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/pages/trails/popular_trails_controller.dart';
import 'package:hikee/providers/trail.dart';

import 'featured_trail_controller.dart';

// default
final Set<int> defaultRegions = Region.allRegions().map((e) => e.id).toSet();
final int defaultMinDuration = 0; // minutes
final int defaultMaxDuration = 10 * 60;
final int defaultMinLength = 0; //meters
final int defaultMaxLength = 20 * 1000;

class TrailsController extends PaginationController<Trail> {
  final _trailProvider = Get.put(TrailProvider());

  Set<int> regions = {...defaultRegions};
  int minDuration = defaultMinDuration;
  int maxDuration = defaultMaxDuration;
  int minLength = defaultMinLength;
  int maxLength = defaultMaxLength;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<Paginated<Trail>> fetch(Map<String, dynamic> query) {
    if (minDuration != defaultMinDuration) {
      query['minDuration'] = minDuration.toString();
    }
    if (maxDuration != defaultMaxDuration) {
      query['maxDuration'] = maxDuration.toString();
    }
    if (minLength != defaultMinLength) {
      query['maxDuration'] = maxDuration.toString();
    }
    if (maxLength != defaultMaxLength) {
      query['maxLength'] = maxLength.toString();
    }
    if (!regions.containsAll(defaultRegions)) {
      query['regionIds'] = regions.toList().toString();
    }
    return _trailProvider.getTrails(query);
  }
}
