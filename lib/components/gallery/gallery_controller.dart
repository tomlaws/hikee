import 'package:get/get.dart';

class GalleryController extends GetxController {
  late List<String> images;
  late String image;

  @override
  void onInit() {
    super.onInit();
    images = Get.arguments['images'];
    image = Get.arguments['image'];
  }

  @override
  void onClose() {
    super.onClose();
  }
}
