import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/auth.dart';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  var options = Rx<List<Column>>([]);
  var page = 0.0.obs;
  File? avatar;
  final _authProvider = Get.put(AuthProvider());
  final user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    if (_authProvider.loggedIn.value) {
      _authProvider.getMe().then((user) => this.user.value = user);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void promptUploadIcon() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    //_uploadIcon(File(image.path));
  }

  void logout() {
    _authProvider.logout();
  }
}
