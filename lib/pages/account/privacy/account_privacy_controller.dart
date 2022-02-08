import 'package:get/get.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/user.dart';

class AccountPrivacyController extends GetxController {
  final userProvider = Get.put(UserProvider());
  final _authProvider = Get.find<AuthProvider>();
  final isPrivate = true.obs;
  late Future<User> getMe;

  @override
  void onInit() {
    super.onInit();
    getMe = _authProvider.getMe();
    getMe.then((user) {
      isPrivate.value = user.isPrivate;
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<User> updatePrivacy() async {
    return await userProvider.update(isPrivate: isPrivate.value);
  }
}
