import 'package:get/get.dart';

import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/trail.dart';

class TrailsController extends PaginationController<Paginated<Trail>> {
  final _trailProvider = Get.put(TrailProvider());

  @override
  Future<Paginated<Trail>> fetch(Map<String, dynamic> query) {
    return _trailProvider.getTrails(query);
  }
}
