import 'package:get/get.dart';
import 'package:hikees/models/trail_category.dart';
import 'package:hikees/providers/trail.dart';

class TrailCategoriesController extends GetxController
    with StateMixin<List<TrailCategory>> {
  final _trailProvider = Get.put(TrailProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => _trailProvider.getTrailCategories);
  }
}
