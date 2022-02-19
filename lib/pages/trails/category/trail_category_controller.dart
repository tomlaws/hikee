import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/trail.dart';

class TrailCategoryController extends PaginationController<Trail> {
  final _trailProvider = Get.put(TrailProvider());
  int? categoryId;
  var categoryName = '';
  @override
  void onInit() {
    super.onInit();
    categoryName = Get.arguments['categoryName'];
    categoryId = int.parse(Get.parameters['id'] ?? '');
  }

  @override
  Future<Paginated<Trail>> fetch(Map<String, dynamic> queryParams) {
    if (categoryId != null) {
      queryParams['categoryId'] = categoryId.toString();
    }
    return _trailProvider.getTrails(queryParams);
  }
}
