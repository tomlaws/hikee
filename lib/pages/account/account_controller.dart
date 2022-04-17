import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/providers/upload.dart';
import 'package:hikees/providers/user.dart';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  var options = Rx<List<Column>>([]);
  var page = 0.0.obs;
  File? avatar;
  final _authProvider = Get.put(AuthProvider());
  final _uploadProvider = Get.put(UploadProvider());
  final _userProvider = Get.put(UserProvider());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  get user {
    return _authProvider.me;
  }

  void refreshAccount() {
    _authProvider.refreshMe();
  }

  void promptUploadIcon() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    String? file = await _uploadProvider.upload(image);
    if (file == null) return;
    await _userProvider.changeIcon(file);
    this.refreshAccount();
  }

  void logout() {
    _authProvider.logout();
  }
}
