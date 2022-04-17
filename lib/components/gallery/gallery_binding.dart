import 'package:get/get.dart';
import 'package:hikees/components/gallery/gallery_controller.dart';

class GalleryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GalleryController());
  }
}
