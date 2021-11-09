import 'package:get/get.dart';
import 'package:hikee/pages/trails/category/trail_category_controller.dart';

class TrailCategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrailCategoryController());
  }
}
