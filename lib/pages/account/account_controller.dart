import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  var options = Rx<List<Column>>([]);
  var page = 0.0.obs;
  PageController pageController = PageController();
  File? avatar;

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      var currentPage = pageController.page;
      page.value = currentPage ?? 0;
      var roundedPage = pageController.page!.round();
      if (page.value == roundedPage)
        options.value = options.value.take(roundedPage + 1).toList();
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void promptUploadIcon() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    //_uploadIcon(File(image.path));
  }
}
