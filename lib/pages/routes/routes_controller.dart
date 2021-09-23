import 'package:get/get.dart';

import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/providers/route.dart';

class RoutesController extends PaginationController<Paginated<HikingRoute>> {
  final _routeProvider = Get.put(RouteProvider());

  @override
  Future<Paginated<HikingRoute>> fetch(Map<String, dynamic> query) {
    return _routeProvider.getRoutes(query);
  }
}
