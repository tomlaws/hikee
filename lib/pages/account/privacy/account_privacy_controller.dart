import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hikees/models/user.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/providers/user.dart';

class AccountPrivacyController extends GetxController {
  final userProvider = Get.put(UserProvider());
  final _authProvider = Get.find<AuthProvider>();
  final isPrivate = true.obs;

  @override
  void onInit() {
    super.onInit();
    isPrivate.value = _authProvider.me.value?.isPrivate ?? true;
  }

  get user {
    return _authProvider.me.value;
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<User> updatePrivacy() async {
    final result = await userProvider.update(isPrivate: isPrivate.value);
    _authProvider.refreshMe();
    return result;
  }
}
