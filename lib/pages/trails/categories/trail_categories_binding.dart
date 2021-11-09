import 'package:get/get.dart';
import 'package:hikee/pages/trails/categories/trail_categories_controller.dart';

class TrailCategoriesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrailCategoriesController());
  }
}
